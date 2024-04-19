create schema btvn01;
use btvn01;
create table KhachHang
(
    MaKH varchar(4) primary key not null,
    TenKH varchar(30) not null,
    Diachi varchar(50),
    Ngaysinh datetime,
    SoDT varchar(15) unique
);
create table NhanVien
(
    MaNV varchar(4) primary key not null,
    HoTen varchar(30) not null,
    GioiTinh bit not null,
    DiaChi varchar(50) not null,
    NgaySinh datetime not null,
    Dienthoai varchar(15),
    Email tinytext,
    NoiSinh varchar(20) not null,
    NgayVaoLam datetime,
    MaNQL varchar(4)
);
create table NhaCungCap
(
    MaNCC varchar(5) primary key not null,
    TenNCC varchar(50) not null,
    Diachi varchar(50) not null,
    Dienthoai varchar(15) not null,
    Email varchar(30) not null,
    Website varchar(30)
);
create table LoaiSP
(
    MaloaiSP varchar(4) primary key not null,
    TenloaiSP varchar(30) not null,
    Ghichu varchar(100)
);
create table SanPham
(
    MaSP varchar(4) primary key not null,
    MaloaiSP varchar(4) not null,
    TenSP varchar(50) not null,
    Donvitinh varchar(10) not null,
    Ghichu varchar(100)
);
create table PhieuNhap
(
    SoPN varchar(5) primary key not null,
    MaNV varchar(4) not null,
    MaNCC varchar(5) not null,
    Ngaynhap datetime not null,
    Ghichu varchar(100)
);
create table CTPhieuNhap
(
    MaSP varchar(4) not null,
    SoPN varchar(5) not null,
    primary key (MaSP, SoPN),
    SoLuong smallint not null,
    Gianhap real not null check (Gianhap > 0)
);
create table PhieuXuat
(
    SoPX varchar(5) primary key not null,
    MaNV varchar(4) not null,
    MaKH varchar(4) not null,
    Ngayban datetime not null,
    Ghichu tinytext
);
create table CTPhieuXuat
(
    SoPX varchar(5) not null,
    MaSP varchar(4) not null,
    primary key (SoPX, MaSP),
    SoLuong smallint not null check(SoLuong > 0),
    GiaBan real not null check(GiaBan > 0)
);
alter table PhieuNhap
    add constraint fk_MaNCC
        foreign key (MaNCC) references NhaCungCap (MaNCC),
    add constraint fk_MaNV
        foreign key (MaNV) references NhanVien (MaNV)
;
alter table CTPhieuNhap
    add constraint fk_MaSP
        foreign key (MaSP) references SanPham (MaSP),
    add constraint fk_SoPN
        foreign key (SoPN) references PhieuNhap (SoPN)
;
alter table SanPham
    add constraint fk_MaloaiSP
        foreign key (MaloaiSP) references LoaiSP (MaloaiSP)
;
alter table PhieuXuat
    add constraint fk_MaNVPX
        foreign key (MaNV) references NhanVien (MaNV),
    add constraint fk_MaKHPX
        foreign key (MaKH) references KhachHang (MaKH)
;
alter table CTPhieuXuat
    add constraint fk_SoPX
        foreign key (SoPX) references PhieuXuat (SoPX),
    add constraint fk_MaSPPX
        foreign key (MaSP) references SanPham (MaSP)
;

insert into nhanvien(manv, hoten, gioitinh, diachi, ngaysinh, dienthoai, email, noisinh, ngayvaolam, manql)
values (2, 'nguyen van b', 1, 'ha noi', '1992-09-6', 0941223545, 'exam@gmail.com', 'ha noi', now(), null);
insert into nhacungcap(mancc, tenncc, diachi, dienthoai, email, website)
values (1, 'ncca', 'Ha noi', '0921235621', 'email@email.com', null);
insert into khachhang(makh, tenkh, diachi, ngaysinh, sodt)
values (3, 'nguyen thi n', 'thanh tri', '1988-1-19', '0988765238');
insert into phieunhap(sopn, manv, mancc, ngaynhap, ghichu)
values (1, 1, 1, now(), null);
insert into phieunhap(sopn, manv, mancc, ngaynhap, ghichu)
values (2, 1, 1, now(), null);
insert into phieuxuat(sopx, manv, makh, ngayban, ghichu)
values (1, 1, 1, now(), null);
insert into phieuxuat(sopx, manv, makh, ngayban, ghichu)
values (2, 1, 1, now(), null);

UPDATE `btvn01`.`KhachHang` SET `SoDT` = '0987654321' WHERE (`MaKH` = '1');
UPDATE nhanvien SET diachi = 'Hai phong' WHERE manv = 1;

# delete from nhanvien where manv = 1;
# delete from sanpham where masp = 15;

select manv, hoten, gioitinh, ngaysinh, diachi, dienthoai, year(curdate())-year(ngaysinh) as tuoi from NhanVien order by tuoi;