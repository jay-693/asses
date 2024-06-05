
/* ----------    1 --------- */
create table employee(emp_id int,emp_name varchar(20),dep_id int);
create table department(dep_id int,dep_name varchar(20));
create table salaries(emp_id int,sal_amount int,sal_date date);
insert into employee values(1,'abc',100);
insert into employee values(2,'efg',101);
insert into employee values(3,'mno',102);
insert into employee values(4,'pqr',103);
insert into employee values(5,'xyz',104);
insert into department values(100,'dep1');
insert into department values(101,'dep2');
insert into department values(102,'dep3');
insert into department values(104,'dep4');
insert into department values(105,'dep5');
update department set dep_id=103 where dep_name='dep5';
insert into salaries values(3,20000,'2023-06-04');
insert into salaries values(3,30000,'2023-07-04');
insert into salaries values(2,40000,'2024-05-31');
insert into salaries values(2,50000,'2024-06-30');
insert into salaries values(4,60000,'2023-07-04');
insert into salaries values(4,70000,'2023-07-04');
insert into salaries values(5,80000,'2023-07-04');
select employee.emp_name,department.dep_name,latest_salary.sal_amount from employee inner join department on employee.dep_id=department.dep_id
CROSS APPLY (
    SELECT TOP 1 sal_amount
    FROM salaries
    WHERE employee.emp_id = salaries.emp_id
    ORDER BY sal_date DESC
) AS latest_salary;



/* ----------   2 --------- */
create table product_table(product_id int,product_name varchar(20),category_id int,price int);
create table categories_table(category_id int,category_name varchar(20));
create table order_table(order_id int,product_id int,quantity int,order_date date);
insert into product_table values(1,'aa',100,2000);
insert into product_table values(2,'bb',101,2500);
insert into product_table values(3,'cc',102,3000);
insert into product_table values(4,'dd',103,4000);
insert into product_table values(5,'ee',104,5000);
insert into categories_table values(100,'cat1');
insert into categories_table values(101,'cat2');
insert into categories_table values(102,'cat3');
insert into categories_table values(103,'cat4');
insert into categories_table values(104,'cat5');
insert into order_table values(200,1,3,'2024-05-01');
insert into order_table values(202,2,4,'2024-06-02');
insert into order_table values(204,3,2,'2024-05-21');
insert into order_table values(206,4,1,'2024-05-10');
select category_id,(order_table.quantity*product_table.price) as revenue from product_table inner join order_table on product_table.product_id=order_table.product_id where (datediff(month,order_table.order_date,getdate())=1);




/* ----------   3 --------- */
create table books(book_id int, book_title varchar(20), author_id int, publication_date date);
create table authors(author_id int, author_name varchar(20),author_country varchar(20));
create table borrowers(borrower_id int, book_id int, borrower_name varchar(20), borrow_date date, return_date date);
insert into books values(1,'a',100,'1985-06-04');
insert into books values(3,'d',104,'1975-11-22');
insert into books values(2,'c',105,'1986-04-19');
insert into books values(4,'b',103,'1970-10-25');
insert into authors values(100,'a1','india');
insert into authors values(104,'a2','serbia');
insert into authors values(105,'a3','USA');
insert into authors values(103,'a4','iran');
insert into borrowers values(200,1,'b1','2023-04-05','2023-04-25');
insert into borrowers values(201,3,'b2','2024-05-31','2024-06-04');
insert into borrowers values(202,2,'b3','2023-11-29','2023-12-24');
insert into borrowers values(203,4,'b2','2024-03-31','2024-06-04');
select book_title,author_name,borrower_name,borrow_date,return_date from books join authors on books.author_id=authors.author_id join borrowers on borrowers.book_id=books.book_id;



/* ----------    4 --------- */
create table students(student_id int, student_name varchar(20), student_major varchar(20));
create table courses(course_id int, course_name varchar(20),course_department varchar(20));
create table enrollments(enrollment_id int, student_id int, course_id int, enrollment_date date);
create table grades(grade_id int, enrollment_id int, grade_value decimal(10,2));
insert into students values(100,'s1','m1');
insert into students values(101,'s2','m2');
insert into students values(102,'s3','m3');
insert into students values(103,'s4','m4');

insert into courses values(200,'c1','cd1');
insert into courses values(204,'c5','cd1');
insert into courses values(207,'c7','cd1');
insert into courses values(201,'c2','cd2');
insert into courses values(206,'c6','cd2');
insert into courses values(202,'c3','cd3');
insert into courses values(203,'c4','cd4');

insert into enrollments values(1,100,200,'2023-07-20');
insert into enrollments values(5,100,200,'2023-07-20');
insert into enrollments values(6,100,200,'2023-07-20');
insert into enrollments values(2,101,201,'2022-06-17');
insert into enrollments values(3,102,202,'2023-02-28');
insert into enrollments values(4,103,203,'2023-06-23');

insert into grades values(11,1,3.5);
insert into grades values(12,2,4.5);
insert into grades values(13,5,5);
insert into grades values(14,6,6);
insert into grades values(15,4,8);

select course_department,avg(grades.grade_value) as Average from grades join enrollments on grades.enrollment_id=enrollments.enrollment_id join courses on enrollments.course_id=courses.course_id group by course_department;



/* ----------  5   --------- */
create table customers(c_id int,c_name varchar(20),c_country varchar(20));
create table [order](order_id int,c_id int,product_id int,order_date date,order_quantity int);
create table product(product_id int, product_name varchar(20),product_price int);
insert into customers values(1,'vv','india');
insert into customers values(2,'ii','india');
insert into customers values(6,'uu','USA');
insert into customers values(3,'ll','UK');
insert into customers values(7,'kk','USA');
insert into customers values(8,'pp','india');
insert into customers values(9,'jj','USA');
insert into [order] values(100,1,200,'2024-05-20',3);
insert into [order] values(101,2,201,'2024-04-20',2);
insert into [order] values(103,3,202,'2024-03-20',1);
insert into [order] values(104,6,204,'2024-06-20',4);
insert into [order] values(105,8,205,'2024-03-24',2);
insert into product values(200,'aa1',2000);
insert into product values(201,'aa2',3000);
insert into product values(202,'aa3',4000);
insert into product values(204,'aa4',6000);
insert into product values(205,'aa5',4000);
select c_country,sum(([order].order_quantity*product.product_price)) as revenue from [order] join product on [order].product_id=product.product_id inner join customers on customers.c_id=[order].c_id group by customers.c_country;







