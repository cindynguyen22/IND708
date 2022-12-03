with cte as(
select 
* 
from ind708.Transactions T
group by T.transaction_time, T.transaction_date
having count(T.transaction_time) > 1
),

ct as(
select 
T.transaction_date as transaction_date,
T.transaction_time as transaction_time,
concat(' ', GROUP_CONCAT(T.product_id SEPARATOR ' '), ' ') as pairing
from ind708.Transactions T
inner join cte on T.transaction_time = cte.transaction_time and T.transaction_date = cte.transaction_date
group by T.transaction_time, T.transaction_date
order by T.transaction_time, T.transaction_date
)

select 
T.product_id,
ct.pairing,
count(T.product_id) as num_of_pairs
from ind708.Transactions T
inner join ct on T.transaction_time = ct.transaction_time and T.transaction_date = ct.transaction_date
/*where ct.pairing like '% 59 %' and T.product_id != 59*/
group by T.product_id
order by num_of_pairs desc