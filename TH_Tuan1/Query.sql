/* Nhóm sinh viên thực hiện:
Huỳnh Đức Dũng 24520336 Trưởng nhóm
Lai Mộc Huy 24520663
Nguyễn Thành Đức 24520322
Sơn Nguyễn Kỳ Duyên 24520409

Nhiệm vụ phân công từng thành viên làm bài tập thực hành tuần 1
Huỳnh Đức Dũng: Bài 2 và Bài 3 câu 18, 19, 20, 21
Lai Mộc Huy: Làm Bài 2 và Bài 3 câu 22, 23, 24, 25
Nguyễn Thành Đức: Bài 2 và Bài 3 câu 26, 27, 28, 29
Sơn Nguyễn Kỳ Duyên: Bài 2 và Bài 3 câu 30, 31, 32
*/



-- Bài 2

/* Câu 1: Tsạo câu truy vấn thể hiện tên, mã khách hàng. Tên các cột là Tên khách
hàng, Mã khách hàng. Sắp xếp kết quả theo thứ tự giảm dần của mã khách
hàng. */

SELECT name AS "Tên khách hàng", id AS "Mã khách hàng"
FROM S_CUSTOMER
ORDER BY id DESC;

/* Câu 2: Hiển thị tên truy cập của nhân viên 23. */
SELECT userid
FROM S_EMP
WHERE id = 23;

/* Câu 3: Hiển thị họ, tên và mã phòng của nhân viên trong phòng 10, 50 và sắp theo thứ tự của tên. Nối 2 cột họ tên và đặt tên cột mới là Employees. */
SELECT last_name || ' ' || first_name AS "Employees", dept_id AS "Mã phòng"
FROM S_EMP
WHERE dept_id IN (10, 50)
ORDER BY first_name;

/* Câu 4: Hiển thị tất cả những nhân viên có tên chứa chữ “S”.  */
SELECT first_name AS "Tên nhân viên"
FROM S_EMP
WHERE first_name LIKE '%S%';

/* Câu 5: Hiển thị tên truy nhập và ngày bắt đầu làm việc của nhân viên trong khoảng thời gian từ 14/5/1990 đến 26/5/1991. */
SELECT userid AS "Tên truy cập", start_date AS "Ngày bắt đầu làm việc"
FROM S_EMP
WHERE start_date BETWEEN TO_DATE('14/5/1990', 'DD/MM/YYYY') AND TO_DATE('26/5/1991', 'DD/MM/YYYY');

/* Câu 6: Viết câu truy vấn hiển thị tên và mức lương của tất cả các nhân viên nhận lương từ 1000 đến 2000/tháng. */
SELECT first_name AS "Tên nhân viên", salary AS "Mức lương"
FROM S_EMP
WHERE salary BETWEEN 1000 AND 2000;

/* Câu 7:  Lập danh sách tên và mức lương của những nhân viên ở phòng 31, 42, 50 
nhận mức lương trên 1350. Đặt tên cho cột tên là Emloyee Name và đặt tên 
cho cột lương là Monthly Salary. */
SELECT first_name AS "Employee Name", salary AS "Monthly Salary"
FROM S_EMP
WHERE dept_id IN (31, 42, 50) AND salary > 1350;

/* Câu 8: Hiển thị tên và ngày bắt đầu làm việc của mỗi nhân viên được thuê trong 
năm 1991. */
SELECT first_name AS "Tên nhân viên", start_date AS "Ngày bắt đầu làm việc"     
FROM S_EMP
WHERE EXTRACT(YEAR FROM start_date) = 1991;

/* Câu 9: Hiển thị mã nhân viên, tên và mức lương được tăng thêm 15%. */
SELECT id AS "Mã nhân viên", first_name AS "Tên nhân viên", salary * 1.15 AS "Mức lương sau khi tăng"
FROM S_EMP;

/* Câu 10:  Hiển thị tên của mỗi nhân viên, ngày tuyển dụng và ngày xem xét tăng 
lương. Ngày xét tăng lương theo qui định là vào ngày thứ hai sau 6 tháng làm 
việc. Định dạng ngày xem xét theo kiểu “Eighth of May 1992”. */
SELECT first_name AS "Tên nhân viên",
        start_date AS "Ngày tuyển dụng",
        TO_CHAR(NEXT_DAY(ADD_MONTHS(start_date, 6), 'MONDAY'), 'fmDdspth "of" Month YYYY') AS "Ngày xem xét tăng lương",
        NEXT_DAY(ADD_MONTHS(start_date, 6), 'MONDAY') AS "Ngày xem xét tăng lương (định dạng chuẩn)"
FROM S_EMP;

/* Câu 11: Hiển thị tên sản phẩm của tất cả các sản phẩm có chữ “ski”.  */
SELECT name AS "Tên sản phẩm"
FROM S_PRODUCT
WHERE name LIKE '%ski%';

/*  Câu 12: Với mỗi nhân viên, hãy tính số tháng thâm niên của nhân viên. Sắp xếp 
kết quả tăng dần theo tháng thâm niên và số tháng được làm tròn. */
SELECT first_name AS "Tên nhân viên",
        TRUNC(MONTHS_BETWEEN(SYSDATE, start_date)) AS "Số tháng thâm niên"
FROM S_EMP
ORDER BY "Số tháng thâm niên" ASC;

/* Câu 13: Cho biết có bao nhiêu người quản lý. */
SELECT COUNT(DISTINCT manager_id) AS "Số người quản lý"
FROM S_EMP
WHERE manager_id IS NOT NULL;

/* Câu 14:  Hiển thị mức cao nhất và mức thấp nhất của đơn hàng trong bảng S_ORD. 
Đặt tên các cột tương ứng là Hightest và Lowest. */
SELECT MAX(total) AS "Hightest", MIN(total) AS "Lowest"
FROM S_ORD;

/* Câu 15: Hiển thị tên sản phẩm, mã sản phẩm và số lượng từng sản phẩm trong 
đơn đặt hàng có mã số 101. Cột số lượng được đặt tên là ORDERED. */
SELECT p.name, 
       p.id AS product_id, 
       i.quantity AS ORDERED 
FROM s_product p 
JOIN s_item i ON p.id = i.product_id 
WHERE i.ord_id = 101;


/* Câu 16: Hiển thị mã khách hàng và mã đơn đặt hàng của tất cả khách hàng, kể cả 
những khách hàng chưa đặt hàng. Sắp xếp danh sách theo mã khách hàng. */
SELECT c.id AS "Mã khách hàng", o.id AS "Mã đơn đặt hàng"
FROM s_customer c
LEFT JOIN s_ord o ON c.id = o.customer_id
ORDER BY c.id;

/* Câu 17: Hiển thị mã khách hàng, mã sản phẩm và số lượng đặt hàng của các đơn 
đặt hàng có trị giá trên 100.000. */
select o.customer_id AS "Mã khách hàng", i.product_id AS "Mã sản phẩm", i.quantity AS "Số lượng đặt hàng"
from s_ord o
join s_item i on o.id = i.ord_id
where o.total > 100000; 

/* Bài 3 */
/* Câu 18: Hiển thị họ tên của tất cả các nhân viên không phải là người quản lý. */
SELECT last_name || ' ' || first_name AS "Họ Tên"
FROM s_emp
WHERE id NOT IN (
    SELECT manager_id 
    FROM s_emp 
    WHERE manager_id IS NOT NULL
);

/* Câu 19:  Hiện thị theo thứ tự abc tất cả những sản phẩm có tên bắt đầu với từ Pro. */
SELECT name AS "Tên sản phẩm"
FROM s_product
WHERE name LIKE 'Pro%'
ORDER BY name;

/* Câu 20: Hiển thị tên sản phẩm và mô tả ngắn gọn (SHORT_DESC) của sản phẩm 
với những sản phẩm có mô tả ngắn gọn chứa từ “bicycle”. */
select name AS "Tên sản phẩm", short_desc AS "Mô tả ngắn gọn"
from s_product
where short_desc LIKE '%bicycle%';

/* Câu 21: Hiển thị tất cả những SHORT_DESC.  */
Select DISTINCT short_desc AS "Mô tả ngắn gọn"
from s_product;

/* Câu 22: Hiển thị tên nhân viên và chức vụ trong ngoặc đơn “( )” của tất cả các 
nhân viên. Ví dụ: Nguyễn Văn Tâm (Giám đốc). */
SELECT first_name || ' ' || last_name || ' (' || TITLE || ')' AS "Tên nhân viên và chức vụ"
from S_EMP;

/* câu 23: Với từng người quản lý, cho biết mã người quản lý và số nhân viên mà 
họ quản lý. */
SELECT manager_id, COUNT(id) AS "Số nhân viên"
FROM s_emp
WHERE manager_id IS NOT NULL
GROUP BY manager_id;

/* câu 24:  Hiển thị những người quản lý 20 nhân viên trở lên. */
SELECT manager_id, COUNT(id) AS "Số nhân viên"
FROM s_emp
WHERE manager_id IS NOT NULL 
GROUP BY manager_id
HAVING COUNT(id) >= 20;

/* Câu 25: Cho biết mã vùng, tên vùng và số phòng ban trực thuộc trong mỗi vùng. */
select r.id as "Mã vùng", r.name as "Tên vùng", COUNT(d.id) as "Số phòng ban"
from s_region r
left join S_DEPT d on r.id = d.region_id
group by r.id, r.name;


/* Câu 26: Hiển thị tên khách hàng và số lượng đơn đặt hàng của mỗi khách hàng.  */
select c.name AS "Tên khách hàng", COUNT(o.id) AS "Số lượng đơn đặt hàng"
from s_customer c
left join s_ord o on c.id = o.customer_id
group by c.id, c.name;

/* Câu 27:  Cho biết khách hàng có số đơn đặt hàng nhiều nhất. */
-- Cách 1: Sup-Query
SELECT c.name AS "Tên khách hàng", COUNT(o.id) AS "Số lượng đơn đặt hàng"
FROM s_customer c
JOIN s_ord o ON c.id = o.customer_id
GROUP BY c.id, c.name
HAVING COUNT(o.id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(o.id) AS order_count
        FROM s_customer c
        JOIN s_ord o ON c.id = o.customer_id
        GROUP BY c.id
    )
);
--Cách 2: Sử dụng fetch
SELECT c.name AS "Tên khách hàng", COUNT(o.id) AS "Số lượng đơn đặt hàng"
FROM s_customer c
JOIN s_ord o ON c.id = o.customer_id
GROUP BY c.id, c.name
ORDER BY COUNT(o.id) DESC
FETCH FIRST 1 ROW WITH TIES;

/* Câu 28: Cho biết khách hàng có tổng tiền mua hàng lớn nhất.  */
Select c.name AS "Tên khách hàng", SUM(o.total) AS "Tổng tiền mua hàng"
from s_customer c
join s_ord o on c.id = o.customer_id
group by c.id, c.name
order by SUM(o.total) DESC
fetch first 1 row with ties;

/* Câu 29: Hiển thị họ, tên và ngày tuyển dụng của tất cả các nhân viên cùng phòng 
với Lan.  */
SELECT first_name AS "Tên nhân viên", last_name AS "Họ nhân viên", start_date AS "Ngày tuyển dụng"
FROM s_emp
WHERE dept_id = (
    SELECT dept_id
    FROM s_emp
    WHERE first_name = 'Midori'
);

/* Câu 30: Hiển thị mã nhân viên, họ, tên và mã truy cập của tất cả các nhân viên có 
mức lương trên mức lương trung bình. */
SELECT id AS "Mã nhân viên", first_name AS "Tên nhân viên", last_name AS "Họ nhân viên", userid AS "Mã truy cập"
FROM s_emp
WHERE salary > (SELECT AVG(salary) FROM s_emp);

/* Câu 31: Hiển thị mã nhân viên, họ và tên của tất cả các nhân viên có mức lương 
trên mức trung bình và có tên chứa ký tự “L”. */
SELECT id AS "Mã nhân viên", first_name AS "Tên nhân viên", last_name
FROM s_emp
WHERE salary > (SELECT AVG(salary) FROM s_emp) AND first_name LIKE '%L%';

/* Câu 32: Hiển thị những khách hàng chưa bao giờ đặt hàng.*/
SELECT name AS "Tên khách hàng"
FROM s_customer
WHERE id NOT IN (SELECT customer_id FROM s_ord);
