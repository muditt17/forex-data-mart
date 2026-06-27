# ADR-004: Implement Severity-Based Operational Alerting

| Status | Accepted |
|---------|----------|
| Date | 2025-XX-XX |
| Decision Makers | Data Platform Team |
| Category | Platform Operations |

---

## Context

The platform consisted of multiple ingestion, transformation, and reporting pipelines.

Different failures required different operational responses depending on:

- execution environment
- business impact
- ownership
- severity

Existing monitoring tooling (Datadog) was already licensed and widely adopted within the organization.

---

## Decision

Implement centralized operational monitoring using Datadog.

Alert routing is determined by:

- Severity level
- Environment
- Responsible team

Notification recipients differ according to operational criticality.

---

## Rationale

Using an existing enterprise monitoring platform avoids introducing additional operational tooling while enabling standardized monitoring across the platform.

Severity-based routing minimizes alert fatigue while ensuring production incidents receive appropriate attention.

---

## Alternatives Considered

### Generic notification for every failure

Pros

- Easy implementation

Cons

- Alert fatigue
- Low signal-to-noise ratio
- Reduced operational effectiveness

Decision: Rejected

---

## Consequences

Positive

- Faster incident response
- Standardized monitoring
- Better operational ownership
- Improved production reliability

Negative

- Initial configuration effort
- Ongoing maintenance of severity rules

---

## Architecture Principles

- Operational excellence
- Observability
- Incident ownership
- Least-noise alerting