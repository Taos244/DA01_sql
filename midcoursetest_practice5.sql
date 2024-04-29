--MID COURSE TEST
Q1:
Select distinct replacement_cost from film
order by replacement_cost
Q2:
select
count(*) as count,
case
when replacement_cost between 9.99 and 19.99 then 'low'
when replacement_cost between 20.00 and 24.99 then 'medium'
when replacement_cost between 25.00 and 29.99 then 'high'
end as cost_type
from film
group by cost_type

Q3:
Select t1.title, t1.length, t3.name
from film as t1
inner join film_category as t2 on t1.film_id=t2.film_id
inner join category as t3 on t2.category_id=t3.category_id
where t3.name in('Drama','Sports')
order by t1.length desc

Q4:
Select t1.title, t1.length, t3.name
from film as t1
inner join film_category as t2 on t1.film_id=t2.film_id
inner join category as t3 on t2.category_id=t3.category_id
where t3.name in('Drama','Sports')
order by t1.length desc

Q5:
select t1.first_name, t1.last_name, count(*) as movies
from actor as t1
Inner join film_actor as t2 on t1.actor_id=t2.actor_id
group by t1.first_name, t1.last_name
order by  count(*) desc

Q6:
select count(*) as count
from address as t1
left join customer as t2 on t1.address_id=t2.address_id
where t2.address_id is null

Q7:
select t4.city, sum(t1.amount)
from payment as t1
Inner join customer as t2 on t1.customer_id=t2.customer_id
Inner join address as t3 on t2.address_id=t3.address_id
Inner join city as t4 on t3.city_id=t4.city_id
group by t4.city
order by sum(t1.amount) desc

Q8:
select
t2.city || ' ,' || t1.country as city_country,
sum(amount) as doanh_thu
from country as t1
inner join city as t2 on t1.country_id=t2.country_id
Inner join address as t3 on t2.city_id=t3.city_id
Inner join customer as t4 on t3.address_id=t4.address_id
Inner join payment as t5 on t4.customer_id=t5.customer_id
Group by t2.city || ' ,' || t1.country
order by sum(amount) desc

--EXERCISE
--ex1:
select t2.continent, floor(avg(t1.population))
from city as t1
inner join country as t2 on t1.countrycode=t2.code
group by t2.continent

--ex2:
SELECT
round(sum(CASE
when t2.signup_action='Confirmed' then 1 else 0
end)::decimal/count(signup_action),2) as confirm_rate
from emails as t1
inner join texts as t2 on t1.email_id=t2.email_id

--ex3:
SELECT
t2.age_bucket,
round(sum(CASE
when activity_type='open' then time_spent
else 0
end)*100.0/sum(time_spent),2) as open_perc,
round(sum(CASE
when activity_type='send' then time_spent
else 0
end)*100.0/sum(time_spent),2) as send_perc
from activities as t1
inner join age_breakdown as t2 on t1.user_id=t2.user_id
where activity_type!='chat'
group by t2.age_bucket

--ex4:
SELECT t1.customer_id
FROM customer_contracts as t1
inner join products as t2 on t1.product_id=t2.product_id
group by t1.customer_id
having count(DISTINCT product_category)>=3

--ex5:
select mng.employee_id, mng.name,
count(emp.employee_id) as reports_count, --TAI SAO count employee id mà kp count reports to
round(avg(emp.age)) as average_age
from employees as emp
join employees as mng on emp.reports_to=mng.employee_id
group by employee_id

--ex6:
select t1.product_name,
sum(t2.unit) as unit
from products as t1
inner join orders as t2 on t1.product_id=t2.product_id
where t2.order_date like '2020-02%'
group by t1.product_name
having sum(t2.unit)>=100

--ex7:
SELECT t1.page_id
FROM pages as t1
full join page_likes as t2 on t1.page_id=t2.page_id
where t2.liked_date is null
order by page_id 
