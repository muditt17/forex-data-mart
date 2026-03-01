{{ config(materialized='table') }}

select
  bank_hk as bank_sk,
  business_key as bank_id
from {{ ref('hub_bank') }}
