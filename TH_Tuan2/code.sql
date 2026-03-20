--Bài 2:
--1 : Tạo câu truy vấn thể hiện tên, mã khách hàng. Tên các cột là Tên khách
--hàng, Mã khách hàng. Sắp xếp kết quả theo thứ tự giảm dần của mã khách
--hàng.
select c.NAME as TenKhachHang, c.ID as MaKhachHang
from s_customer c
order by c.ID desc
