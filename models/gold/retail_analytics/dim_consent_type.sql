{{ config(materialized='table') }}

with src as (
  select distinct consent_type
  from {{ ref('sat_consent_details') }}
  where consent_type is not null
    and is_current = true
)
select
  {{ hash_key(['consent_type']) }} as consent_type_sk,
  consent_type
from src