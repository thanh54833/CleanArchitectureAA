# Project Documentation Index

## Project Overview

- **Type:** Multi-part project with 3 parts
- **Primary Language:** C# (.NET 10)
- **Architecture:** Clean Architecture with Aspire orchestration

## Quick Reference

### Backend (.NET 10 API)

- **Type:** Backend Web API
- **Tech Stack:** .NET 10, ASP.NET Core, Entity Framework Core, MediatR, Identity
- **Root:** `src/`

### Angular Frontend

- **Type:** Web SPA
- **Tech Stack:** Angular 21, TypeScript
- **Root:** `src/Web/ClientApp/`

### React Frontend

- **Type:** Web SPA  
- **Tech Stack:** React 19, TypeScript
- **Root:** `src/Web/ClientApp-React/`

## Generated Documentation

### Core Documentation

- [Project Overview](./project-overview.md)
- [Architecture](./architecture.md)
- [Source Tree Analysis](./source-tree-analysis.md)
- [Data Models](./data-models.md)
- [API Contracts](./api-contracts.md)

### Frontend Documentation

- [Angular Component Inventory](./angular-components.md) _(To be generated)_
- [React Component Inventory](./react-components.md) _(To be generated)_

### Development & Operations

- [Development Guide](./development-guide.md)
- [Testing Strategy](./testing-strategy.md) _(To be generated)_
- [CI/CD Pipeline](./ci-cd-pipeline.md) _(To be generated)_

## Existing Documentation

- [Main README](../README.md) - Project introduction and getting started
- [Angular README](../src/Web/ClientApp/README.md) - Angular frontend setup
- [React README](../src/Web/ClientApp-React/README.md) - React frontend setup
- [BMAD Agents](../AGENTS.md) - AI agent configuration

## Getting Started

### Run the Application

```bash
dotnet run --project ./src/AppHost
```

This starts the .NET Aspire dashboard which orchestrates all services.

### Build All

```bash
dotnet build
```

### Run Tests

```bash
dotnet test
```

## Project Structure Summary

```
CleanArchitectureAA/
├── src/
│   ├── AppHost/           # Aspire orchestrator
│   ├── Application/       # CQRS handlers (MediatR)
│   ├── Domain/            # Entities, Value Objects
│   ├── Infrastructure/    # EF Core, Identity
│   ├── ServiceDefaults/   # Shared middleware
│   ├── Shared/            # Cross-cutting concerns
│   └── Web/               # API + ClientApp + ClientApp-React
├── tests/                 # NUnit + Shouldly + Playwright
└── .github/workflows/     # CI/CD pipelines
```
