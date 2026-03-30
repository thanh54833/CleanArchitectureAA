# Project Overview - CleanArchitectureAA

## Executive Summary

CleanArchitectureAA is a modern full-stack web application built with .NET 10 Clean Architecture, featuring dual frontend frameworks (Angular 21 and React 19), orchestrated by .NET Aspire. The project follows Clean Architecture principles with clear separation of concerns across multiple layers.

## Technology Stack

### Backend

| Category | Technology | Version |
|----------|------------|---------|
| Runtime | .NET | 10.0 |
| Framework | ASP.NET Core | 10.0 |
| ORM | Entity Framework Core | 10.0 |
| CQRS | MediatR | Latest |
| Authentication | ASP.NET Identity | Latest |
| API Documentation | Scalar | Latest |
| Orchestration | .NET Aspire | Latest |

### Frontends

| Framework | Location | Language |
|-----------|----------|----------|
| Angular 21 | `src/Web/ClientApp/` | TypeScript |
| React 19 | `src/Web/ClientApp-React/` | TypeScript |

### Testing

| Type | Framework |
|------|-----------|
| Unit | NUnit + Shouldly |
| Functional | NUnit + Respawn |
| Acceptance | Playwright |

## Architecture Pattern

### Clean Architecture Layers

```
┌─────────────────────────────────────────────┐
│                 Web Layer                    │
│         (API Endpoints, Controllers)         │
├─────────────────────────────────────────────┤
│              Application Layer               │
│    (CQRS Handlers, MediatR Commands/Queries)│
├─────────────────────────────────────────────┤
│                Domain Layer                  │
│        (Entities, Value Objects, Events)     │
├─────────────────────────────────────────────┤
│            Infrastructure Layer              │
│    (EF Core, Identity, External Services)    │
└─────────────────────────────────────────────┘
```

### Key Architectural Features

1. **CQRS Pattern**: All data operations go through MediatR commands and queries
2. **Domain-Driven Design**: Clear domain entities with rich behavior
3. **Repository Pattern**: Abstractions over data access
4. **Mediator Pipeline**: Behaviors for validation, authorization, logging, performance
5. **Minimal APIs**: Modern endpoint routing without traditional controllers

## Repository Structure

This is a **multi-part project** with three main components:

### Part 1: Backend API
- **Path**: `src/`
- **Type**: Web Backend
- **Description**: .NET 10 Clean Architecture API with CQRS

### Part 2: Angular Frontend  
- **Path**: `src/Web/ClientApp/`
- **Type**: Web SPA
- **Description**: Angular 21 single-page application

### Part 3: React Frontend
- **Path**: `src/Web/ClientApp-React/`
- **Type**: Web SPA
- **Description**: React 19 single-page application

## Integration Points

| From | To | Type | Protocol |
|------|-----|------|----------|
| Angular | Backend | REST API | HTTP |
| React | Backend | REST API | HTTP |
| Frontends | Identity | OAuth2/OIDC | HTTP |

## Key Features

- Todo list management (CRUD operations)
- Weather forecast sample endpoint
- User management via ASP.NET Identity
- JWT Bearer authentication
- Domain events for decoupling
- Automatic audit fields (CreatedBy, CreatedOn, etc.)
- Soft delete support via base entities

## Database

- **Provider**: SQLite (default), configurable to PostgreSQL, SQL Server
- **Migrations**: Entity Framework Core migrations
- **Seeding**: Automatic database initialization

## Build & Deployment

- **CI/CD**: GitHub Actions workflows
- **Build**: `dotnet build`
- **Test**: `dotnet test`
- **Run**: `dotnet run --project src/AppHost`

## Documentation Links

- [Architecture Details](./architecture.md)
- [Source Tree](./source-tree-analysis.md)
- [API Contracts](./api-contracts.md)
- [Data Models](./data-models.md)
- [Development Guide](./development-guide.md)
