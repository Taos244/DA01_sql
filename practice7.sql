--ex1:
with year_spend
as( 
select product_id,
extract(year from transaction_date) as year,
sum(spend) as spend
from user_transactions
group by product_id, extract(year from transaction_date)
order by product_id)

Select year, product_id, spend as curr_year_spend,
LAG(spend,1) OVER(PARTITION BY product_id order by year) as prev_year_spend,
ROUND(((spend - LAG(spend,1) OVER(PARTITION BY product_id order by year)))
/LAG(spend,1) OVER(PARTITION BY product_id order by year)*100,2) as yoy_rate
from year_spend

--ex2:
with launch as( 
select card_name,issued_amount,issue_year,issue_month,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year,issue_month) as issue_amount
from monthly_cards_issued)

select card_name, issue_amount
from launch
group by card_name, issue_amount
order by issue_amount DESC

--ex3:
with third as(SELECT user_id, transaction_date,
LEAD(spend,2) OVER(PARTITION BY user_id ORDER BY transaction_date) as spend
FROM transactions)

select user_id,
spend, transaction_date
from third
where spend is not null

--ex4:
with first as( SELECT user_id,transaction_date, product_id,
FIRST_value(transaction_date) OVER(PARTITION BY user_id order by transaction_date desc) as first_transaction_date
FROM user_transactions)

select transaction_date, user_id,
count(product_id) as purchase_count
from first
where transaction_date=first_transaction_date
group by transaction_date, user_id
order by transaction_date

--ex5: --sao bài này t dùng lead thì sai kết quả mà lag lại đúng nhỉ
with day as( 
SELECT user_id,tweet_date,tweet_count,
lag(tweet_count) OVER(PARTITION BY user_id order by tweet_date) as nd_day,
lag(tweet_count,2) OVER(PARTITION BY user_id order by tweet_date) as rd_day
FROM tweets)


select  user_id, tweet_date,
  CASE 
  WHEN nd_day IS NULL AND rd_day IS NULL THEN ROUND(tweet_count, 2)
  WHEN nd_day IS NULL THEN ROUND((rd_day + tweet_count) / 2.0, 2)
  WHEN rd_day IS NULL THEN ROUND((nd_day + tweet_count) / 2.0, 2)
  ELSE ROUND((nd_day + rd_day + tweet_count) / 3.0, 2)
  END AS rolling_avg_3d
from day

--ex6:
with time as(SELECT transaction_id, merchant_id, credit_card_id, transaction_timestamp,amount,
lag(transaction_timestamp) over(partition by merchant_id,credit_card_id, amount order by transaction_timestamp) as prv_trans,
extract(minute from (transaction_timestamp - lag(transaction_timestamp) over(partition by merchant_id,credit_card_id, amount order by transaction_timestamp))) as time_btw

FROM transactions)

select count(time_btw)
from time
where time_btw < 10

--ex7:
with cte as(SELECT category, product,
sum(spend) as spend,
row_number() over(partition by category order by sum(spend) desc) as ranking
FROM product_spend
where extract(year from transaction_date)=2022
group by product,category)

select category,product,spend
from cte
where ranking in(1,2)

--ex8:
with cte as(SELECT a.artist_name,
count(*) as count
FROM artists as a 
join songs as b on a.artist_id=b.artist_id
join global_song_rank as c on b.song_id=c.song_id
where c.rank<=10
group by artist_name),

rank as(SELECT artist_name,
dense_rank() OVER(order by sum(count) desc) as artist_rank
from cte
group by artist_name)

select artist_name, artist_rank
from RANK
where artist_rank<=5
