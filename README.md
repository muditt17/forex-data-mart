# 💱 FX Currency Exchange Data Platform (v7)

Enterprise-grade FX Data Platform built using:

-   🥉 Bronze (Raw Ingestion)
-   🥈 Silver (Data Vault 2.0 + Snapshots)
-   🥇 Gold (Dimensional Marts -- Retail, Treasury, Bank Reporting)
-   🔁 SCD Type 2 via dbt Snapshots
-   ⚡ Incremental Processing

------------------------------------------------------------------------

# 🏗️ Architecture Overview

            Source Systems
                  │
                  ▼
            ┌───────────────┐
            │     RAW       │  (PostgreSQL raw schema)
            └───────────────┘
                  │
                  ▼
            ┌───────────────┐
            │   Bronze      │  (Views over RAW)
            └───────────────┘
                  │
                  ▼
            ┌────────────────────────────┐
            │ Silver (Data Vault 2.0)    │
            │ - Hubs                     │
            │ - Links                    │
            │ - Satellites               │
            │ - Snapshots (SCD2)         │
            └────────────────────────────┘
                  │
                  ▼
            ┌──────────────────────────────────────────┐
            │ Gold (Dimensional Models)               │
            │ 1. Retail / Marketing Analytics         │
            │ 2. Treasury Analytics                   │
            │ 3. Bank Reporting                       │
            └──────────────────────────────────────────┘

------------------------------------------------------------------------

# 🥉 Bronze Layer

### Purpose

-   Lightweight staging layer
-   Mirrors raw tables as views
-   No transformations
-   No business logic

### Important Update (v7)

The following entities were moved from Bronze to Snapshots:

-   Customers
-   Branches
-   Cash Leases
-   Consent

These are now historized using SCD2 snapshots.

Bronze now only contains non-historized event data: - transactions_raw -
feedback_raw - vault_stock_raw - bank_settlement_raw - fx_rates_raw -
banks_raw

------------------------------------------------------------------------

# 🥈 Silver Layer -- Data Vault 2.0

## 🔹 Hubs

-   hub_customer
-   hub_branch
-   hub_transaction
-   hub_currency
-   hub_bank
-   hub_cash_lease
-   hub_consent

## 🔹 Links

-   link_txn_customer
-   link_txn_branch
-   link_txn_currency
-   link_lease_bank
-   link_lease_currency
-   link_customer_consent

## 🔹 Satellites

-   sat_transaction_financials
-   sat_feedback_details
-   sat_vault_stock_daily
-   sat_settlement_details
-   sat_bank_details
-   sat_customer_details (SCD2)
-   sat_branch_details (SCD2)
-   sat_cash_lease_details (SCD2)
-   sat_consent_details (SCD2)

------------------------------------------------------------------------

# 🔁 Snapshots (SCD Type 2)

Snapshots are implemented for:

-   customer_snapshot
-   branch_snapshot
-   cash_lease_snapshot
-   consent_snapshot

Strategy: `check`\
Tracked fields use `hashdiff` for change detection.

Snapshot tables generate:

-   dbt_valid_from
-   dbt_valid_to
-   is_current flag
-   Historical versions preserved

Silver satellites read from snapshot tables to maintain Data Vault
compliance.

------------------------------------------------------------------------

# 🥇 Gold Layer (Dimensional Models)

## 🚫 Design Rule (v7 Update)

Gold models **never read from raw or bronze tables**.

Gold ONLY consumes: - Silver Hubs - Silver Links - Silver Satellites

This enforces strict layered architecture.

------------------------------------------------------------------------

## 1️⃣ Retail / Marketing Analytics

### Dimensions

-   dim_customer
-   dim_branch
-   dim_currency
-   dim_channel
-   dim_consent_type
-   dim_date

### Facts

-   fact_fx_transactions
-   fact_feedback
-   fact_customer_consent

Sources: Silver satellites only.

------------------------------------------------------------------------

## 2️⃣ Treasury Analytics

### Dimensions

-   dim_bank
-   dim_currency
-   dim_branch

### Facts

-   fact_vault_inventory_snapshot
-   fact_cash_consumption

All inventory and lease logic sourced from: - sat_vault_stock_daily -
sat_cash_lease_details

------------------------------------------------------------------------

## 3️⃣ Bank Reporting

### Facts

-   fact_bank_settlement

Uses: - sat_settlement_details - sat_cash_lease_details

Provides: - Settlement reporting - Interest validation - Outstanding
balance calculation - Consumption allocation

------------------------------------------------------------------------

# ⚙️ Incremental Strategy

  Layer              Strategy
  ------------------ ---------------------
  Hubs               incremental + merge
  Links              incremental + merge
  Event Satellites   incremental + merge
  SCD2 Satellites    Snapshots
  Gold Facts         incremental
  Gold Dimensions    table

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
    raw_data/
    scripts/

------------------------------------------------------------------------

# 🔐 Hashing Strategy

Macros used:

-   hash_key()
-   hashdiff()

Ensures: - Deterministic surrogate keys - Immutable hub/link keys -
Proper change detection for satellites

------------------------------------------------------------------------

# 🚀 Production Characteristics

✔ Fully historized customer & lease data\
✔ Bank-grade reporting\
✔ Clear separation of layers\
✔ Incremental processing\
✔ No gold → raw dependency\
✔ Snapshot-driven SCD2\
✔ Data Vault 2.0 compliant

------------------------------------------------------------------------

# 📌 Version Notes (v2)

-   Moved customer, branch, lease, consent to snapshots
-   Gold models now consume Silver only
-   Added missing silver satellites for vault stock & settlement
-   Updated schema.yml files
-   Enforced strict layered architecture

------------------------------------------------------------------------

# 👤 Author

FX Data Engineering Architecture\
Enterprise-ready dbt + Data Vault implementation
