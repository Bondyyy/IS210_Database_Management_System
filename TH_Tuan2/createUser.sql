--Bai 1: Sinh viên tạo ra 20 tài khoản (sinhvien01 → sinhvien20) cho phép kết nối
--đến CSDL Oracle.
-- 1) Sinh viên tạo ra 20 tài khoản (sinhvien01 → sinhvien20) cho phép kết nối
--đến CSDL Oracle.
--2) Sinh viên lần lượt tạo các role sau:
--▪ Role_QUANTRI: gồm các quyền: connect, resource, oem_monitor, dba
--▪ Role_NGUOIDUNG: gồm các quyền: connect, resource, oem_monitor
--3) Gán Role_QUANTRI cho các tài khoản (sinhvien01 → sinhvien10)
--4)  Gán Role_NGUOIDUNG cho các tài khoản còn lại

BEGIN
   FOR i IN 1..20 LOOP
      EXECUTE IMMEDIATE 'CREATE USER sinhvien' || TO_CHAR(i, 'FM00') || ' IDENTIFIED BY 123456';
   END LOOP;
END;
/
CREATE ROLE Role_QUANTRI;
GRANT connect, resource, oem_monitor, dba TO Role_QUANTRI;
/
CREATE ROLE Role_NGUOIDUNG;
GRANT connect, resource, oem_monitor TO Role_NGUOIDUNG;
/
BEGIN
   FOR i IN 1..10 LOOP
      EXECUTE IMMEDIATE 'GRANT Role_QUANTRI TO sinhvien' || TO_CHAR(i, 'FM00');
   END LOOP;
END;
/
BEGIN
   FOR i IN 11..20 LOOP
      EXECUTE IMMEDIATE 'GRANT Role_NGUOIDUNG TO sinhvien' || TO_CHAR(i, 'FM00');
   END LOOP;
END;
/