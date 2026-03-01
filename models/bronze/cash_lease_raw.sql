{{ config(materialized='view') }}

select *
from {{ source('raw','cash_lease_raw') }}
