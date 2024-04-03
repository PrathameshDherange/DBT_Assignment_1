{{ config(materialized = 'ephemeral') }}

with cte as ( select * from {{ source('raw','item') }})
select I_ITEM_SK from cte