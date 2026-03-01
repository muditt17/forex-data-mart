{{ config(materialized='table') }}

with src as (
  select distinct channel as channel_name
  from {{ ref('transactions_raw') }}
  where channel is not null
)
select
  {{ hash_key(['channel_name']) }} as channel_sk,
  channel_name
from src
