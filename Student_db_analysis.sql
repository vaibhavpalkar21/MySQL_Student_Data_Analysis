drop schema if exists studentdb;

create schema studentdb;

use studentdb;

-- Lets create tables for our schema

drop table if exists resultdata;

create table resultdata(
 class int(4) not null,
 roll_number int(4) not null,
 subjects varchar(11) not null,
 marks int(2) not null
 );
 
insert into resultdata(class,roll_number,subjects,marks) VALUES
(8, 1, 'math', 98),
(8, 1,'english', 88),
(8, 1,'science', 96),
(8, 1,'computer', 94),
(8, 2,'math', 78),
(8, 2,'english', 89),
(8, 2,'science', 87),
(8, 2,'computer', 99),
(8, 3,'math', 40),
(8, 3,'english', 45),
(8, 3,'science', 50),
(8, 3,'computer', 55),
(9, 1,'math', 90),
(9, 1,'english', 85),
(9, 1,'science', 85),
(9, 1,'computer', 85),
(9, 2,'math', 95),
(9, 2,'english', 30),
(9, 2,'science', 40),
(9, 2,'computer', 80),
(9, 3,'math', 48),
(9, 3,'english', 58),
(9, 3,'science', 68),
(9, 3,'computer', 78),
(10, 1,'math', 85),
(10, 1,'english', 90),
(10, 1,'science', 65),
(10, 1,'computer', 45),
(10, 2,'math', 50),
(10, 2,'english', 95),
(10, 2,'science', 65),
(10, 2,'computer', 85),
(10, 3,'math', 51),
(10, 3,'english', 61),
(10, 3,'science', 71),
(10, 3,'computer', 81)
;


select * from resultdata;

-- Question 1 - Write an SQL query to find the highest scoring subject for every class (i.e. subject with the highest mean score for that class)
-- Output schema: class, subject

-- Ans -
select class, subjects, max(avg_marks)
from (select class, subjects, avg(marks) as avg_marks from resultdata group by subjects, class order by avg_marks desc) as s1
group by class;

-- Question 2 - Write a SQL query to find the second ranker of every class (i.e. student securing second-highest total marks in the four subjects)
-- Output schema: class, roll_no

select *
from (select row_number () over (partition by class order by class) as row_num, class, roll_number, sum(marks) as total_marks from resultdata
group by roll_number, class) as s1
where row_num = 2;


-- Question 3 - Write a SQL query to display the marks in ‘Math’ of ‘English’ topper for each class
-- Output schema: class, roll_no, math_marks
/*
SELECT class, roll_number, max(marks) as maxmarks_english FROM resultdata WHERE subjects='english' GROUP BY class;

select class, roll_number from resultdata;

select class, roll_number, max(marks) as maths_marks from resultdata where subjects='math' group by class;
*/

select em.class, r.roll_number, max(r2.marks) as maths_marks, em.maxmarks as english_marks
from resultdata r, resultdata r2, (select class, max(marks) as maxmarks from resultdata where subjects='english' GROUP BY class) as em
where em.class=r.class and em.maxmarks=r.marks and r.subjects='english' and r2.class=r.class and r2.subjects='math' and r2.roll_number=r.roll_number
group by em.class;