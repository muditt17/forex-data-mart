{{ config(materialized='table') }}

select
  customer_hk as customer_sk,
  customer_id,
  first_name,
  last_name,
  nationality,
  risk_rating,
  kyc_status
from {{ ref('sat_customer_details') }}
where is_current = true
