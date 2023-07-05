-- SU DUNG CSDL "QUAN LY GIAO VIEN THAM GIA DE TAI"
USE QLGV
GO

DROP PROCEDURE IF EXISTS sp_use_vtable
GO

CREATE PROCEDURE sp_use_vtable
AS
BEGIN
	-- Khai bao bien kieu TABLE
	DECLARE @vtable TABLE (MaGV nchar(10), TenGV nvarchar(100));

	-- Nap du lieu vao @vtable
	INSERT INTO @vtable
		SELECT MAGV, HOTEN
		FROM GIAOVIEN
		WHERE MABM = 'HTTT';

	-- Xac dinh so dong du lieu trong @vtable
	DECLARE @count int;
	SELECT @count = count(*)
		FROM @vtable;

	-- Duyet lan luot tung dong du lieu trong @vtable
	DECLARE @MaGV nchar(10), @TenGV nvarchar(100), @MaBM char(10);
	WHILE ( @count > 0 ) -- lap cho den khi moi dong du lieu trong @vtable duoc xu ly het
	BEGIN
		-- Chon ra dong du lieu dau tien trong @vtable
		SELECT TOP 1 @MaGV = vt.MaGV, @TenGV = vt.TenGV, @MaBM = GV.MABM
			FROM @vtable vt, GIAOVIEN GV
			WHERE vt.MaGV = GV.MAGV;

		-- Thuc hien xu ly voi cac thong tin duoc chon ra
		print @MaGV + ' : ' + @TenGV + ' @ ' + @MaBM;

		-- Xoa dong du lieu tuong ung da thuc hien trong @vtable
		DELETE @vtable WHERE MaGV = @MaGV;

		SET @count = @count -1;
	END
END
GO

EXEC sp_use_vtable