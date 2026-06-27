{{ config(materialized='table') }}

select
  cast(to_char(s.feedback_ts,'YYYYMMDD') as integer) as date_sk,
  s.customer_hk as customer_sk,
  s.branch_hk as branch_sk,
  s.feedback_id,
  s.rating,
  s.comments,
  1 as feedback_count
from {{ ref('sat_feedback_details') }} s