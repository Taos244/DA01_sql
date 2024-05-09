--SL đơn hàng số lượng Kh mỗi tháng
select
format_date('%Y-%m',created_at) as month_year,
count(distinct order_id) as total_order,
count(distinct user_id) as total_user
from bigquery-public-data.thelook_ecommerce.order_items
where format_date('%Y-%m',created_at) between '2019-01' and '2022-04'
and status='Complete'
group by format_date('%Y-%m',created_at)
order by 1
--> Sl đơn hàng và người dùng tăng theo thời gian, từ 2020 tăng ít nhất 200% cùng kỳ năm trước
---Sl đơn hàng và người dùng mỗi tháng ngang nhau -> có người dùng mua >1 đơn/tháng

--gtri đơn hàng tb (AOV) và sl KH mỗi tháng (1/2019-4/2022)
select
format_date('%Y-%m',created_at) as month_year,
count(distinct user_id) as distinct_user,
sum(sale_price)/count(distinct order_id) as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where format_date('%Y-%m',created_at) between '2019-01' and '2022-04'
and status='Complete'
group by format_date('%Y-%m',created_at)
order by 1
--> AOV đạt cao nhất tại tháng 01 2019, sau đó có xu hướng giảm mạnh vào tháng tiếp theo
---Sau đó đạt mức ổn định tại ~70-90$/1 đơn, tháng 4 và 6/2019 có tăng lên >100$/đơn

--Nhóm KH theo độ tuổi
---Output: first_name, last_name, gender, age, tag (hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)
with youngest as(
Select first_name,last_name, gender, age,
dense_rank() over(partition by gender order by age) as stt,
case when (dense_rank() over(partition by gender order by age)) =1 then 'youngest' else null end as tag
from bigquery-public-data.thelook_ecommerce.users
),
oldest as(
Select first_name,last_name, gender, age,
dense_rank() over(partition by gender order by age desc) as stt,
case when (dense_rank() over(partition by gender order by age desc)) =1 then 'oldest' else null end as tag
from bigquery-public-data.thelook_ecommerce.users
)
,customer_age as(
Select first_name, last_name,gender,age,tag
from youngest
where stt=1
UNION ALL
Select first_name, last_name,gender,age,tag
from oldest
where stt=1)
---bnh Kh trẻ nhất, bnh KH già nhất, số tuổi tương ứng
Select gender,age,
count(tag) as count
from customer_age
group by 1,2
---> KH trẻ nhất 12 tuổi - 814 nữ + 765 nam, già nhất 70 tuổi 883 nữ + 851 nam

--TOP 5 sản phẩm mỗi tháng
---Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
---Output: month_year ( yyyy-mm), product_id, product_name, sales, cost, profit, rank_per_month
with my_infor as(
select
format_date('%Y-%m',b.created_at) as month_year,
b.product_id,
a.name as product_name,
Sum(b.sale_price) as sales,
a.cost,
count(*) as item_sale
from bigquery-public-data.thelook_ecommerce.products as a
join bigquery-public-data.thelook_ecommerce.order_items as b on a.id=b.product_id
where b.status='Complete'
group by 1,2,3,5
order by 1),

profit_per as(
Select id,
(retail_price-cost) as profit_per
from bigquery-public-data.thelook_ecommerce.products),

result_all as(
select a.month_year,a.product_id,a.product_name,a.sales,a.cost,
a.item_sale*b.profit_per as profit,
dense_rank() over(partition by month_year order by a.item_sale*b.profit_per desc) as rank_per_month
from my_infor as a
join profit_per as b on a.product_id=b.id
order by 1)

select * from result_all
where rank_per_month <=5

--Doanh thu tính đến thời điểm hiện tại trên mỗi danh mục
---Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)
---Output: dates (yyyy-mm-dd), product_categories, revenue

select
extract(date from a.created_at) as dates,
b.category as product_category,
SUM(a.sale_price) as revenue
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.products as b on a.product_id=b.id
where a.status='Complete'
and extract(date from a.created_at) between '2022-01-15' and '2022-04-16'
Group by 1,2
order by 1,2

