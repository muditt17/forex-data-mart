# FX Data Platform Architecture

## Overview

The FX Data Platform demonstrates how modern analytics engineering practices can be combined with enterprise architecture principles to build scalable, governed data products.

Unlike a traditional dbt repository that focuses solely on SQL transformations, this project illustrates architectural decision making, layered data modelling, operational governance, and reusable design patterns used in enterprise financial platforms.

The implementation follows four major principles:

- Layered Medallion Architecture
- Data Product Thinking
- Domain-driven Modelling
- Architecture Decision Records (ADR)

---

## High-Level Architecture

```mermaid
flowchart LR

A[FX Source Systems]
B[Landing / Raw]
C[Bronze]
D[Silver]
E[Gold]
F[Data Products]
G[BI / Analytics]

A --> B
B --> C
C --> D
D --> E
E --> F
F --> G