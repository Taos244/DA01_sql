--ex1:
WITH post
AS(
select title, description, company_id,
count(company_id) as post_time
from job_listings
group by title, description, company_id)
Select count(company_id) as duplicate_companies
from post
where post_time=2

--ex2:
with elec 
as(
select category, product,
sum(spend) as total_spent
from product_spend
where extract(year from transaction_date)=2022 and category='electronics'
GROUP BY category,product
order by sum(spend) desc
limit 2),
app as(
select category, product,
sum(spend) as total_spent
from product_spend
where extract(year from transaction_date)=2022 and category='appliance'
GROUP BY category,product
order by sum(spend) desc
limit 2)

select category, product, total_spent
from elec
UNION ALL
select category, product, total_spent
from app
order by category

--ex3:
with policy_count
as(SELECT policy_holder_id,
count(case_id) as policy_holder_count
FROM callers
group by policy_holder_id
having count(case_id)>=3)
select count(policy_holder_id) from policy_count

--ex4:
select a.page_id
from pages as a
FULL JOIN page_likes as b on a.page_id=b.page_id
where b.liked_date is null
order by page_id

--ex5:
with previous as(
SELECT EXTRACT(month FROM EVENT_DATE) as month,user_id
FROM user_actions
group by EXTRACT(month FROM EVENT_DATE),user_id
having EXTRACT(month FROM EVENT_DATE)=6),

current as(SELECT EXTRACT(month FROM EVENT_DATE) as month,user_id
FROM user_actions
group by EXTRACT(month FROM EVENT_DATE),user_id
having EXTRACT(month FROM EVENT_DATE)=7)

Select 7 as monthh, count(*) as monthly_active_user
from previous as a inner join current as b on a.user_id=b.user_id

--ex6:
with appr as(select id, count(state) as approved_count , sum(amount) as approved_total_amount
from Transactions
where state='approved'
group by country, trans_date)

select substring(a.trans_date from 1 for 7) as month, a.country,
count(*) as trans_count,
b.approved_count,
Sum(a.amount) as trans_total_amount,
b.approved_total_amount
from Transactions as a
left join appr as b on a.id=b.id
group by substring(a.trans_date from 1 for 7), a.country

--ex7:
select product_id, min(year) as first_year, quantity, price
from sales
group by product_id

--ex8:
select
customer_id
from customer
group by customer_id
having count(distinct product_key)=(select count(product_key) from product)

--ex9:
select emp.employee_id
from employees as emp
left join employees as mng on emp.manager_id=mng.employee_id
where emp.salary<30000 and mng.employee_id is null 

--ex10: https://leetcode.com/problems/primary-department-for-each-employee/
with y
as(select employee_id, department_id,primary_flag 
from Employee
where primary_flag='Y'),

N as(select employee_id,department_id,primary_flag 
from employee
group by employee_id
having primary_flag='N' and count(department_id)=1)

Select employee_id, department_id
from y
UNION ALL
Select employee_id, department_id
from N

--ex11:
with u
as(
    select b.name as results
from movierating as a
join users as b on a.user_id=b.user_id
group by b.name
order by count(a.rating) desc,b.name
limit 1),

m
as(
    select b.title as results
from movierating as a
join movies as b on a.movie_id=b.movie_id
where created_at like '2020-02%'
group by b.title
order by avg(a.rating) desc,b.title
limit 1)

select results
from u
    UNION ALL
Select results from m

--ex12:
with total as(select requester_id as id
from RequestAccepted
UNION ALL
select accepter_id as id
from RequestAccepted)

select id,
count(id) as num
from total
group by id
order by count(id) desc
limit 1


