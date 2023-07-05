USE QLGV
GO
DROP PROCEDURE IF EXISTS sp_Hello_World, sp_Tong_2_so_dang1, sp_Tong_2_so_dang2
GO

--Qa--
CREATE PROCEDURE sp_Hello_World @msg char(15)
AS
	print @msg
GO

EXEC sp_Hello_World 'Hello World'

--Qb--
GO
CREATE PROCEDURE sp_Tong_2_so_dang1 @so1 int, @so2 int
AS
	DECLARE @tong int
	SET @tong = @so1 + @so2
	PRINT @tong
GO

EXEC sp_Tong_2_so_dang1 1, 2

--Qc--
GO 
CREATE PROCEDURE sp_Tong_2_so_dang2 @so1 int, @so2 int, @tong int OUT
AS
	SET @tong = @so1 + @so2
RETURN @tong
GO

declare @sum int
exec sp_Tong_2_so_dang2 2, 3, @sum out
print @sum

--Qd--
DROP PROCEDURE IF EXISTS sp_Tong_3_so
GO
CREATE PROCEDURE sp_Tong_3_so @so1 int, @so2 int, @so3 int
AS
	DECLARE @tong1 int
	exec sp_Tong_2_so_dang2 @so1, @so2, @tong1 out
	DECLARE @tong2 int
	SET @tong2 = @tong1 + @so3
	PRINT @tong2
GO

exec sp_Tong_3_so 1, 2, 3

--Qe--
DROP PROCEDURE IF EXISTS sp_Tong_m_n
GO
CREATE PROCEDURE sp_Tong_m_n @m int, @n int
AS
	DECLARE @tong int
	SET @tong = 0
	DECLARE @i int
	SET @i = @m
	WHILE(@i <= @n)
		BEGIN
			SET @tong = @tong + @i
			SET @i = @i+1
		END
	PRINT @tong
GO

EXEC sp_Tong_m_n 1, 5

--Qf--
DROP PROCEDURE IF EXISTS sp_So_nguyen_to
GO
CREATE PROCEDURE sp_So_nguyen_to @n int, @bool int out
AS
	DECLARE @sum int
	DECLARE @temp int
	SET @sum = 0
	SET @temp = 1
	WHILE(@temp <= @n)
		BEGIN
			IF (@n %@temp) = 0
				SET @sum = @sum + 1
			SET @temp = @temp + 1
		END
	IF (@sum = 2)
		SET @bool = 1
	ELSE
		SET @bool = 0
GO

DECLARE @bool int
EXEC sp_So_nguyen_to 1, @bool out
print  @bool

--Qg--
DROP PROCEDURE IF EXISTS sp_Tong_nguyento_trong_m_n
GO
CREATE PROCEDURE sp_Tong_nguyento_trong_m_n @m int, @n int
AS
	DECLARE @tong int
	SET @tong = 0
	DECLARE @i int
	SET @i = @m
	DECLARE @check int
	WHILE(@i <= @n)
		BEGIN
			EXEC sp_So_nguyen_to @i, @check out
			IF (@check = 1)
				SET @tong = @tong + @i
			SET @i = @i+1
		END
	PRINT @tong
GO

EXEC sp_Tong_nguyento_trong_m_n 1, 10

--Qh--
DROP PROCEDURE IF EXISTS sp_UCLN
GO
CREATE PROCEDURE sp_UCLN @a int, @b int, @ucln int out
AS
	DECLARE @temp int
	IF (@a > @b)
	BEGIN
		SET @temp = @b
		WHILE(@temp > 0)
		BEGIN
			IF(@a % @temp = 0 AND @b % @temp = 0)
			BEGIN
				SET @ucln = @temp
				BREAK;
			END
			SET @temp = @temp - 1
		END
	END
	ELSE
	BEGIN
		SET @temp = 0
		SET @temp = @a
		WHILE(@temp > 0)
		BEGIN
			IF(@a % @temp = 0 AND @b % @temp = 0)
			BEGIN
				SET @ucln = @temp
				BREAK;
			END
			SET @temp = @temp - 1
		END
	END
GO

DECLARE @ucln int
exec sp_UCLN 28, 28, @ucln out
print @ucln

--Qi--
DROP PROCEDURE IF EXISTS sp_BCNN
GO
CREATE PROCEDURE sp_BCNN @a int, @b int, @bcnn int out
AS
BEGIN
	DECLARE @temp int
	DECLARE @max int
	SET @max = @a * @b
	IF (@a > @b)
	BEGIN
		SET @temp = @a
		WHILE(@temp <= @max)
		BEGIN
			IF (@temp % @a = 0 AND @temp % @b = 0)
			BEGIN
				SET @bcnn = @temp
				BREAK;
			END
			SET @temp = @temp + 1
		END
	END
	ELSE
	BEGIN
		SET @temp = @b
		WHILE(@temp <= @max)
		BEGIN
			IF (@temp % @a = 0 AND @temp % @b = 0)
			BEGIN
				SET @bcnn = @temp
				BREAK;
			END
			SET @temp = @temp + 1
		END
	END
END
GO

DECLARE @bcnn int
EXEC sp_BCNN 10, 4, @bcnn out
print @bcnn

USE QLGV
GO
--Qj--
DROP PROCEDURE IF EXISTS sp_Xuat_GiaoVien
GO
CREATE PROCEDURE sp_Xuat_GiaoVien
AS
BEGIN
	SELECT * FROM GIAOVIEN
END
GO

EXEC sp_Xuat_GiaoVien

--Qk--
DROP PROCEDURE IF EXISTS sp_SL_Detai
GO
CREATE PROCEDURE sp_SL_Detai @MAGV char(3)
AS
BEGIN
	SELECT COUNT(DISTINCT THAMGIADT.MADT) AS SLDT
	FROM GIAOVIEN
	LEFT JOIN THAMGIADT
	ON GIAOVIEN.MAGV = THAMGIADT.MAGV
	WHERE GIAOVIEN.MAGV = @MAGV
	GROUP BY GIAOVIEN.MAGV, GIAOVIEN.HOTEN
END
GO

EXEC sp_SL_Detai '003'

--Ql--
DROP PROCEDURE IF EXISTS sp_l
GO
CREATE PROCEDURE sp_l @MAGV char(3)
AS
BEGIN
	DECLARE @hoten nvarchar(100)
	DECLARE @luong int
	DECLARE @phai nvarchar(3)
	DECLARE @ngaysinh date
	DECLARE @sldt int
	DECLARE @slnt int
	DECLARE @diachi nvarchar (50)

	SELECT @hoten = GIAOVIEN.HOTEN, @luong = GIAOVIEN.LUONG, 
		@phai = GIAOVIEN.PHAI, @ngaysinh = GIAOVIEN.NGSINH, 
		@diachi = GIAOVIEN.DIACHI
	FROM GIAOVIEN
	WHERE GIAOVIEN.MAGV = @MAGV
	
	SELECT @sldt = COUNT(DISTINCT THAMGIADT.MADT)
	FROM GIAOVIEN
	LEFT JOIN THAMGIADT
	ON GIAOVIEN.MAGV = THAMGIADT.MAGV
	WHERE GIAOVIEN.MAGV = @MAGV
	GROUP BY GIAOVIEN.MAGV, GIAOVIEN.HOTEN

	SELECT @slnt = COUNT(DISTINCT NGUOITHAN.TEN)
	FROM GIAOVIEN
	LEFT JOIN NGUOITHAN
	ON GIAOVIEN.MAGV = NGUOITHAN.MAGV
	WHERE GIAOVIEN.MAGV = @MAGV

	print 'Ho ten: ' + @hoten
	print 'Gioi tinh: ' + @phai
	print 'Ngay sinh: ' + CONVERT(VARCHAR(100), @ngaysinh)
	print 'Dia chi: ' + @diachi
	print 'So luong de tai: ' + CONVERT(VARCHAR(1000), @sldt)
	print 'So luong nguoi than: ' + CONVERT(VARCHAR(1000), @slnt)
END
GO

exec sp_l '001'

--Qm--
DROP PROCEDURE IF EXISTS sp_KiemTraGVTonTai
GO
CREATE PROCEDURE sp_KiemTraGVTonTai @MaGV char(9), @check int out
AS
IF ( EXISTS (SELECT * FROM GIAOVIEN WHERE MAGV=@MAGV) )
BEGIN
	Print N'Giáo viên tồn tại'
	SET @check = 1
END
ELSE
BEGIN
	Print N'Không tồn tại giáo viên ! ' + @MaGV
	SET @check = 0
END
GO

DECLARE @check int
Exec sp_KiemTraGVTonTai '001', @check out
print @check

--Qn--
DROP PROCEDURE IF EXISTS sp_n
GO
CREATE PROCEDURE sp_n @MAGV char(3), @check int out
AS
BEGIN
	SET @check = 0

	IF (EXISTS(
		SELECT DISTINCT GV1.*, DT1.TENDT
		FROM GIAOVIEN AS GV1
		JOIN THAMGIADT AS TG1
		ON TG1.MAGV = GV1.MAGV
		LEFT JOIN DETAI AS DT1
		ON TG1.MADT = DT1.MADT
		LEFT JOIN GIAOVIEN AS GV2
		ON DT1.GVCNDT = GV2.MAGV
		WHERE GV1.MABM = GV2.MABM
		AND GV1.MAGV = @MAGV
	))
	BEGIN
		PRINT 'Giao vien thoa dieu kien'
		SET @check = 1
	END
	ELSE
	BEGIN
		PRINT 'Giao vien khong thoa dieu kien'
		SET @check = 0
	END
END
GO

DECLARE @temp int
Exec sp_n '001', @temp out
print @temp

--Qo--
DROP PROCEDURE IF EXISTS sp_o
GO
CREATE PROCEDURE sp_o @MAGV char(3), @MADT char(3), @STT char(3), @time int
AS
BEGIN
	DECLARE @check1 int
	DECLARE @check2 int
	DECLARE @check3 int
	SET @check1 = 0
	SET @check2 = 0
	SET @check3 = 0
	EXEC sp_n @MAGV, @check1
	Exec sp_KiemTraGVTonTai @MAGV, @check2 out
	IF(EXISTS(
		SELECT *
		FROM CONGVIEC
		WHERE CONGVIEC.MADT = @MADT
		AND CONGVIEC.SOTT = @STT
	))
		SET @check3 = 1
	ELSE
		SET @check3 = 0
	IF(@check1 = 1 AND @check2 = 1 AND @check3 = 1)
	BEGIN
		INSERT INTO THAMGIADT VALUES
		(@MAGV, @MADT, @STT, NULL, NULL)
	END
END
GO

--Qp--
DROP PROCEDURE IF EXISTS sp_p
GO
CREATE PROCEDURE sp_p @MAGV char(3)
AS
BEGIN
	BEGIN TRY
		DELETE FROM GIAOVIEN WHERE GIAOVIEN.MAGV = @MAGV
	END TRY
	BEGIN CATCH
		PRINT 'Error'
	END CATCH
END
GO

EXEC sp_p '001'

--Qq--
DROP PROCEDURE IF EXISTS sp_q
GO
CREATE PROCEDURE sp_q @MAGV char(3)
AS
BEGIN
	DECLARE @hoten nvarchar(100)
	DECLARE @luong int
	DECLARE @phai nvarchar(3)
	DECLARE @ngaysinh date
	DECLARE @sldt int
	DECLARE @slnt int
	DECLARE @diachi nvarchar (50)
	DECLARE @sgv int

	SELECT @hoten = GIAOVIEN.HOTEN, @luong = GIAOVIEN.LUONG, 
		@phai = GIAOVIEN.PHAI, @ngaysinh = GIAOVIEN.NGSINH, 
		@diachi = GIAOVIEN.DIACHI
	FROM GIAOVIEN
	WHERE GIAOVIEN.MAGV = @MAGV
	
	SELECT @sldt = COUNT(DISTINCT THAMGIADT.MADT)
	FROM GIAOVIEN
	LEFT JOIN THAMGIADT
	ON GIAOVIEN.MAGV = THAMGIADT.MAGV
	WHERE GIAOVIEN.MAGV = @MAGV
	GROUP BY GIAOVIEN.MAGV, GIAOVIEN.HOTEN

	SELECT @slnt = COUNT(DISTINCT NGUOITHAN.TEN)
	FROM GIAOVIEN
	LEFT JOIN NGUOITHAN
	ON GIAOVIEN.MAGV = NGUOITHAN.MAGV
	WHERE GIAOVIEN.MAGV = @MAGV

	SELECT @sgv = COUNT(GV2.MAGV)
	FROM GIAOVIEN AS GV1
	LEFT JOIN GIAOVIEN AS GV2
	ON GV1.MAGV = GV2.GVQLCM
	WHERE GV1.MAGV = @MAGV
	GROUP BY GV1.MAGV

	print 'Ho ten: ' + @hoten
	print 'Gioi tinh: ' + @phai
	print 'Ngay sinh: ' + CONVERT(VARCHAR(100), @ngaysinh)
	print 'Dia chi: ' + @diachi
	print 'So luong de tai: ' + CONVERT(VARCHAR(1000), @sldt)
	print 'So luong nguoi than: ' + CONVERT(VARCHAR(1000), @slnt)
	print 'So luong giao vien dang quan ly: ' + CONVERT(VARCHAR(1000), @sgv)
END
GO

exec sp_q '001'

--Qr--
DROP PROCEDURE IF EXISTS sp_r
GO
CREATE PROCEDURE sp_r @MAGV1 char(3), @MAGV2 char(3)
AS
BEGIN
	DECLARE @matruongbomon char(3)
	DECLARE @luong1 float
	DECLARE @luong2 float

	SELECT @luong1 = GV.LUONG
	FROM GIAOVIEN AS GV
	WHERE GV.MAGV = @MAGV1

	SELECT @luong2 = GV.LUONG
	FROM GIAOVIEN AS GV
	WHERE GV.MAGV = @MAGV2

	SELECT @matruongbomon = GV2.MAGV
	FROM GIAOVIEN AS GV1
	LEFT JOIN BOMON AS BM1
	ON GV1.MABM = BM1.MABM
	LEFT JOIN GIAOVIEN AS GV2
	ON BM1.TRUONGBM = GV2.MAGV
	WHERE GV1.MAGV = @MAGV2

	IF (@matruongbomon = @MAGV1 AND @luong1 > @luong2)
		print N'Lương đúng quy định'
	IF (@matruongbomon = @MAGV1 AND @luong1 <= @luong2)
		print N'Lương không đúng quy định'
	IF (@matruongbomon = @MAGV2 AND @luong2 > @luong1)
		print N'Lương đúng quy định'
	IF (@matruongbomon = @MAGV2 AND @luong1 >= @luong2)
		print N'Lương không đúng quy định'
END
GO

EXEC sp_r '001', '009'
EXEC sp_r '002', '003'

--Qs--
DROP PROCEDURE IF EXISTS sp_s
GO
CREATE PROCEDURE sp_s @MAGV char(5), @HOTEN nvarchar(40), @LUONG float, @PHAI nvarchar(3), @NGSINH date, @DIACHI nvarchar(50), @GVQLCM char(5), @MABM char(5)
AS
BEGIN
	DECLARE @check1 int
	DECLARE @check2 int
	DECLARE @check3 int
	SET @check1 = 0
	SET @check2 = 0
	SET @check3 = 0
	IF(NOT EXISTS(SELECT GIAOVIEN.HOTEN FROM GIAOVIEN WHERE GIAOVIEN.HOTEN = @HOTEN))
	BEGIN
		SET @check1 = 1
	END
	ELSE
	BEGIN
		PRINT N'Trùng tên'
	END

	IF(2023 - YEAR(@NGSINH) >= 18)
	BEGIN
		SET @check2 = 1
	END
	ELSE
	BEGIN
		PRINT N'Nhỏ hơn 18 tuổi'
	END
	IF(@LUONG > 0)
	BEGIN
		SET @check3 = 1
	END
	ELSE
	BEGIN
		PRINT N'Lương âm'
	END

	IF(@check1 = 1 AND @check2 = 1 AND @check3 = 1)
	BEGIN
		INSERT INTO GIAOVIEN VALUES
		(@MAGV, @HOTEN, @LUONG, @PHAI, @NGSINH, @DIACHI, @GVQLCM, @MABM)
	END
END
GO

EXEC sp_s '011', N'Nguyễn Hoài An', -1, N'Nam', '2010-02-15', N'25/3 Lạc Long Quân, Q.10, TP HCM', NULL, NULL
EXEC sp_s '011', N'Lê Phạm Hoàng Trung', 1700, N'Nam', '2003-10-25', N'Ấp Giáp Nước, xã Phước Thạnh, thành phố Mỹ Tho, tỉnh Tiền Giang', NULL, 'VLĐT'

--Qt--
DROP PROCEDURE IF EXISTS sp_t
GO
CREATE PROCEDURE sp_t @HOTEN nvarchar(40), @LUONG float, @PHAI nvarchar(3), @NGSINH date, @DIACHI nvarchar(50), @GVQLCM char(5), @MABM char(5)
AS
BEGIN
    DECLARE @MaGiaoVien CHAR(3)
    DECLARE @MaxMaGiaoVien CHAR(3)
    SET @MaxMaGiaoVien = (SELECT MAX(GIAOVIEN.MAGV) FROM GIAOVIEN)

    IF @MaxMaGiaoVien IS NULL
        SET @MaGiaoVien = '001'
    ELSE
        SET @MaGiaoVien = RIGHT('000' + CAST((CAST(@MaxMaGiaoVien AS INT) + 1) AS VARCHAR(3)), 3)

    INSERT INTO GIAOVIEN VALUES (@MaGiaoVien, @HOTEN, @LUONG, @PHAI, @NGSINH, @DIACHI, @GVQLCM, @MABM)
END
GO
EXEC sp_t N'Võ Thu Trang', 1800, N'Nữ', '2003-06-20', N'Bảo Lộc, Lâm Đồng', NULL, 'VS'

