--ex1
select
name
from students
where marks > 75
order by right(name,3), ID

--ex2
select user_id,
concat(upper(left(name,1)),
lower(right(name,(length(name)-1))))
from users
order by user_

--ex3
SELECT manufacturer,
'$' || ceiling(sum(total_sales)/1000000) || ' million' as sale_mil
FROM pharmacy_sales
group by manufacturer
order by manufacturer

--ex4
SELECT extract(month from submit_date), product_id,
ROUND(AVG(stars),2)
FROM reviews
group by extract(month from submit_date), product_id
order by extract(month from submit_date), product_id

--ex5
SELECT sender_id,
count(content)
FROM messages
where extract(year from sent_date) = 2022 and extract(month from sent_date) = 08
group by sender_id
order by count(content) desc
limit 2

--ex6
select tweet_id
from tweets
where length(content)>15

--ex7
SELECT sender_id,
count(content)
FROM messages
where extract(year from sent_date) = 2022 and extract(month from sent_date) = 08 ---where to_char(sent_date,'Month YYYY')='August2022'
group by sender_id
order by count(content) desc
limit 2

--ex8
select 
count(id)
from employees
where joining_date between '2022-01-01' and '2022-08-01'

--ex9
select
position('a' in first_name)
from worker
where first_name = 'Amitah'

--ex10
select
substring(title from position(winery in title)+(length(winery)+1) for 4) --substring(title from (length(winery)+1)for 4)
from winemag_p2
where country='Macedonia'

