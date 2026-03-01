{{ config(materialized='view') }}

select *
from {{ source('raw','consent_raw') }}
