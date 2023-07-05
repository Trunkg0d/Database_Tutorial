﻿USE QLGV
GO

--1--
SELECT TOP 1 BOMON.TENBM, COUNT(DISTINCT GV_DT.MAGV)
FROM GIAOVIEN
RIGHT JOIN BOMON
ON GIAOVIEN.MABM = BOMON.MABM
LEFT JOIN GV_DT
ON GIAOVIEN.MAGV = GV_DT.MAGV
GROUP BY BOMON.TENBM
ORDER BY COUNT(DISTINCT GV_DT.MAGV) DESC

--2--
SELECT DISTINCT GV1.HOTEN, COUNT (DISTINCT TG1.MADT)
FROM GIAOVIEN AS GV1
JOIN THAMGIADT AS TG1
ON GV1.MAGV = TG1.MAGV
WHERE TG1.MADT IN (
	SELECT DISTINCT DT2.MADT
	FROM DETAI AS DT2
	LEFT JOIN GIAOVIEN AS GV2
	ON GV2.MAGV = DT2.GVCNDT
	WHERE GV2.HOTEN = N'Trương Nam Sơn'
) AND GV1.HOTEN != N'Trương Nam Sơn'
GROUP BY GV1.HOTEN
HAVING COUNT (DISTINCT TG1.MADT) = (
	SELECT COUNT(DISTINCT DT2.MADT)
	FROM DETAI AS DT2
	LEFT JOIN GIAOVIEN AS GV2
	ON GV2.MAGV = DT2.GVCNDT
	WHERE GV2.HOTEN = N'Trương Nam Sơn'
)

--3--
SELECT DISTINCT GV1.HOTEN
FROM GIAOVIEN AS GV1
JOIN THAMGIADT AS TG1
ON GV1.MAGV = TG1.MAGV
WHERE TG1.MADT IN (
	SELECT DT2.MADT
	FROM DETAI AS DT2
	WHERE DT2.KINHPHI > 80
)
GROUP BY GV1.HOTEN, TG1.MAGV
HAVING COUNT (DISTINCT TG1.MADT) = (
	SELECT COUNT(DISTINCT DT2.MADT)
	FROM DETAI AS DT2
	RIGHT JOIN THAMGIADT AS TG2
	ON DT2.MADT = TG2.MADT
	WHERE DT2.KINHPHI > 80
	AND TG2.MAGV = TG1.MAGV
)

--4--
DROP PROCEDURE IF EXISTS spHienThi_DSGV_ThamGia_DeTai
GO
CREATE PROCEDURE spHienThi_DSGV_ThamGia_DeTai @tu_ngay DATE, @den_ngay DATE
AS
BEGIN
	IF(DATEDIFF(DAY, @tu_ngay, @den_ngay) > 0)
	BEGIN
		DECLARE @v_table TABLE(MADT CHAR(3), NGAYBD DATE, NGAYKT DATE)
		INSERT INTO @v_table SELECT DETAI.MADT, DETAI.NGAYBD, DETAI.NGAYKT FROM DETAI

		-- Init variable --
		DECLARE @ngay_bd DATE, @ngay_kt DATE, @madt char(3)
		DECLARE @count int, @sldt int
		SET @count = 0
		SET @sldt = 0
		SELECT @count = COUNT(*)
		FROM @v_table AS vt
		PRINT @count

		-- Loop --
		WHILE(@count > 0)
		BEGIN
			-- Lay du lieu --
			SELECT TOP 1 @madt = vt.MADT, @ngay_bd = vt.NGAYBD, @ngay_kt = vt.NGAYKT FROM @v_table AS vt

			-- Xu ly du lieu --
			IF(DATEDIFF(DAY, @tu_ngay, @ngay_bd) >= 0 AND DATEDIFF(DAY, @ngay_kt, @den_ngay) >= 0)
			BEGIN
				SET @sldt = @sldt + 1

				-- Xuat tat ca thong tin cua de tai kem so luong Gv tham gia de tai do, bo qua GVCNDT --
				SELECT DETAI.*, COUNT(DISTINCT GIAOVIEN.MAGV) AS SLGV
				FROM DETAI
				LEFT JOIN THAMGIADT
				ON DETAI.MADT = THAMGIADT.MADT
				LEFT JOIN GIAOVIEN
				ON GIAOVIEN.MAGV = THAMGIADT.MAGV
				WHERE GIAOVIEN.MAGV != DETAI.GVCNDT
				AND DETAI.MADT = @madt
				GROUP BY DETAI.MADT, DETAI.TENDT, DETAI.CAPQL, DETAI.KINHPHI, DETAI.NGAYBD, DETAI.NGAYKT, DETAI.MACD, DETAI.GVCNDT

				-- Xuất thông tin GV làm chủ nhiệm đề tài này. --
				SELECT GIAOVIEN.*
				FROM GIAOVIEN
				RIGHT JOIN DETAI
				ON GIAOVIEN.MAGV = DETAI.GVCNDT
				WHERE DETAI.MADT = @madt

				-- Xuất danh sách các GV tham gia đề tài này (bỏ qua GVCNDT nếu có) theo tuổi giảm dần. --
				SELECT DISTINCT GIAOVIEN.*
				FROM GIAOVIEN
				RIGHT JOIN THAMGIADT
				ON GIAOVIEN.MAGV = THAMGIADT.MAGV
				LEFT JOIN DETAI
				ON THAMGIADT.MADT = DETAI.MADT
				WHERE THAMGIADT.MADT = @madt
				AND DETAI.GVCNDT != GIAOVIEN.MAGV
				ORDER BY GIAOVIEN.NGSINH ASC
			END
			
			-- Xoa dong vua lay ra va giam count --
			DELETE VT FROM @v_table AS VT WHERE VT.MADT = @madt
			SET @count = @count - 1
		END
		IF(@sldt != 0)
		BEGIN
			PRINT N'Số lượng đề tài thoả yêu cầu là: ' + CAST(@sldt AS CHAR(100))
		END
		ELSE
		BEGIN
			RETURN -1
		END
	END
	ELSE
	BEGIN
		PRINT N'Ngày nhập vào không hợp lệ'
		RETURN -1
	END
END
GO

EXEC spHienThi_DSGV_ThamGia_DeTai '2006-10-20', '2010-10-20'