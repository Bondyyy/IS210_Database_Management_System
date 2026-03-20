--1: Hiện thực ràng buộc toàn vẹn: “Tổng tiền phạt (TONGTIENPHAT) của một đối tượng
--là tổng mức tiền phạt (MUCTIENPHAT) của các lỗi mà người đó đã vi phạm”.
create or replace trigger TONGTIENPHAT
after insert or delete or update on VIPHAM
for each row
declare
    v_mucphat LOI.MUCTIENPHAT%type;
    v_mucphatmoi LOI.MUCTIENPHAT%type;
begin
    if inserting then
        select l.MUCTIENPHAT into v_mucphat
        from LOI l
        where l.MALOI = :NEW.MALOI;

        update DOITUONG
        set TONGTIENPHAT = TONGTIENPHAT + v_mucphat
        where MADT = :NEW.MADT;

    elsif deleting then
        select l.MUCTIENPHAT into v_mucphat
        from LOI l
        where l.MALOI = :OLD.MALOI;

        update DOITUONG
        set TONGTIENPHAT = TONGTIENPHAT - v_mucphat
        where MADT = :OLD.MADT;

    elsif updating then
        select l.MUCTIENPHAT into v_mucphat
        from LOI l
        where l.MALOI = :OLD.MALOI;

        update DOITUONG
        set TONGTIENPHAT = TONGTIENPHAT - v_mucphat
        where MADT = :OLD.MADT;

        select l.MUCTIENPHAT into v_mucphatmoi
        from LOI l
        where l.MALOI = :NEW.MALOI;

        update DOITUONG
        set TONGTIENPHAT = TONGTIENPHAT + v_mucphatmoi
        where MADT = :NEW.MADT;
    end if;


end;

--2: Tạo thủ tục nội tại có hai tham số vào là tháng và năm dùng hiển thị danh sách các đối
--tượng vi phạm giao thông trong tháng, năm đó. Kiểm tra tính hợp lệ của tháng phải từ 1
--đến 12, nếu không có dữ liệu phải thông báo cho người dùng biết.
create or replace procedure inDanhSach (p_thang NUMBER, p_nam NUMBER)
is
    v_Check int := -1;
begin
    if p_thang NOT BETWEEN 1 AND 12 then
        DBMS_OUTPUT.PUT_LINE('Nhap thang tu 1 toi 12');
        return ;
    end if;

    select count(*) into v_Check
    from VIPHAM vp
    where extract(month from vp.THOIDIEMVP) = p_thang
        and extract(year from vp.THOIDIEMVP) = p_nam;

    if v_Check = 0 then
        DBMS_OUTPUT.PUT_LINE('Khong co nguoi nao vi pham');
        return ;
    end if;

    for r in (
        select dt.MADT, dt.HOTEN
        from DOITUONG dt
        join VIPHAM vp on vp.MADT = dt.MADT
        where extract(month from vp.THOIDIEMVP) = p_thang
            and extract(year from vp.THOIDIEMVP) = p_nam
    ) loop
        DBMS_OUTPUT.PUT_LINE('Doi tuong vi pham co ma ' || r.MADT || ' va ten la '|| r.HOTEN);
    end loop;
end;

call inDanhSach (3, 2026)

--3: Tạo thủ tục nội tại có một tham số vào là năm, hai tham số ra là tên đối tượng vi phạm
--giao thông và tổng số lỗi vi phạm giao thông của đối tượng đó. Thủ tục này dùng để cho
--biết tên đối tượng vi phạm giao thông có tổng số lỗi vi phạm là nhiều nhất trong một năm
--bất kỳ.
create or replace procedure  inToiPham(p_nam Number)
is
    v_ten DOITUONG.HOTEN%type;
    v_slVP number;
begin
    select dt.HOTEN, count(vp.MALOI) into v_ten, v_slVP
    from DOITUONG dt
    join VIPHAM vp on vp.MADT = dt.MADT
    where extract(year from vp.THOIDIEMVP) = p_nam
    group by dt.HOTEN
    order by  count(vp.MALOI) desc
    FETCH FIRST 1 row with ties;

    DBMS_OUTPUT.PUT_LINE('Nguoi vi pham nhieu loi nhat la '||v_ten || ' voi so loi la '|| v_slVP);
end;

call inToiPham(2026)