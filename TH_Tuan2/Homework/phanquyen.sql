/* Bài 4 */
/* 1) Sinh viên tạo ra 20 tài khoản (user01 → user20) cho phép kết nối đến CSDL
Oracle. */

BEGIN
  FOR i IN 1..20 LOOP
    -- Tạo user
    EXECUTE IMMEDIATE 'CREATE USER user' || TO_CHAR(i, 'FM00') || ' IDENTIFIED BY 123456';
    -- Cấp quyền kết nối
    EXECUTE IMMEDIATE 'GRANT CONNECT TO user' || TO_CHAR(i, 'FM00');
  END LOOP;
END;
/

/* 2) Sinh viên lần lượt tạo các role sau:
▪ Role_QUANTRI: sao cho các tài khoản toàn quyền thao tác đối với
CSDL ở bài tập 3.
▪ Role_NGUOIDUNG: sao cho các tài khoản chỉ được phép truy vấn
dữ liệu đối với CSDL ở bài tập 3.*/

CREATE ROLE Role_QUANTRI_2;
CREATE ROLE Role_NGUOIDUNG_2;

GRANT ALL PRIVILEGES ON COURSE TO Role_QUANTRI_2;
GRANT ALL PRIVILEGES ON STUDENT TO Role_QUANTRI_2;
GRANT ALL PRIVILEGES ON CLASS TO Role_QUANTRI_2;
GRANT ALL PRIVILEGES ON ENROLLMENT TO Role_QUANTRI_2;
GRANT ALL PRIVILEGES ON INSTRUCTOR TO Role_QUANTRI_2;
GRANT ALL PRIVILEGES ON GRADE TO Role_QUANTRI_2;

GRANT SELECT ON COURSE TO Role_NGUOIDUNG_2;
GRANT SELECT ON STUDENT TO Role_NGUOIDUNG_2;
GRANT SELECT ON CLASS TO Role_NGUOIDUNG_2;
GRANT SELECT ON ENROLLMENT TO Role_NGUOIDUNG_2;
GRANT SELECT ON INSTRUCTOR TO Role_NGUOIDUNG_2;
GRANT SELECT ON GRADE TO Role_NGUOIDUNG_2;

/* 3) Gán Role_QUANTRI cho các tài khoản (user01 → user10).  */
BEGIN
  -- Gán Role_QUANTRI cho user01 đến user10
  FOR i IN 1..10 LOOP
    EXECUTE IMMEDIATE 'GRANT Role_QUANTRI_2 TO user' || TO_CHAR(i, 'FM00');
  END LOOP;

/* 4) Gán Role_QUANTRI cho các tài khoản (user11 → user20).  */
  FOR i IN 11..20 LOOP
    EXECUTE IMMEDIATE 'GRANT Role_NGUOIDUNG_2 TO user' || TO_CHAR(i, 'FM00');
  END LOOP;
END;
/

/* 5) Thu hồi quyền quản trị đối với các tài khoản: user01, user03, user05. */
REVOKE Role_QUANTRI_2 FROM user01, user03, user05;