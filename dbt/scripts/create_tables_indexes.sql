CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE raw.transactions_raw (
    transaction_id        VARCHAR(50),
    transaction_ts        TIMESTAMP NOT NULL,
    branch_id             VARCHAR(20),
    customer_id           VARCHAR(50),
    from_currency         VARCHAR(10),
    to_currency           VARCHAR(10),
    from_amount           NUMERIC(18,2),
    exchange_rate         NUMERIC(18,6),
    to_amount             NUMERIC(18,2),
    commission_fee        NUMERIC(18,2),
    payment_method        VARCHAR(30),
    channel               VARCHAR(30),
    status                VARCHAR(20),
    ingestion_timestamp   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_txn_id ON raw.transactions_raw(transaction_id);
CREATE INDEX idx_txn_customer ON raw.transactions_raw(customer_id);
CREATE INDEX idx_txn_ts ON raw.transactions_raw(transaction_ts);

CREATE TABLE raw.customers_raw (
    customer_id          VARCHAR(50),
    first_name           VARCHAR(100),
    last_name            VARCHAR(100),
    dob                  DATE,
    nationality          VARCHAR(10),
    risk_rating          VARCHAR(20),
    kyc_status           VARCHAR(20),
    created_at           TIMESTAMP,
    updated_at           TIMESTAMP,
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_customer_id ON raw.customers_raw(customer_id);

CREATE TABLE raw.branches_raw (
    branch_id            VARCHAR(20),
    branch_name          VARCHAR(150),
    city                 VARCHAR(100),
    country              VARCHAR(100),
    region               VARCHAR(100),
    opened_date          DATE,
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_branch_id ON raw.branches_raw(branch_id);

CREATE TABLE raw.fx_rates_raw (
    rate_ts              TIMESTAMP,
    base_currency        VARCHAR(10),
    quote_currency       VARCHAR(10),
    market_rate          NUMERIC(18,6),
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_fx_pair_time
ON raw.fx_rates_raw(base_currency, quote_currency, rate_ts);

CREATE TABLE raw.consent_raw (
    consent_id           VARCHAR(50),
    customer_id          VARCHAR(50),
    consent_type         VARCHAR(100),
    source_system        VARCHAR(100),
    consent_flag         BOOLEAN,
    consent_ts           TIMESTAMP,
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_consent_customer ON raw.consent_raw(customer_id);

CREATE TABLE raw.feedback_raw (
    feedback_id          VARCHAR(50),
    customer_id          VARCHAR(50),
    branch_id            VARCHAR(20),
    rating               INTEGER,
    comments             TEXT,
    form_id              VARCHAR(100),
    channel              VARCHAR(50),
    feedback_ts          TIMESTAMP,
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_feedback_customer ON raw.feedback_raw(customer_id);
CREATE INDEX idx_feedback_branch ON raw.feedback_raw(branch_id);

CREATE TABLE raw.banks_raw (
    bank_id              VARCHAR(50),
    bank_name            VARCHAR(150),
    country              VARCHAR(100),
    bank_type            VARCHAR(50),
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_bank_id ON raw.banks_raw(bank_id);

CREATE TABLE raw.cash_lease_raw (
    lease_id             VARCHAR(50),
    bank_id              VARCHAR(50),
    currency_code        VARCHAR(10),
    lease_amount         NUMERIC(18,2),
    interest_rate        NUMERIC(6,2),
    lease_start          DATE,
    lease_end            DATE,
    lease_status         VARCHAR(20),
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_lease_bank ON raw.cash_lease_raw(bank_id);
CREATE INDEX idx_lease_currency ON raw.cash_lease_raw(currency_code);

CREATE TABLE raw.vault_stock_raw (
    branch_id            VARCHAR(20),
    currency_code        VARCHAR(10),
    stock_date           DATE,
    opening_balance      NUMERIC(18,2),
    closing_balance      NUMERIC(18,2),
    inflow_amount        NUMERIC(18,2),
    outflow_amount       NUMERIC(18,2),
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vault_lookup
ON raw.vault_stock_raw(branch_id, currency_code, stock_date);

CREATE TABLE raw.bank_settlement_raw (
    settlement_id        VARCHAR(50),
    lease_id             VARCHAR(50),
    amount_paid          NUMERIC(18,2),
    settlement_date      DATE,
    payment_status       VARCHAR(20),
    ingestion_timestamp  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_settlement_lease
ON raw.bank_settlement_raw(lease_id);