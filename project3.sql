select * from public.sales_dataset_rfm_prj_clean;

--1/Doanh thu theo từng Productline, year, dealsize
select
productline,
year_id,
dealsize,
sum(sales) as revenue
from public.sales_dataset_rfm_prj_clean
Group by productline, year_id, dealsize
order by productline

--2/ Tháng bán tốt nhất mỗi năm
with cte as(select 
month_id, year_id,
Sum(sales) as revenue,
count(distinct ordernumber) as order_number,
dense_rank() OVER(partition by year_id order by Sum(sales) desc) as rank
from public.sales_dataset_rfm_prj_clean
group by month_id, year_id)

select month_id, revenue, order_number from cte
where rank=1

--3/Productline nào được bán nhiều ở tháng 11 (Classic cars)
with cte2 as(select
month_id,
productline,
sum(sales) as revenue,
count(distinct ordernumber) as order_number
from public.sales_dataset_rfm_prj_clean
where month_id=11
group by month_id, productline)

, rank as(select *,
dense_rank() over(order by order_number desc) as rank
from cte2)

Select month_id, revenue, order_number
from rank
where rank=1

--4/SP có doanh thu tốt nhất ở UK mỗi năm
with rank as(select
year_id,
productline,
sum(sales) as revenue,
dense_rank() Over(partition by year_id order by sum(sales) desc) as rank
from public.sales_dataset_rfm_prj_clean
where country='UK'
group by year_id,productline
order by year_id, rank)

select year_id, productline, revenue, rank
from rank
where rank=1

--5/5) Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
with rfm as (select customername,
current_date-max(orderdate) as R,
count(distinct ordernumber) as F,
sum(sales) as M
from public.sales_dataset_rfm_prj_clean
group by customername)

, rfm_score as(select customername,
ntile(5) over(order by R desc) as R_score,
ntile(5) over(order by F) as F_score,
ntile(5) over(order by M) as M_score
from rfm)

,rfm_final as(select customername,
cast(r_score as varchar) || cast(f_score as varchar) || cast(m_score as varchar) as RFM_SCORE
from rfm_score)
select a.customername, b.segment
from rfm_final as a
join segment_score as b on a.rfm_score=b.scores
where b.segment='Champions'
group by a.customername, b.segment



