create database test1
go
use test1
go

create table TRUONG(
	MaTruong char (5),
	TenTruong nvarchar(40),
	DiaChi nvarchar(50),
	NamTL int,
	ChiDoanTruong char(5),
	primary key (MaTruong)
)

create table LOPHOC(
	MaLop char(5),
	TenLop nvarchar(40),
	GVCN nvarchar(50),
	MaTruong char(5),
	LopTruong char(5),
	primary key (MaLop, MaTruong),
	foreign key (MaTruong) references TRUONG(MaTruong)
)

create table HOCSINH(
	MaHS char (5),
	MaTruong char(5),
	HoTen nvarchar(50),
	NgaySinh date,
	GioiTinh nchar(3),
	MaLop char(5),
	primary key (MaHS, MaTruong),
	foreign key (MaLop, MaTruong) references LOPHOC(MaLop, MaTruong)
)

alter table TRUONG add constraint FK_Truong_HocSinh foreign key (ChiDoanTruong, MaTruong) references HOCSINH(MaHS, MaTruong)
alter table LOPHOC add constraint FK_LopHoc_HocSinh foreign key (LopTruong, MaTruong) references HOCSINH(MaHS, MaTruong)

insert into TRUONG(MaTruong, TenTruong, DiaChi, NamTL, ChiDoanTruong)
values
('TR01', N'Lê Hồng Phong', N'225 Nguyễn Văn Cừ, Quận 5, TP.HCM', 1995, NULL),
('TR02', N'Lê Quý Đôn', N'125 Lê Quý Đôn, Quận 3, TP.HCM', 1993, NULL)

insert into LOPHOC(MaLop, TenLop, GVCN, MaTruong, LopTruong)
values
('LA001', N'10 chuyên Toán', N'Vương Hải', 'TR01', NULL),
('LA002', N'10 chuyên Văn', N'Nguyễn Hồng Hạnh', 'TR01', NULL),
('LD001', N'11 chuyên Anh', N'Trấn Trung Trí', 'TR02', NULL)

insert into HOCSINH(MaHS, MaTruong, HoTen, NgaySinh, GioiTinh, MaLop)
values
('HS01', 'TR01', N'Trần Hải', '1999/02/12', 'Nam', 'LA001'),
('HS02', 'TR01', N'Lê Anh Đào', '1987/12/30', N'Nữ', 'LA001'),
('HS03', 'TR01', N'Lý Khanh', '1960/6/6', 'Nam', 'LA002'),
('HS04', 'TR01', N'Phan Minh Trí', '1960/6/6', 'Nam', 'LA002'),
('HS01', 'TR02', N'Nguyễn Lan', '1982/3/7', N'Nữ', 'LD001'),
('HS02', 'TR02', N'Vũ Bình Phương', '1980/3/17', 'Nam', 'LD001'),
('HS03', 'TR02', N'Đặng Khải Minh', '1980/10/22', 'Nam', 'LD001')

update TRUONG set ChiDoanTruong = 'HS01' where MaTruong = 'TR01'
update TRUONG set ChiDoanTruong = 'HS01' where MaTruong = 'TR02'

update LOPHOC set LopTruong = 'HS02' where MaLop = 'LA001'
update LOPHOC set LopTruong = 'HS03' where MaLop = 'LA002'
update LOPHOC set LopTruong = 'HS01' where MaLop = 'LD001'

select LOPHOC.MaLop, LOPHOC.TenLop
from LOPHOC left join HOCSINH
on LOPHOC.LopTruong = HOCSINH.MaHS
where HOCSINH.HoTen like N'Nguyễn%'

select TRUONG.MaTruong, TRUONG.TenTruong, count(HOCSINH.MaHS) as SLHS
from TRUONG left join HOCSINH
on TRUONG.MaTruong = HOCSINH.MaTruong
group by TRUONG.MaTruong, TRUONG.TenTruong

select TRUONG.ChiDoanTruong, HOCSINH.HoTen
from TRUONG left join HOCSINH
on TRUONG.ChiDoanTruong = HOCSINH.MaHS
and TRUONG.MaTruong = HOCSINH.MaTruong
left join LOPHOC
on TRUONG.MaTruong = LOPHOC.MaTruong
group by TRUONG.MaTruong, TRUONG.ChiDoanTruong, TRUONG.TenTruong, HOCSINH.HoTen
having count(LOPHOC.MaLop) >= 2