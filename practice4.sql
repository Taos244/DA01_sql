--ex1
SELECT
sum(CASE
when device_type='laptop' then 1
else 0
end) as laptop_views,
sum(CASE
when device_type='tablet' then 1
when device_type='phone' then 1
else 0
end) as mobile_views
FROM viewership

--ex2
select x,y,z,
case
when x+y>z and x+z>y and y+z>x then "Yes"
else 'No'
end as triangle
from triangle

--ex3
SELECT
round((sum(CASE
WHEN call_category='n/a' or call_category is null then 1
else 0
end)*100)/count(*)::numeric,1) as uncategorised_call_pct
FROM callers;

--ex4
select name
from customer
where referee_id is null or referee_id!=2

--ex5
select survived,
sum(case
when pclass=1 then 1
when pclass=1 and survived=1 then 1
else 0
end) as first_class,
sum(case
when pclass=2 then 1
when pclass=2 and survived=1 then 1
else 0
end) as second_class,
sum(case
when pclass=3 then 1
when pclass=3 and survived=1 then 1
else 0
end) as third_class
from titanic
group by survived
