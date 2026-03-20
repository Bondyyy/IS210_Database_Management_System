--a
--a.1:  In ra danh sách các khách hàng (MAKH, HOTEN) đã mua sản phẩm có mã sản
--phẩm là “BB01” trong năm 2024.
-- Option 1
select kh.MAKH, kh.HOTEN
from KHACHHANG kh
where kh.MAKH in (
    select hd.MAKH
    from HOADON hd
    join CTHD on CTHD.SOHD = hd.SOHD
    where CTHD.MASP = 'BB01'
        and extract(year from hd.NGHD) = 2024
);
-- Option 2
select distinct kh.MAKH, kh.HOTEN
from KHACHHANG kh
join HOADON hd on hd.MAKH = kh.MAKH
join CTHD on CTHD.SOHD = hd.SOHD
where CTHD.MASP = 'BB01'
and extract(year from hd.NGHD) = 2024;

-- Option 3
select kh.MAKH, kh.HOTEN
from KHACHHANG kh
where exists(
    select 1
    from HOADON hd
    join CTHD on CTHD.SOHD= hd.SOHD
    where CTHD.MASP = 'BB01'
        and extract(year from hd.NGHD) = 2024
        and kh.MAKH = hd.MAKH
);

--a.2:  In ra danh sách các nhân viên (MANV, HOTEN) và tổng số hóa đơn từng nhân
--viên đã lập trong năm 2024.
select nv.MANV, nv.HOTEN, count(hd.SOHD) as Tổng_số_hóa_đơn_đã_lập
from NHANVIEN nv
join HOADON hd on hd.MANV = nv.MANV
where extract(year from hd.NGHD) = 2024
group by nv.MANV, nv.HOTEN;

-- a.3: In ra danh sách các sản phẩm (MASP, TENSP) có tổng số lượng bán ra nhiều
-- nhất trong năm 2024.
-- Option 1
select sp.MASP, sp.TENSP
from SANPHAM sp
join CTHD on CTHD.MASP = sp.MASP
join HOADON hd on hd.SOHD = CTHD.SOHD
where extract(year from hd.NGHD) = 2024
group by sp.MASP, sp.TENSP
order by sum(CTHD.SL) desc
FETCH FIRST 1 row with ties;

-- Option 2
select sp.MASP, sp.TENSP
from SANPHAM sp
join CTHD on CTHD.MASP = sp.MASP
join HOADON hd on hd.SOHD = CTHD.SOHD
where extract(year from hd.NGHD) = 2024
group by sp.MASP, sp.TENSP
having sum(CTHD.SL) = (
    select max(dem)
    from (
        select sum (CTHD_2.SL) as dem
        from CTHD CTHD_2
        join HOADON hd_2 on hd_2.SOHD = CTHD_2.SOHD
        where extract(year from hd_2.NGHD) = 2024
        group by CTHD_2.MASP
    )
);

--b: Viết trigger hiện thực yêu cầu sau: “Doanh số của một khách hàng là tổng trị giá các hóa
--đơn mà khách hàng thành viên đó đã mua”. (1.0 điểm)
create or replace trigger trg_tong_hoa_don
after insert or update or delete on HOADON
for each row
begin
    if inserting then
        update KHACHHANG kh
        set kh.DOANHSO = kh.DOANHSO + :NEW.TRIGIA
        where kh.MAKH = :NEW.MAKH;
    elsif deleting then
        update KHACHHANG kh
        set kh.DOANHSO = kh.DOANHSO - :OLD.TRIGIA
        where kh.MAKH = :OLD.MAKH;
    elsif updating then
        update  KHACHHANG kh
        set kh.DOANHSO = kh.DOANHSO - :OLD.TRIGIA
        where kh.MAKH = :OLD.MAKH;

        update  KHACHHANG kh
        set kh.DOANHSO = kh.DOANHSO + :NEW.TRIGIA
        where kh.MAKH = :NEW.MAKH;
    end if;
end;
/

-- c:   Xây dựng thủ tục cho phép nhập vào mã khách hàng và in ra danh sách các hóa đơn của
-- khách hàng này và số sản phẩm mua trong hóa đơn đó.

create or replace procedure sp_InDanhSachHoaDonKH(p_makh in KHACHHANG.MAKH%type)
IS
    v_hoten KHACHHANG.HOTEN%type;
    v_loop BOOLEAN := FALSE;
BEGIN
    select upper(kh.HOTEN) into v_hoten
    from KHACHHANG kh
    where kh.MAKH = p_makh;

    DBMS_OUTPUT.PUT_LINE('** Khach hang: ' || v_hoten || ' (MAKH: ' || p_makh ||') **');

    for r in (
        select hd.SOHD as hoadon, nvl(sum(cthd.SL),0) as soluong
        from HOADON hd
        left outer join  CTHD on cthd.SOHD = hd.SOHD
        where  hd.MAKH = p_makh
        group by hd.SOHD
        order by hoadon
    ) loop
        v_loop := TRUE;
        DBMS_OUTPUT.PUT_LINE('------ SOHD: ' || r.hoadon ||' co so luong san pham la: '||r.soluong);
        if NOT v_loop  then
            DBMS_OUTPUT.PUT_LINE('------ Khach hang nay chua co hoa don nao.');
        end if;
    end loop;
END;
commit;
call sp_InDanhSachHoaDonKH('KH02');

-- d: Viết hàm SumQuantity nhận vào tháng, năm, mã sản phẩm và trả về tổng số lượng bán
--hàng của sản phẩm trong tháng năm đó. Trả về NULL nếu không tồn tại sản phẩm tương
--ứng.
create or replace function  SumQuantity (
    p_thang NUMBER,
    p_nam NUMBER,
    p_masp SANPHAM.MASP%TYPE
) return number
is
    v_soluong NUMBER;
    v_bool SANPHAM.MASP%type := '-1';
begin

    select sp.MASP into v_bool
    from SANPHAM sp
    where p_masp = sp.MASP;

    if v_bool = '-1' then
        return  NULL;
    end if;

    select sum(CTHD.SL) into v_soluong
    from CTHD
    join HOADON hd on hd.SOHD = CTHD.SOHD
    where CTHD.MASP = p_masp
        and extract(month from hd.NGHD) = p_thang
        and extract(year from hd.NGHD) = p_nam;

    return v_soluong;
end;


SELECT SumQuantity(12, 2024, 'BC04') FROM DUAL;



