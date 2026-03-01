{{ config(materialized='table') }}

with src as (
  select distinct consent_type
  from {{ ref('consent_raw') }}
  where consent_type is not null
)
select
  {{ hash_key(['consent_type']) }} as consent_type_sk,
  consent_type
from src
