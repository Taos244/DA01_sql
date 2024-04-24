---ex1:
select distinct city
from station
where (ID%2) = 0

--ex2
select
count(*) - count(distinct city) as different
from station

--ex3
select
ceiling(avg(salary) - avg(replace(salary,'0',''))) as different
from employees

--ex4
SELECT
round((sum(order_occurrences*item_count)/sum(order_occurrences))::numeric,1) as mean --cau nay minh search gg thay bao them ::numeric nhung chua hieu cai nay
FROM items_per_order

--ex5
SELECT candidate_id,
count(skill)
FROM candidates
where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill)=3
order by candidate_id

--ex6
SELECT user_id,
date(max(post_date))-date(min(post_date)) as day_between
FROM posts
where post_date between '2021-01-01' and '2022-01-01'
group by user_id
having count (post_id)>=2

--ex7
SELECT card_name,
max(issued_amount) - min(issued_amount) as different
FROM monthly_cards_issued
group by card_name
order by different desc

--ex8
SELECT manufacturer,
abs(sum(total_sales-cogs)) as total_loss,
count(drug) as drug_count
FROM pharmacy_sales
where cogs-total_sales>0
group by manufacturer
order by total_loss desc

--ex9
