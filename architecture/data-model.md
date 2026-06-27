# Data Model

## Overview

The platform uses dimensional modelling for analytical consumption while maintaining reusable intermediate transformation models.

## Entity Relationship

```mermaid
erDiagram
DIM_CURRENCY ||--o{ FACT_TRANSACTION : currency
DIM_COUNTRY ||--o{ FACT_TRANSACTION : country
DIM_DATE ||--o{ FACT_TRANSACTION : date
DIM_COUNTRY ||--o{ FACT_BUDGET : country
DIM_DATE ||--o{ FACT_BUDGET : date
```

## Star Schema

```mermaid
flowchart LR
Date --> FactTransaction
Country --> FactTransaction
Currency --> FactTransaction
Date --> FactBudget
Country --> FactBudget
```

## Fact Tables

### fact_transaction

**Grain**

One financial transaction.

Measures

- Amount
- Converted Amount
- Transaction Count

### fact_budget

**Grain**

Budget allocation by period and business unit.

Measures

- Budget Amount
- Forecast
- Variance

## Dimensions

- dim_date
- dim_country
- dim_currency

## Data Quality

- Unique tests
- Not Null tests
- Relationships
- Accepted Values
- Freshness monitoring

## Lineage

```mermaid
flowchart LR
Sources --> Staging
Staging --> Intermediate
Intermediate --> Dimensions
Intermediate --> Facts
Dimensions --> Products
Facts --> Products
```

## Future Roadmap

- Semantic Layer
- Metrics Layer
- Data Vault support
- CDC ingestion
