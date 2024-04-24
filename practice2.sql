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
