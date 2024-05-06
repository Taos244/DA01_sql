select * from SALES_DATASET_RFM_PRJ

ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER priceeach type numeric; -- ko dc
--1/
ALTER TABLE SALES_DATASET_RFM_PRJ
ALTER COLUMN priceeach type numeric USING (trim(priceeach)::numeric),
ALTER COLUMN ordernumber type integer USING (trim(ordernumber)::integer),
ALTER COLUMN quantityordered type numeric USING (trim(quantityordered)::numeric),
ALTER COLUMN orderlinenumber type numeric USING (trim(orderlinenumber)::numeric),
ALTER COLUMN sales type numeric USING (trim(sales)::numeric),
ALTER COLUMN orderdate type date USING (trim(orderdate)::date),
ALTER COLUMN status type VARCHAR USING (trim(status)::VARCHAR),
ALTER COLUMN productline type VARCHAR USING (trim(productline)::VARCHAR),
ALTER COLUMN msrp type numeric USING (trim(msrp)::numeric),
ALTER COLUMN productcode type VARCHAR USING (trim(productcode)::VARCHAR),
ALTER COLUMN customername type VARCHAR USING (trim(customername)::VARCHAR),
ALTER COLUMN phone type VARCHAR USING (trim(phone)::VARCHAR),
ALTER COLUMN addressline1 type VARCHAR USING (trim(addressline1)::VARCHAR),
ALTER COLUMN addressline2 type VARCHAR USING (trim(addressline2)::VARCHAR),
ALTER COLUMN city type VARCHAR USING (trim(city)::VARCHAR),
ALTER COLUMN postalcode type VARCHAR USING (trim(postalcode)::VARCHAR),
ALTER COLUMN addressline2 type VARCHAR USING (trim(addressline2)::VARCHAR),
ALTER COLUMN country type VARCHAR USING (trim(country)::VARCHAR),
ALTER COLUMN territory type VARCHAR USING (trim(territory)::VARCHAR),
ALTER COLUMN contactfullname type text USING (trim(contactfullname)::text),
ALTER COLUMN dealsize type VARCHAR USING (trim(dealsize)::VARCHAR)

--2/
Select *
from public.sales_dataset_rfm_prj
where ORDERNUMBER is null
or QUANTITYORDERED is null
or PRICEEACH is null
or ORDERLINENUMBER is null
or SALES is null
or ORDERDATE is null


--3/ Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME . 
--Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. 
--Gợi ý: (ADD column sau đó UPDATE)

ALTER TABLE sales_dataset_rfm_prj
ADD column contactlastname text,
ADD column contactfirstname text

UPDATE sales_dataset_rfm_prj
SET contactlastname=left(contactfullname,position('-' in contactfullname)-1),
contactfirstname=substring(contactfullname from position('-' in contactfullname)+1 for length(contactfullname));

UPDATE sales_dataset_rfm_prj
SET contactfirstname=UPPER(left(contactfirstname,1)) || right(contactfirstname,length(contactfirstname)-1),
contactlastname=UPPER(left(contactlastname,1)) || right(contactlastname,length(contactlastname)-1)

--4/Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE
ALTER TABLE public.sales_dataset_rfm_prj
ADD column qtr_id numeric,
ADD column month_id numeric,
ADD Column year_id numeric

UPDATE sales_dataset_rfm_prj
SET qtr_id=extract(quarter from orderdate),
month_id=extract(month from orderdate),
year_id=extract(year from orderdate)

--5/Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó
--(2 cách) ( Không chạy câu lệnh trước khi bài được review)
with outlier as
(
with cte as(Select Q1-1.5*IQR as min, Q3+1.5*IQR as max
from(select 
percentile_cont(0.25) within group (order by quantityordered) as Q1,
percentile_cont(0.75) within group (order by quantityordered) as Q3,
percentile_cont(0.75) within group (order by quantityordered)
-percentile_cont(0.25) within group (order by quantityordered) as IQR
from sales_dataset_rfm_prj) as a)

Select quantityordered
from sales_dataset_rfm_prj
where quantityordered<(select min from cte)
or quantityordered>(select max from cte)
)
DELETE from sales_dataset_rfm_prj
where quantityordered in(Select * from outlier)

---C1 xử lý: UPDATE
UPDATE sales_dataset_rfm_prj
Set quantityordered=(select avg(quantityordered) from sales_dataset_rfm_prj)
---C2 xử lý: DELETE
DELETE from sales_dataset_rfm_prj
where quanntityordered in(Select * from outlier)

select *
from sales_dataset_rfm_prj

--6/ Lưu data clean vào bảng mới SALES_DATASET_RFM_PRJ_CLEAN
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS(
Select * from public.sales_dataset_rfm_prj
where ORDERNUMBER is not null
AND QUANTITYORDERED is not null
AND PRICEEACH is not null
AND ORDERLINENUMBER is not null
AND SALES is not null
AND ORDERDATE is not null)
