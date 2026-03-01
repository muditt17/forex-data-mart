{{ config(materialized='view') }}

with cons as (
  select
    date_sk,
    bank_sk,
    currency_sk,
    sum(total_sold_amount) as sold_amount,
    avg(consumption_rate) as avg_consumption_rate
  from {{ ref('fact_cash_consumption') }}
  group by 1,2,3
),
sett as (
  select
    date_sk,
    bank_sk,
    currency_sk,
    sum(settlement_amount) as settlement_amount,
    sum(interest_amount) as interest_amount,
    sum(outstanding_balance) as outstanding_balance
  from {{ ref('fact_bank_settlement') }}
  group by 1,2,3
)
select
  coalesce(cons.date_sk, sett.date_sk) as date_sk,
  coalesce(cons.bank_sk, sett.bank_sk) as bank_sk,
  coalesce(cons.currency_sk, sett.currency_sk) as currency_sk,
  cons.sold_amount,
  cons.avg_consumption_rate,
  sett.settlement_amount,
  sett.interest_amount,
  sett.outstanding_balance
from cons
full outer join sett
  on cons.date_sk = sett.date_sk
 and cons.bank_sk = sett.bank_sk
 and cons.currency_sk = sett.currency_sk
