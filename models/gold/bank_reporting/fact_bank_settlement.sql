{{ config(materialized='table') }}

with lease as (
  select lease_id, bank_id, currency_code, lease_amount, interest_rate
  from {{ ref('cash_lease_raw') }}
),
sett as (
  select settlement_id, lease_id, settlement_date, amount_paid
  from {{ ref('bank_settlement_raw') }}
)
select
  to_number(to_char(sett.settlement_date,'YYYYMMDD')) as date_sk,
  {{ hash_key(['lease.bank_id']) }} as bank_sk,
  {{ hash_key(['sett.lease_id']) }} as lease_sk,
  {{ hash_key(['lease.currency_code']) }} as currency_sk,
  sett.settlement_id,
  sett.lease_id,
  lease.bank_id,
  lease.currency_code,
  lease.lease_amount,
  lease.interest_rate,
  (lease.lease_amount * lease.interest_rate / 100) as interest_amount,
  sett.amount_paid as settlement_amount,
  (lease.lease_amount + (lease.lease_amount * lease.interest_rate / 100) - sett.amount_paid) as outstanding_balance
from sett
join lease on sett.lease_id = lease.lease_id
