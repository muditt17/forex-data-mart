# ADR-001: Protect Curated Models from Full Refresh

| Status | Accepted |
|---------|----------|
| Date | 2025-XX-XX |
| Decision Makers | Data Platform Team |
| Category | Data Platform / Data Governance |

---

## Context

The platform ingests raw operational data every 8 hours.

The Raw layer is intentionally designed to be replaceable since it mirrors the latest available source data.

The Curated layer, however, stores standardized historical business data that serves downstream reporting, analytics, and regulatory requirements.

Allowing unrestricted `dbt --full-refresh` execution on curated models introduced the risk of accidental historical data loss during operational or development activities.

---

## Decision

Disable standard full-refresh execution for all Curated models.

Full rebuilds must only be performed through controlled administrative procedures after appropriate approval and impact assessment.

---

## Rationale

The Curated layer represents trusted business history rather than transient transformation outputs.

Protecting historical data ensures:

- preservation of historical reporting
- prevention of accidental overwrite
- stable downstream analytical datasets
- increased confidence in production deployments

---

## Alternatives Considered

### Allow unrestricted full refresh

Pros

- Simpler operational process
- Easier developer workflow

Cons

- High operational risk
- Potential loss of historical business data
- Reduced trust in platform stability

Decision: Rejected

---

## Consequences

Positive

- Historical business records remain protected.
- Production deployments become safer.
- Downstream reporting remains consistent.

Negative

- Controlled recovery procedures are required for complete rebuilds.
- Slight increase in operational governance.

---

## Architecture Principles

- Historical data preservation
- Governance over convenience
- Production safety first