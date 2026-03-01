{{ config(materialized='table') }}

select
  to_number(to_char(cast(consent_ts as date),'YYYYMMDD')) as date_sk,
  customer_hk as customer_sk,
  {{ hash_key(['consent_type']) }} as consent_type_sk,
  consent_id,
  consent_flag,
  source_system,
  is_current
from {{ ref('sat_consent_details') }}
