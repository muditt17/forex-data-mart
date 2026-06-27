# ADR-003: Pre-model Budget and Transaction Data for Reporting

| Status | Accepted |
|---------|----------|
| Date | 2025-XX-XX |
| Decision Makers | Data Platform Team |
| Category | Analytics Architecture |

---

## Context

Business dashboards required comparison between Actual and Budget values.

Budget dataset

- Monthly granularity
- Site level

Transaction dataset

- Transaction level
- Multiple records per site per day

The visualization platform (AWS QuickSight) did not support multiple fact tables for this reporting scenario.

Direct joins produced duplicate records and incorrect aggregations.

---

## Decision

Prepare a reporting-ready analytical model within the data platform.

Budget values were incorporated into the reporting dataset using dedicated budget columns rather than relying on runtime joins inside the visualization layer.

---

## Rationale

Analytical complexity should be solved within the governed data platform rather than delegated to reporting tools.

This approach ensures:

- consistent calculations
- correct aggregation
- simplified dashboard development
- reusable reporting datasets

---

## Alternatives Considered

### Join datasets inside QuickSight

Pros

- Less engineering effort

Cons

- Duplicate records
- Incorrect metrics
- Complex dashboard maintenance
- Tool limitations

Decision: Rejected

---

## Consequences

Positive

- Accurate Actual vs Budget reporting
- Elimination of duplicate records
- Simpler dashboard implementation
- Reduced dependency on visualization tool behavior

---

## Architecture Principles

- Model once, consume many
- Platform over visualization logic
- Consistent business metrics