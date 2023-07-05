create database test2
go
use test2
go

create table PHONGBAN(
	MaPhongBan char(5),
	TenPhongBan nvarchar (50),
	DiaDiem nvarchar (50),
	TruongPhong char (5),
	primary key (MaPhongBan)
)

create table DEAN(
	MaDeAn char (5),
	TenDeAn nvarchar (50),
	ThoiGian  int,
	MaPhongBan char (5),
	TruongDeAn char (5),
	primary key (MaDeAn),
	foreign key (MaPhongBan) references PHONGBAN(MaPhongBan)
)

create table NHANVIEN(
	MaNV char (5),
	MaPhong char (5),
	HoTen nvarchar (50),
	NgaySinh date,
	GioiTinh nchar (4),
	Luong int,
	primary key (MaNV, MaPhong),
	foreign key (MaPhong) references PHONGBAN(MaPhongBan)
)

alter table PHONGBAN add constraint FK_PhongBan_NhanVien foreign key (TruongPhong, MaPhongBan) references NHANVIEN(MaNV, MaPhong)
alter table DEAN add constraint FK_DeAn_NhanVien foreign key (TruongDeAn, MaPhongBan) references NHANVIEN(MaNV, MaPhong)

insert into PHONGBAN
values
('P001', N'Nghiên cứu', 'C444', NULL),
('P002', N'Kế hoạch', 'B234', NULL),
('P003', N'Nhân sự', 'D111', NULL)

insert into DEAN
values
('DA01', N'Ngôi nhà thông minh', 120, 'P001', NULL),
('DA02', N'Hành tinh xanh', 220, 'P002', NULL),
('DA03', N'Công viên xanh', 100, 'P002', NULL)

insert into NHANVIEN
values
('NV01', 'P001', N'Trần Hải', '1000/02/12', 'Nam', 2500),
('NV02', 'P001', N'Lê Anh Đào', '1987/12/30', N'Nữ', 3000),
('NV01', 'P002', N'Lý Khanh', '1960/6/6', 'Nam', 1000),
('NV02', 'P002', N'Phan Minh Trí','1960/6/6', 'Nam' ,2500),
('NV03', 'P002', N'Nguyễn Lan', '1982/3/7', N'Nữ', 3000),
('NV01', 'P003', N'Vũ Bình Phương', '1980/3/17', 'Nam', 3000),
('NV02', 'P003', N'Đặng Khải Minh', '1980/10/22', 'Nam', 1400)

update PHONGBAN set TruongPhong = 'NV02' where MaPhongBan = 'P001'
update PHONGBAN set TruongPhong = 'NV03' where MaPhongBan = 'P002'
update PHONGBAN set TruongPhong = 'NV01' where MaPhongBan = 'P003'

update DEAN set TruongDeAn = 'NV02' where MaDeAn = 'DA01'
update DEAN set TruongDeAn = 'NV01' where MaDeAn = 'DA02'
update DEAN set TruongDeAn = 'NV02' where MaDeAn = 'DA03'

select distinct NHANVIEN.MaNV, NHANVIEN.HoTen
from NHANVIEN right join PHONGBAN
on NHANVIEN.MaNV = PHONGBAN.TruongPhong
and NHANVIEN.MaPhong = PHONGBAN.MaPhongBan
join DEAN
on NHANVIEN.MaNV = DEAN.TruongDeAn
and DEAN.MaPhongBan = PHONGBAN.MaPhongBan

select PHONGBAN.MaPhongBan, PHONGBAN.TenPhongBan, NV1.HoTen, count(NV2.MANV) as SLNV
from PHONGBAN left join NHANVIEN as NV1
on PHONGBAN.TruongPhong = NV1.MaNV
and PHONGBAN.MaPhongBan = NV1.MaPhong
right join NHANVIEN as NV2
on PHONGBAN.MaPhongBan = NV2.MaPhong
group by PHONGBAN.MaPhongBan, PHONGBAN.TenPhongBan, NV1.HoTen

select PHONGBAN.MaPhongBan, PHONGBAN.TenPhongBan
from PHONGBAN left join DEAN
on PHONGBAN.MaPhongBan = DEAN.MaPhongBan
group by PHONGBAN.MaPhongBan, PHONGBAN.TenPhongBan
having count(DEAN.MaDeAn) >= 2