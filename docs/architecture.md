# Architecture Documentation

## System Architecture Overview

CleanArchitectureAA implements a **Clean Architecture** pattern with **.NET Aspire** orchestration for a dual-frontend full-stack application.

## High-Level Architecture

```
                                    ┌─────────────────────┐
                                    │    .NET Aspire      │
                                    │      AppHost        │
                                    │   (Orchestrator)     │
                                    └──────────┬──────────┘
                                               │
                    ┌───────────────────────────┼───────────────────────────┐
                    │                           │                           │
                    ▼                           ▼                           ▼
        ┌───────────────────┐     ┌───────────────────┐     ┌───────────────────┐
        │   Web API         │     │   ClientApp        │     │  ClientApp-React  │
        │   (ASP.NET Core)  │     │   (Angular 21)     │     │   (React 19)       │
        └─────────┬─────────┘     └───────────────────┘     └───────────────────┘
                  │
        ┌────────┴────────┐
        │                 │
        ▼                 ▼
┌───────────────┐  ┌───────────────┐
│  Application  │  │   Identity    │
│   (CQRS)     │  │   Service     │
└───────┬───────┘  └───────────────┘
        │
        ▼
┌───────────────┐  ┌───────────────┐
│    Domain    │  │ Infrastructure│
│  (Entities)  │  │   (EF Core)   │
└───────────────┘  └───────────────┘
```

## Layer Architecture

### 1. Domain Layer (`src/Domain/`)

**Purpose**: Core business logic, independent of any external concerns.

**Contents**:
- `Entities/` - Business entities (TodoList, TodoItem)
- `ValueObjects/` - Immutable value types (Colour)
- `Events/` - Domain events (TodoItemCompletedEvent)
- `Common/` - Base classes (BaseEntity, BaseAuditableEntity, ValueObject)
- `Enums/` - Domain enumerations (PriorityLevel)
- `Constants/` - Static constants (Roles)
- `Exceptions/` - Domain-specific exceptions

**Key Principles**:
- No dependencies on other layers
- Contains only business logic
- Entities have identity and behavior
- Value objects are immutable

### 2. Application Layer (`src/Application/`)

**Purpose**: Application-specific business rules, orchestration.

**Contents**:
- `TodoLists/` - Todo list commands and queries
- `TodoItems/` - Todo item commands and queries  
- `WeatherForecasts/` - Sample weather forecast query
- `Common/`
  - `Interfaces/` - Abstractions (IApplicationDbContext, IIdentityService, IUser)
  - `Models/` - DTOs and result types
  - `Behaviours/` - Pipeline behaviors (Validation, Logging, Performance, Authorization)
  - `Exceptions/` - Application exceptions
  - `Security/` - Authorization attributes

**Key Principles**:
- Implements CQRS via MediatR
- All operations are commands or queries
- Pipeline behaviors for cross-cutting concerns
- Depends only on Domain layer

### 3. Infrastructure Layer (`src/Infrastructure/`)

**Purpose**: External concerns implementation.

**Contents**:
- `Data/`
  - `ApplicationDbContext` - EF Core DbContext
  - `Configurations/` - Entity configurations
  - `Interceptors/` - EF Core interceptors (Domain events, Audit fields)
- `Identity/`
  - `ApplicationUser` - Custom identity user
  - `IdentityService` - Identity operations
  - `IdentityResultExtensions` - Extension methods

**Key Principles**:
- Implements interfaces defined in Application
- Database access logic
- External service integrations

### 4. Web Layer (`src/Web/`)

**Purpose**: API entry point, frontend hosting.

**Contents**:
- `Program.cs` - Application entry
- `Endpoints/` - Minimal API endpoints
- `Services/` - Application services (CurrentUser)
- `Infrastructure/` - Web-specific infrastructure
  - Exception handlers
  - Endpoint route extensions
  - OpenAPI transformers
- `ClientApp/` - Angular 21 frontend
- `ClientApp-React/` - React 19 frontend

**Key Principles**:
- Minimal API pattern
- Endpoint grouping
- OpenAPI/Scalar integration
- Frontend SPA hosting

### 5. AppHost Layer (`src/AppHost/`)

**Purpose**: .NET Aspire application orchestrator.

**Contents**:
- `Program.cs` - Aspire app entry
- `Extensions.cs` - Service configurations

**Key Principles**:
- Orchestrates all services
- Dashboard for service management
- Health checks aggregation

### 6. ServiceDefaults (`src/ServiceDefaults/`)

**Purpose**: Shared middleware and configurations.

**Contents**:
- `Extensions.cs` - Common service configurations

**Key Principles**:
- Reusable configurations
- OpenTelemetry integration
- Resilience patterns

### 7. Shared (`src/Shared/`)

**Purpose**: Cross-cutting concerns.

**Contents**:
- `Services.cs` - Shared service registrations

## CQRS Implementation

### Command/Query Flow

```
Client Request
     │
     ▼
Minimal API Endpoint
     │
     ▼
MediatR Handler (Command/Query)
     │
     ├─► ValidationBehaviour (FluentValidation)
     │
     ├─► AuthorizationBehaviour
     │
     ├─► PerformanceBehaviour
     │
     ├─► LoggingBehaviour
     │
     ▼
Business Logic (Handler)
     │
     ▼
Infrastructure (Repository)
     │
     ▼
Database (EF Core)
```

### MediatR Pipeline Behaviors

1. **ValidationBehaviour** - FluentValidation integration
2. **AuthorizationBehaviour** - Policy-based authorization
3. **PerformanceBehaviour** - Slow request logging
4. **LoggingBehaviour** - Request/response logging
5. **UnhandledExceptionBehaviour** - Exception handling

## Data Flow

### Read Path (Query)

```
GET /api/todolists
     │
     ▼
GetTodosQuery
     │
     ▼
GetTodosQueryHandler
     │
     ├─► IApplicationDbContext
     │
     ├─► EF Core LINQ
     │
     ▼
List<TodoListDto>
     │
     ▼
Client (JSON)
```

### Write Path (Command)

```
POST /api/todolists
     │
     ▼
CreateTodoListCommand
     │
     ▼
CreateTodoListCommandHandler
     │
     ├─► Validation
     │
     ├─► IApplicationDbContext
     │
     ├─► Entity Creation
     │
     ├─► SaveChanges
     │
     ├─► Dispatch Domain Events
     │
     ▼
Result<Guid> (Created ID)
     │
     ▼
Client (JSON)
```

## Security Architecture

### Authentication

- **Type**: JWT Bearer Authentication
- **Identity**: ASP.NET Identity
- **User Store**: Entity Framework Core

### Authorization

- **Policy-based**: Role and claim authorization
- **Attributes**: `[Authorize]` with policies
- **Behaviors**: Pipeline-level authorization checks

## API Design

### Minimal APIs Pattern

```csharp
app.MapGet("/api/todolists", async (IMediator mediator) 
    => await mediator.Send(new GetTodosQuery()));
```

### Endpoint Grouping

Endpoints are organized by feature and use `IEndpointGroup` for organization.

### OpenAPI Integration

- Scalar for API documentation
- Custom operation transformers for:
  - Bearer security scheme
  - Exception handling
  - API versioning

## Frontend Architecture

### Angular (ClientApp)

```
ClientApp/
├── src/
│   ├── app/
│   │   ├── core/         # Services, guards
│   │   ├── features/    # Feature modules
│   │   ├── shared/       # Shared components
│   │   └── app.component.ts
│   └── environments/
└── angular.json
```

### React (ClientApp-React)

```
ClientApp-React/
├── src/
│   ├── components/       # React components
│   ├── hooks/           # Custom hooks
│   ├── services/        # API services
│   ├── pages/           # Page components
│   └── App.tsx
└── package.json
```

## Testing Architecture

### Test Projects

| Project | Type | Purpose |
|---------|------|---------|
| `Domain.UnitTests` | Unit | Domain logic tests |
| `Application.UnitTests` | Unit | Handler and behavior tests |
| `Application.FunctionalTests` | Functional | Database integration tests |
| `Infrastructure.IntegrationTests` | Integration | Infrastructure tests |
| `Web.AcceptanceTests` | Acceptance | E2E UI tests (Playwright) |

### Test Frameworks

- **NUnit** - Test runner
- **Shouldly** - Assertion library
- **Moq** - Mocking framework
- **Respawn** - Database cleanup between tests
- **Playwright** - Browser automation

## Configuration

### Environment Configuration

- `appsettings.json` - Default settings
- `appsettings.Development.json` - Development overrides
- `.env` - Environment variables (optional)

### Database Configuration

Default: SQLite (`app.db`)
Configurable to: PostgreSQL, SQL Server

## Deployment

### CI/CD Pipeline (GitHub Actions)

1. **Build** - `dotnet build`
2. **Test** - `dotnet test`
3. **CodeQL** - Security analysis
4. **Release** - Package publishing

## Scaling Considerations

- Aspire provides service discovery
- Ready for containerization (future)
- Database can be externalized
- Frontends can be deployed separately
