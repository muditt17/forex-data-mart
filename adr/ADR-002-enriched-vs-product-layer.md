# ADR-002: Separate Enterprise Data Models from Product-Specific Logic

| Status | Accepted |
|---------|----------|
| Date | 2025-XX-XX |
| Decision Makers | Data Platform Team |
| Category | Data Architecture |

---

## Context

Multiple business teams required customized calculations, KPIs, and regional views.

Embedding business-unit-specific logic directly into enterprise datasets would reduce reusability and increase maintenance complexity.

Additionally, different regional authorities required controlled visibility into specific datasets.

---

## Decision

Adopt a layered architecture:

Enriched Layer

- standardized enterprise transformations
- reusable business entities
- common business definitions

Product Layer

- product-specific calculations
- regional requirements
- reporting-specific transformations
- implemented as views on top of Enriched datasets

---

## Rationale

Separating reusable enterprise logic from product-specific requirements enables:

- standardized business definitions
- reusable analytical assets
- independent product evolution
- simplified governance
- fine-grained access control

---

## Alternatives Considered

### Implement all business logic in Enriched layer

Pros

- Fewer datasets

Cons

- Low reusability
- Difficult governance
- Product-specific logic pollutes enterprise models

Decision: Rejected

---

## Consequences

Positive

- Enterprise datasets remain reusable.
- Regional access policies can be enforced.
- Team-specific calculations remain isolated.
- Governance becomes significantly easier.

Business Outcome

The architecture improved confidence among regional stakeholders, particularly within UAE operations where controlled data sharing and trusted enterprise datasets were essential.

---

## Architecture Principles

- Separation of concerns
- Reusability
- Data governance
- Product-oriented architecture