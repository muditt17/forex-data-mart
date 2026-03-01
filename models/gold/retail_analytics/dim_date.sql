{{ config(materialized='table') }}

with bounds as (
  select
    min(cast(transaction_ts as date)) as min_d,
    max(cast(transaction_ts as date)) as max_d
  from {{ ref('transactions_raw') }}
),
spine as (
  select dateadd(day, seq4(), min_d) as d
  from bounds, table(generator(rowcount => datediff(day, min_d, max_d) + 1))
)
select
  to_number(to_char(d,'YYYYMMDD')) as date_sk,
  d as date,
  day(d) as day,
  month(d) as month,
  quarter(d) as quarter,
  year(d) as year,
  iff(dayofweek(d) in (1,7), true, false) as is_weekend
from spine
