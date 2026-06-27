{{ config(materialized='table') }}

select
  bank_hk as bank_sk,
  bank_id,
  bank_name,
  country,
  bank_type
from {{ ref('sat_bank_details') }}