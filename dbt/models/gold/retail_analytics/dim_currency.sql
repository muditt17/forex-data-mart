{{ config(materialized='table') }}

select
  currency_hk as currency_sk,
  currency_code
from {{ ref('hub_currency') }}
