with cte as (select * from {{source('raw','store')}})

select s_store_sk, s_store_id, s_rec_start_date, s_rec_end_date, s_closed_date_sk, s_store_name 
from   cte