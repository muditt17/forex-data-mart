{{ config(materialized='table') }}

with bounds as (
  select
    least(
      (select min(cast(transaction_ts as date)) from {{ ref('sat_transaction_financials') }}),
      (select min(cast(feedback_ts as date)) from {{ ref('sat_feedback_details') }}),
      (select min(cast(consent_ts as date)) from {{ ref('sat_consent_details') }})
    ) as min_d,
    greatest(
      (select max(cast(transaction_ts as date)) from {{ ref('sat_transaction_financials') }}),
      (select max(cast(feedback_ts as date)) from {{ ref('sat_feedback_details') }}),
      (select max(cast(consent_ts as date)) from {{ ref('sat_consent_details') }})
    ) as max_d
),
spine as (
  select
    generate_series(min_d, max_d, interval '1 day')::date as d
  from bounds
)

select
  cast(to_char(d,'YYYYMMDD') as integer) as date_sk,
  d as date,
  extract(day from d)::int as day,
  extract(month from d)::int as month,
  extract(quarter from d)::int as quarter,
  extract(year from d)::int as year,
  case when extract(isodow from d) in (6,7) then true else false end as is_weekend
from spine
order by d