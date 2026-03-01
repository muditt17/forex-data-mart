# 💱 FX Currency Exchange Data Platform

Enterprise-grade data platform for a Currency Exchange Company built
using:

-   **Bronze → Silver → Gold architecture**
-   **Data Vault 2.0 (Hubs / Links / Satellites)**
-   **SCD Type 2 via dbt Snapshots**
-   **Dimensional Modeling for Analytics**
-   **Bank Cash Leasing & Consumption Reporting**

------------------------------------------------------------------------

# 🏗️ Overall Architecture

            Source Systems / Third Parties
                        │
                        ▼
            ┌────────────────────┐
            │      Bronze        │
            │   Raw Ingestion    │
            └────────────────────┘
                        │
                        ▼
            ┌────────────────────┐
            │      Silver        │
            │   Data Vault 2.0   │
            │ Hubs / Links / SAT │
            └────────────────────┘
                        │
                        ▼
            ┌────────────────────────────────────────────┐
            │                    Gold                    │
            │  1. Retail / Marketing Analytics           │
            │  2. Treasury Analytics                     │
            │  3. Bank Reporting                         │
            └────────────────────────────────────────────┘

------------------------------------------------------------------------

# 🥉 Bronze Layer -- Raw Layer

## Purpose

Stores data exactly as received from source systems and third parties.

## Source Entities

-   transactions_raw
-   customers_raw
-   branches_raw
-   fx_rates_raw
-   consent_raw (3rd party consent)
-   feedback_raw (form data)
-   banks_raw
-   cash_lease_raw
-   vault_stock_raw
-   bank_settlement_raw

## Bronze ER Diagram

``` mermaid
erDiagram

    transactions_raw {
        string transaction_id
        string customer_id
        string branch_id
        string from_currency
        string to_currency
        decimal from_amount
        decimal exchange_rate
        decimal commission_fee
        timestamp transaction_ts
    }

    customers_raw {
        string customer_id
        string first_name
        string last_name
        string nationality
        string risk_rating
        string kyc_status
    }

    cash_lease_raw {
        string lease_id
        string bank_id
        string currency_code
        decimal lease_amount
        decimal interest_rate
        date lease_start
        date lease_end
    }

    bank_settlement_raw {
        string settlement_id
        string lease_id
        decimal amount_paid
        date settlement_date
    }

    vault_stock_raw {
        string branch_id
        string currency_code
        decimal opening_balance
        decimal closing_balance
        date stock_date
    }
```

------------------------------------------------------------------------

# 🥈 Silver Layer -- Data Vault 2.0

## Architecture Components

### 🔹 Hubs (Business Keys)

-   hub_customer
-   hub_transaction
-   hub_branch
-   hub_currency
-   hub_bank
-   hub_cash_lease
-   hub_settlement
-   hub_consent
-   hub_feedback

### 🔹 Links (Relationships)

-   link_txn_customer
-   link_txn_branch
-   link_txn_currency
-   link_lease_bank
-   link_lease_currency
-   link_settlement_lease
-   link_customer_consent
-   link_feedback_customer
-   link_feedback_branch

### 🔹 Satellites (SCD2 via Snapshots)

-   sat_customer_details
-   sat_branch_details
-   sat_cash_lease_details
-   sat_consent_details
-   sat_feedback_details
-   sat_transaction_financials

## Silver ER Diagram (Data Vault)

``` mermaid
erDiagram

    hub_customer ||--o{ link_txn_customer : relates
    hub_transaction ||--o{ link_txn_customer : relates

    hub_transaction ||--o{ link_txn_branch : relates
    hub_branch ||--o{ link_txn_branch : relates

    hub_cash_lease ||--o{ link_lease_bank : relates
    hub_bank ||--o{ link_lease_bank : relates

    hub_cash_lease ||--o{ link_lease_currency : relates
    hub_currency ||--o{ link_lease_currency : relates

    hub_customer ||--o{ link_customer_consent : relates
    hub_consent ||--o{ link_customer_consent : relates

    hub_feedback ||--o{ link_feedback_customer : relates
    hub_customer ||--o{ link_feedback_customer : relates

    hub_customer ||--o{ sat_customer_details : describes
    hub_branch ||--o{ sat_branch_details : describes
    hub_cash_lease ||--o{ sat_cash_lease_details : describes
```

------------------------------------------------------------------------

# 🥇 Gold Layer -- Retail / Marketing Analytics

## Business Use Cases

-   Revenue analytics
-   Channel performance
-   Customer segmentation
-   Feedback analysis
-   Consent compliance tracking

## Star Schema

### Dimensions

-   dim_date
-   dim_customer
-   dim_branch
-   dim_currency
-   dim_channel
-   dim_consent_type

### Facts

-   fact_fx_transactions
-   fact_feedback
-   fact_customer_consent

## ER Diagram (Retail)

``` mermaid
erDiagram
    dim_customer ||--o{ fact_fx_transactions : joins
    dim_branch ||--o{ fact_fx_transactions : joins
    dim_currency ||--o{ fact_fx_transactions : joins
    dim_channel ||--o{ fact_fx_transactions : joins

    dim_customer ||--o{ fact_feedback : joins
    dim_branch ||--o{ fact_feedback : joins

    dim_customer ||--o{ fact_customer_consent : joins
    dim_consent_type ||--o{ fact_customer_consent : joins
```

------------------------------------------------------------------------

# 🏦 Gold Layer -- Treasury Analytics

## Business Use Cases

-   Vault inventory monitoring
-   Lease utilization tracking
-   Currency consumption analysis
-   Bank exposure management

### Dimensions

-   dim_bank
-   dim_lease
-   dim_currency
-   dim_branch
-   dim_date

### Facts

-   fact_vault_inventory_snapshot
-   fact_cash_consumption

## ER Diagram (Treasury)

``` mermaid
erDiagram
    dim_bank ||--o{ fact_cash_consumption : joins
    dim_lease ||--o{ fact_cash_consumption : joins
    dim_currency ||--o{ fact_cash_consumption : joins
    dim_branch ||--o{ fact_cash_consumption : joins
```

------------------------------------------------------------------------

# 🏛 Gold Layer -- Bank Reporting

## Business Use Cases

-   Settlement reporting to banks
-   Interest calculation validation
-   Outstanding balance monitoring
-   Daily bank consumption report

### Facts

-   fact_bank_settlement
-   bank_consumption_report

## ER Diagram (Bank Reporting)

``` mermaid
erDiagram
    dim_bank ||--o{ fact_bank_settlement : joins
    dim_lease ||--o{ fact_bank_settlement : joins
    dim_currency ||--o{ fact_bank_settlement : joins

    fact_cash_consumption ||--o{ bank_consumption_report : aggregates
    fact_bank_settlement ||--o{ bank_consumption_report : aggregates
```

------------------------------------------------------------------------

# 🔁 SCD Type 2 Strategy

Implemented using **dbt snapshots** for:

-   Customers
-   Branches
-   Cash Leases
-   Consent

Fields generated: - dbt_valid_from - dbt_valid_to - is_current flag -
hashdiff for change detection

------------------------------------------------------------------------

# 🔐 Hashing Strategy

All hubs and links use deterministic hash keys:

-   `hash_key()` macro
-   `hashdiff()` macro for satellites

Ensures: - Immutable keys - Scalable joins - Source system independence

------------------------------------------------------------------------

# 🚀 Why This Architecture Works

✔ Scalable\
✔ Audit-friendly\
✔ Fully historized\
✔ Supports regulatory compliance\
✔ Bank-grade financial reporting\
✔ Marketing + Treasury separation

------------------------------------------------------------------------

# 📂 Folder Structure

    models/
     ├── bronze/
     ├── silver/
     │   ├── hubs/
     │   ├── links/
     │   └── satellites/
     └── gold/
         ├── retail_analytics/
         ├── treasury_analytics/
         └── bank_reporting/
    snapshots/
    macros/

------------------------------------------------------------------------