{{ config(materialized='table') }}

select
  cast(to_char(consent_ts,'YYYYMMDD') as integer) as date_sk,
  customer_hk as customer_sk,
  {{ hash_key(['consent_type']) }} as consent_type_sk,
  consent_id,
  consent_flag,
  source_system,
  is_current
from {{ ref('sat_consent_details') }}