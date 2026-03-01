{{ config(materialized='table') }}

select
  to_number(to_char(cast(feedback_ts as date),'YYYYMMDD')) as date_sk,
  {{ hash_key(['customer_id']) }} as customer_sk,
  {{ hash_key(['branch_id']) }} as branch_sk,
  feedback_id,
  rating,
  comments,
  1 as feedback_count
from {{ ref('feedback_raw') }}
where feedback_id is not null
