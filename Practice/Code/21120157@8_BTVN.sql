DROP DATABASE IF EXISTS QLPhong
GO

CREATE DATABASE QLPhong
GO
USE QLPhong
GO

-- Tạo bảng Phòng --
CREATE TABLE PHONG (
	MaPhong char(3),
	TinhTrang nvarchar(10),
	LoaiPhong nvarchar(10),
	DonGia float
	PRIMARY KEY (MaPhong)
)

-- Tạo bảng Khách --
CREATE TABLE KHACH(
	MaKH char(3),
	HoTen nvarchar(40),
	DiaChi nvarchar(50),
	DienThoai char(11),
	PRIMARY KEY (MaKH)
)

-- Tạo bảng Đặt phòng --
CREATE TABLE DATPHONG(
	Ma char(3),
	MaKH char(3),
	MaPhong char(3),
	NgayDat date,
	NgayTra date,
	ThanhTien float,
	PRIMARY KEY (Ma),
	FOREIGN KEY (MaKH) REFERENCES KHACH(MaKH),
	FOREIGN KEY (MaPhong) REFERENCES PHONG(MaPhong)
)

-- Khởi tạo giá trị cho các bảng --
INSERT INTO PHONG VALUES
('001', N'Rảnh', N'Đôi', 1000),
('002', N'Rảnh', N'Đôi', 1200),
('003', N'Rảnh', N'Đơn', 800),
('004', N'Rảnh', N'Đơn', 800),
('005', N'Rảnh', N'Đôi', 1100),
('006', N'Rảnh', N'Đơn', 1000)

INSERT INTO KHACH VALUES
('001', N'Lê Văn A', N'Mỹ Tho, Tiền Giang', '0985111222'),
('002', N'Võ Văn B', N'Bảo Lộc, Lâm Đồng', '0985222333'),
('003', N'Nguyễn Văn C', N'Dĩ An, Bình Dương', '0985333444'),
('004', N'Hồ Hải D', N'Thủ Đức, TP. Hồ Chí Minh', '0582092222'),
('005', N'Văn Lâm E', N'Quận 5, TP. Hồ Chí Minh', '0582093333'),
('006', N'Lê Hình F', N'Rạch Giá, Kiên Giang', '0123444555'),
('007', N'Cao Thị G', N'Mỏ Cày Bắc, Bến Tre', '0237666345')

--Q1--
DROP PROCEDURE IF EXISTS spDatPhong
GO
CREATE PROCEDURE spDatPhong @makh char(3), @maphong char(3), @ngaydat date
AS
BEGIN
	DECLARE @check1 int, @check2 int, @check3 int
	-- Khởi tạo các biến check = 0 (False)
	SET @check1 = 0
	SET @check2 = 0

	-- Check xem mã phòng có tồn tại và đang trong tình trạng rảnh hay không, nếu có thì cho biến check1 = 1 (True)
	IF (EXISTS(SELECT PHONG.* FROM PHONG WHERE PHONG.MaPhong = @maphong AND PHONG.TinhTrang = N'Rảnh'))
	BEGIN
		SET @check1 = 1
	END
	ELSE
	BEGIN
		PRINT N'Mã Phòng không tồn tại'
	END

	-- Check xem mã khách hàng có tồn tại hay không, nếu có thì cho biến check2 = 1 (True)
	IF (EXISTS(SELECT KHACH.* FROM KHACH WHERE KHACH.MaKH = @makh))
	BEGIN
		SET @check2 = 1
	END
	ELSE
	BEGIN
		PRINT N'Mã Khách hàng không tồn tại'
	END

	-- Nếu mã khách hàng, mã phòng có tồn tại và phòng còn rảnh thì cho phép đặt -- 
	IF(@check1 = 1 AND @check2 = 1)
	BEGIN
		DECLARE @Ma char(3), @MaxMa char(3)
		SET @MaxMa = (SELECT MAX(Ma) FROM DATPHONG)
		IF @MaxMa IS NULL
			SET @Ma = '001'
		ELSE
			SET @Ma = RIGHT('000' + CAST((CAST(@MaxMa AS INT) + 1) AS VARCHAR(3)), 3)

		-- Insert thông tin đặt phòng vào bảng DATPHONG bao gồm: --
		-- + Mã đặt phòng là số nguyên phát sinh tự động --
		-- + Mã phòng --
		-- + Mã khách hàng --
		-- + Ngày đặt --
		-- + Hai thông tin còn lại NULL --
		INSERT INTO DATPHONG VALUES (@Ma, @makh, @maphong, @ngaydat, NULL, NULL)
		-- Cập nhật tình trạng phòng thành Bận --
		UPDATE PHONG SET TinhTrang = N'Bận' WHERE MaPhong = @maphong
	END
END
GO

EXEC spDatPhong '004', '002', '2023-05-20'
EXEC spDatPhong '003', '002', '2023-05-20'

--Q2--
DROP PROCEDURE IF EXISTS spTraPhong
GO
CREATE PROCEDURE spTraPhong @madp char(3), @makh char(3)
AS
BEGIN
	-- Khởi tạo các biến kiểm tra, biến đếm số ngày thuê phòng, biến đơn giá và biến mã phòng --
	DECLARE @check1 int
	DECLARE @day int
	DECLARE @dongia float
	DECLARE @maphong char(3)

	SET @check1 = 0
	SET @day = 0
	SET @dongia = 0

	-- Kiểm tra xem mã khách hàng và mã đặt phòng có thoả điều kiện hay không --
	IF(EXISTS(SELECT DATPHONG.* FROM DATPHONG WHERE DATPHONG.Ma = @madp AND DATPHONG.MaKH = @makh AND DATPHONG.NgayTra IS NULL))
		SET @check1 = 1
	-- Nếu thoả điều kiện --
	IF (@check1 = 1)
	BEGIN
		-- Query lấy đơn giá phòng và mã phòng dựa trên mã đặt phòng và mã khách hàng --
		SELECT @dongia = PHONG.DonGia, @maphong = PHONG.MaPhong
		FROM PHONG
		RIGHT JOIN DATPHONG
		ON DATPHONG.MaPhong = PHONG.MaPhong
		WHERE DATPHONG.Ma = @madp AND DATPHONG.MaKH = @makh

		-- Câu truy vấn tính số ngày thuê phòng --
		SELECT @day = DATEDIFF(DAY, DATPHONG.NgayDat, GETDATE()) 
		FROM DATPHONG 
		WHERE DATPHONG.Ma = @madp
		AND DATPHONG.MaKH = @makh

		-- Update thành tiền, ngày trả và tình trạng phòng
		UPDATE DATPHONG SET NgayTra = GETDATE() WHERE Ma = @madp AND MaKH = @makh
		UPDATE DATPHONG SET ThanhTien = @day * @dongia
		UPDATE PHONG SET TinhTrang = N'Rảnh' WHERE MaPhong = @maphong
	END
	-- Các trường hợp còn lại --
	ELSE
	BEGIN
		PRINT N'Phòng chưa được đặt hoặc thông tin không hợp lệ'
	END
END
GO

EXEC spTraPhong '004', '004'