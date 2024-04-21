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
    Ngaynhap datetime not null default now(),
    Ghichu varchar(100)
);
create table CTPhieuNhap
(
    MaSP varchar(4) not null,
    SoPN varchar(5) not null,
    primary key (MaSP, SoPN),
    SoLuong smallint not null default 0,
    Gianhap real not null check (Gianhap > 0)
);
create table PhieuXuat
(
    SoPX varchar(5) primary key not null,
    MaNV varchar(4) not null,
    MaKH varchar(4) not null,
    Ngayban datetime not null check (Ngayban >= now()),
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

use btvn01;
# 1. Liệt kê thông tin về nhân viên trong cửa hàng, gồm: mã nhân viên, họ tên
# nhân viên, giới tính, ngày sinh, địa chỉ, số điện thoại, tuổi. Kết quả sắp xếp
# theo tuổi.
select manv, hoten, gioitinh, ngaysinh, diachi, dienthoai, year(curdate())-year(ngaysinh) as tuoi from NhanVien order by tuoi;

# 2. Liệt kê các hóa đơn nhập hàng trong tháng 6/2018, gồm thông tin số phiếu
# nhập, mã nhân viên nhập hàng, họ tên nhân viên, họ tên nhà cung cấp, ngày
# nhập hàng, ghi chú.
select PN.sopn, NV.hoten as HoTenNhanVien, PN.ngaynhap, NCC.tenncc as TenNhaCungCap
from phieunhap PN join NhanVien NV on PN.MaNV = NV.MaNV join nhacungcap NCC on PN.MaNCC = NCC.MaNCC
where YEAR(Ngaynhap) = 2018 and month(Ngaynhap) = 6;

# 3. Liệt kê tất cả sản phẩm có đơn vị tính là chai, gồm tất cả thông tin về sản phẩm.
select * from sanpham where Donvitinh = 'chai';

# 4. Liệt kê chi tiết nhập hàng trong tháng hiện hành gồm thông tin: số phiếu
# nhập, mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính, số lượng, giá
# nhập, thành tiền.
select CTPN.sopn, CTPN.masp, SP.tensp, SP.MaloaiSP, SP.Donvitinh, CTPN.soluong, CTPN.gianhap, CTPN.gianhap * CTPN.soluong as ThanhTien
from ctphieunhap as CTPN
join sanpham as SP on CTPN.MaSP = SP.MaSP
where month(current_date());

# 5. Liệt kê các nhà cung cấp có giao dịch mua bán trong tháng hiện hành, gồm
# thông tin: mã nhà cung cấp, họ tên nhà cung cấp, địa chỉ, số điện thoại,
# email, số phiếu nhập, ngày nhập. Sắp xếp thứ tự theo ngày nhập hàng.
select PN.mancc, NCC.tenncc, NCC.diachi, NCC.dienthoai, PN.sopn, PN.ngaynhap
from phieunhap as PN
join nhacungcap as NCC on PN.MaNCC = NCC.MaNCC
where month(PN.Ngaynhap) = 4
order by PN.Ngaynhap desc ;

# 6. Liệt kê chi tiết hóa đơn bán hàng trong 6 tháng đầu năm 2018 gồm thông tin:
# số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên sản phẩm, đơn vị tính, số lượng, giá bán, doanh thu.
select CTPX.sopx, NV.hoten as NhanVienBanHang, PX.ngayban, SP.masp, SP.tensp, SP.donvitinh, CTPX.giaban, CTPX.giaban * CTPX.soluong as DoanhThu
from ctphieuxuat CTPX join phieuxuat PX on CTPX.SoPX = PX.SoPX
join nhanvien NV on PX.MaNV = NV.MaNV
join sanpham SP on CTPX.MaSP = SP.MaSP
where month(PX.Ngayban) between 01 and 06;

# 7. Hãy in danh sách khách hàng có ngày sinh nhật trong tháng hiện hành (gồm
# tất cả thông tin của khách hàng)
select * from NhanVien where month(NgaySinh) = current_date();


# 8. Liệt kê các hóa đơn bán hàng từ ngày 15/04/2018 đến 15/05/2018 gồm các
# thông tin: số phiếu xuất, nhân viên bán hàng, ngày bán, mã sản phẩm, tên
# sản phẩm, đơn vị tính, số lượng, giá bán, doanh thu.
select CTPX.sopx, NV.manv, PX.ngayban, SP.masp, SP.tensp, SP.donvitinh, CTPX.soluong, CTPX.giaban, sum(CTPX.soluong * CTPX.giaban) as DoanhThu
from ctphieuxuat CTPX join sanpham SP on CTPX.MaSP = SP.MaSP
join phieuxuat PX on CTPX.SoPX = PX.SoPX
join nhanvien NV on PX.MaNV = NV.MaNV
where PX.Ngayban between '2024-02-14' and '2024-05-16';

# 9. Liệt kê các hóa đơn mua hàng theo từng khách hàng, gồm các thông tin: số
# phiếu xuất, ngày bán, mã khách hàng, tên khách hàng, trị giá.
select PX.sopx, PX.ngayban, PX.makh, KH.tenkh, sum(CTPX.giaban * CTPX.soluong) as trigia
from phieuxuat PX join ctphieuxuat CTPX on PX.SoPX = CTPX.SoPX
join khachhang KH on PX.MaKH = KH.MaKH
group by KH.MaKH;

# 10. Cho biết tổng số chai nước xả vải Comfort đã bán trong 6 tháng đầu năm
# 2018. Thông tin hiển thị: tổng số lượng.
select sum(CTPX.soluong) as TongSoLuong
from ctphieuxuat CTPX join phieuxuat PX on CTPX.SoPX = PX.SoPX
join sanpham SP on CTPX.MaSP = SP.MaSP
where year(PX.Ngayban) = 2018 and month(PX.Ngayban) between 01 and 06 and SP.tensp = 'Comfort';

# 11.Tổng kết doanh thu theo từng khách hàng theo tháng, gồm các thông tin:
# tháng, mã khách hàng, tên khách hàng, địa chỉ, tổng tiền.
select month(px.ngayban) as 'Month', KH.makh, KH.tenkh, KH.diachi, sum(CTPX.soluong * CTPX.giaban) as TongTien
from khachhang KH join phieuxuat PX on KH.MaKH = PX.MaKH join ctphieuxuat CTPX on PX.SoPX = CTPX.SoPX
group by month(px.ngayban), KH.makh, KH.tenkh, KH.diachi;

# 12.Thống kê tổng số lượng sản phẩm đã bán theo từng tháng trong năm, gồm
# thông tin: năm, tháng, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số lượng.
select year(PX.ngayban) as Nam, month(PX.ngayban) as Thang, SP.maSP, SP.tenSP, SP.donvitinh, sum(CTPX.soluong) as TongSoLuong
from ctphieuxuat CTPX join phieuxuat PX on CTPX.SoPX = PX.SoPX
join sanpham SP on CTPX.MaSP = SP.MaSP
where month(PX.Ngayban) between 1 and 12
order by month(PX.Ngayban);

# 13.Thống kê doanh thu bán hàng trong trong 6 tháng đầu năm 2018, thông tin
# hiển thị gồm: tháng, doanh thu.
select month(PX.ngayban) as Thang, sum(CTPX.giaban * CTPX.soluong) as DoanhThu
from ctphieuxuat CTPX join phieuxuat PX on CTPX.SoPX = PX.SoPX
join nhanvien NV on PX.MaNV = NV.MaNV
join khachhang KH on PX.MaKH = KH.MaKH
where year(PX.Ngayban) = 2018 and month(PX.Ngayban) between 1 and 6
group by month(PX.ngayban);

# 14.Liệt kê các hóa đơn bán hàng của tháng 5 và tháng 6 năm 2018, gồm các
# thông tin: số phiếu, ngày bán, họ tên nhân viên bán hàng, họ tên khách hàng,
# tổng trị giá.
select PX.sopx, PX.ngayban, NV.hoten, KH.tenkh, sum(CTPX.soluong * CTPX.giaban) as TongTriGia
from phieuxuat PX join khachhang KH on PX.MaKH = KH.MaKH
join nhanvien NV on PX.MaNV = NV.MaNV
join ctphieuxuat CTPX on PX.SoPX = CTPX.SoPX
where year(PX.Ngayban) = 2018 and month(PX.Ngayban) between 5 and 6
group by month(PX.Ngayban);

# 15.Cuối ngày, nhân viên tổng kết các hóa đơn bán hàng trong ngày, thông tin
# gồm: số phiếu xuất, mã khách hàng, tên khách hàng, họ tên nhân viên bán
# hàng, ngày bán, trị giá.
select PX.sopx, KH.makh, KH.tenkh, NV.hoten, PX.ngayban, sum(CTPX.soluong * CTPX.giaban) as TriGia
from phieuxuat PX join ctphieuxuat CTPX on PX.SoPX = CTPX.SoPX
join khachhang KH on PX.MaKH = KH.MaKH
join nhanvien NV on PX.MaNV = NV.MaNV
where day(PX.Ngayban) = current_date();

# 16.Thống kê doanh số bán hàng theo từng nhân viên, gồm thông tin: mã nhân
# viên, họ tên nhân viên, mã sản phẩm, tên sản phẩm, đơn vị tính, tổng số lượng.
select PX.manv, NV.hoten, SP.masp, SP.tensp, SP.donvitinh, sum(CTPX.soluong)
from nhanvien NV join phieuxuat PX on NV.MaNV = PX.MaNV
join ctphieuxuat CTPX on PX.SoPX = CTPX.SoPX
join sanpham SP on CTPX.MaSP = SP.MaSP
group by PX.manv, NV.hoten;

# 17.Liệt kê các hóa đơn bán hàng cho khách vãng lai (KH01) trong quý 2/2018,
# thông tin gồm số phiếu xuất, ngày bán, mã sản phẩm, tên sản phẩm, đơn vị
# tính, số lượng, đơn giá, thành tiền.
select PX.sopx, PX.ngayban, SP.masp, SP.tensp, CTPX.soluong, SP.donvitinh, sum(CTPX.soluong * CTPX.giaban) as ThanhTien
from phieuxuat PX join ctphieuxuat CTPX on PX.SoPX = CTPX.SoPX
join sanpham SP on CTPX.MaSP = SP.MaSP
join khachhang KH on PX.MaKH = KH.MaKH
where month(PX.Ngayban) between 4 and 6 and KH.MaKH = 'KH1'
group by PX.SoPX;

# 18.Liệt kê các sản phẩm chưa bán được trong 6 tháng đầu năm 2018, thông tin
# gồm: mã sản phẩm, tên sản phẩm, loại sản phẩm, đơn vị tính.
select SP.masp, SP.tensp, SP.maloaisp, SP.donvitinh
from SanPham as SP join ctphieuxuat CTPX on SP.MaSP = CTPX.MaSp
join phieuxuat PX on CTPX.SoPX = PX.SoPX
where MONTH(PX.NgayBan) between 1 and 6
and SP.Donvitinh = 0 or SP.Ghichu = 'chưa bán được';

# 19.Liệt kê danh sách nhà cung cấp không giao dịch mua bán với cửa hàng trong
# quý 2/2018, gồm thông tin: mã nhà cung cấp, tên nhà cung cấp, địa chỉ, số
# điện thoại.
select NCC.mancc, NCC.tenncc, NCC.diachi, NCC.dienthoai
from nhacungcap NCC left join phieunhap PN on NCC.MaNCC = PN.MaNCC
where not month(PN.Ngaynhap) between 4 and 6  or NCC.MaNCC not in (select PN.MaNCC from PN);

# 20.Cho biết khách hàng có tổng trị giá đơn hàng lớn nhất trong 6 tháng đầu năm 2018.
select KH.tenkh, max(CTPX.soluong * CTPX.giaban) as GiaTriDon
from khachhang KH join phieuxuat PX on KH.MaKH = PX.MaKH
join ctphieuxuat CTPX on PX.SoPX = CTPX.SoPX
where month(PX.Ngayban) between 1 and 6
order by GiaTriDon desc limit 1;

# 21.Cho biết mã khách hàng và số lượng đơn đặt hàng của mỗi khách hàng.
select PX.makh, count(PX.makh) from phieuxuat PX group by PX.makh;

# 22.Cho biết mã nhân viên, tên nhân viên, tên khách hàng kể cả những nhân viên
# không đại diện bán hàng.
select NV.manv, NV.hoten, KH.tenkh from nhanvien NV join khachhang KH;

# 23.Cho biết số lượng nhân viên nam, số lượng nhân viên nữ
select count(case NV.gioitinh when 1 then 1 end) as NVNAM,
       count(case NV.GioiTinh when 0 then 1 end ) as NVNU
from nhanvien NV;

# 24.Cho biết mã nhân viên, tên nhân viên, số năm làm việc của những nhân viên
# có thâm niên cao nhất.
select NV.manv, NV.hoten, year(current_date) - year(NV.ngayvaolam) as ThamNien
from nhanvien NV
order by ThamNien;

# 25.Hãy cho biết họ tên của những nhân viên đã đến tuổi về hưu (nam:60 tuổi,
# nữ: 55 tuổi)
select NV.hoten from nhanvien NV
where (case when NV.gioitinh =1 then (year(current_date) - year(NV.NgaySinh) >= 60)
else (year(current_date) - year(NV.NgaySinh) >= 55 ) end);

# 26.Hãy cho biết họ tên của nhân viên và năm về hưu của họ.
select NV.hoten , case
    when NV.gioitinh = 1 then year(NV.ngayvaolam) + 60
    when NV.gioitinh = 0 then year(NV.ngayvaolam) + 55
    end as NamVeHuu from nhanvien NV;

# 27.Cho biết tiền thưởng tết dương lịch của từng nhân viên. Biết rằng - thâm
# niên <1 năm thưởng 200.000 - 1 năm <= thâm niên < 3 năm thưởng
# 400.000 - 3 năm <= thâm niên < 5 năm thưởng 600.000 - 5 năm <= thâm
# niên < 10 năm thưởng 800.000 - thâm niên >= 10 năm thưởng 1.000.000


# 28.Cho biết những sản phẩm thuộc ngành hàng Hóa mỹ phẩm
select SP.tensp from sanpham SP join loaisp LSP on SP.MaloaiSP = LSP.MaloaiSP
where LSP.TenloaiSP = 'Hóa mỹ phẩm';

# 29.Cho biết những sản phẩm thuộc loại Quần áo.
select SP.tensp from sanpham SP join loaisp LSP on SP.MaloaiSP = LSP.MaloaiSP
where LSP.TenloaiSP = 'Quần áo';

# 30.Cho biết số lượng sản phẩm loại Quần áo.
select count(*)
from SanPham SP join loaisp LSP on SP.MaloaiSP = LSP.MaLoaiSP
where LSP.TenloaiSP = 'Quần áo';

# 31.Cho biết số lượng loại sản phẩm ngành hàng Hóa mỹ phẩm.
select count(*)
from SanPham SP join loaisp LSP on SP.MaloaiSP = LSP.MaLoaiSP
where LSP.TenloaiSP = 'Hóa mỹ phẩm';

# 32.Cho biết số lượng sản phẩm theo từng loại sản phẩm.
select SP.tensp, count(SP.maloaisp)
from sanpham SP join loaisp LSP on SP.MaloaiSP = LSP.MaloaiSP
group by SP.tensp;