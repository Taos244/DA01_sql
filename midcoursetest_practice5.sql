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

--EXCERCISE
--ex1: 
