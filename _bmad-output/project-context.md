---
project_name: CleanArchitectureAA
user_name: thanhph
date: 2026-03-30
sections_completed: ['technology_stack', 'backend_conventions', 'api_endpoints', 'anti_patterns', 'frontend_patterns']
existing_patterns_found: 15
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

### Backend

| Category | Technology | Version |
|----------|------------|---------|
| Runtime | .NET | 10.0 |
| Framework | ASP.NET Core | 10.0 |
| ORM | Entity Framework Core | 10.0 |
| CQRS | MediatR | Latest |
| Authentication | ASP.NET Identity | Latest |
| API Docs | Scalar | Latest |
| Orchestration | .NET Aspire | Latest |
| Validation | FluentValidation | Latest |
| Mapping | AutoMapper | Latest |

### Frontends

| Frontend | Technology | Version |
|----------|------------|---------|
| Primary | Angular | 21 |
| Secondary | React | 19 |

### Testing

| Category | Framework |
|----------|-----------|
| Unit | NUnit + Shouldly |
| Functional | NUnit + Respawn |
| Acceptance | Playwright |
| Mocking | Moq |

---

## Critical Implementation Rules

### C# / .NET Conventions

1. **Namespaces**: File-scoped, placed OUTSIDE the namespace block
2. **Interfaces**: MUST use `I` prefix (e.g., `IUserService`, not `UserService`)
3. **Private fields**: MUST use `_camelCase` (e.g., `_userService`, not `userService`)
4. **Using directives**: Placed OUTSIDE namespace block
5. **Type declarations**: NEVER use `var` - always explicit types
6. **Braces**: REQUIRED for ALL blocks (even single-line)
7. **Records**: Use records for immutable DTOs and commands

### Project Structure

```
src/
├── AppHost/           # Aspire orchestrator (ENTRY POINT - run from here)
├── Application/       # CQRS handlers (MediatR Commands/Queries)
├── Domain/            # Entities, Value Objects, Events
├── Infrastructure/    # EF Core DbContext, Identity, Configurations
├── ServiceDefaults/  # Shared middleware configurations
├── Shared/            # Cross-cutting concerns
└── Web/               # API Endpoints + Frontends
```

### CQRS Implementation

- ALL data operations MUST go through MediatR
- Commands: `CreateXxxCommand`, `UpdateXxxCommand`, `DeleteXxxCommand`
- Queries: `GetXxxQuery`, `GetAllXxxQuery`
- Handlers: `XxxCommandHandler`, `XxxQueryHandler`
- Validators: FluentValidation validators (e.g., `XxxCommandValidator`)

### API Endpoints Pattern

- Use **Minimal APIs** in `src/Web/Endpoints/`
- Group endpoints using `IEndpointGroup`
- Example pattern:
```csharp
public static class TodoLists
{
    public static void MapTodoListEndpoints(this IEndpointRouteBuilder app)
    {
        var group = app.MapGroup("/api/todolists");
        group.MapGet("/", async (IMediator mediator) => await mediator.Send(new GetTodosQuery()));
    }
}
```

### Entity Base Classes

- Use `BaseEntity` for simple entities
- Use `BaseAuditableEntity` for entities needing audit fields (CreatedBy, CreatedOn, etc.)
- Entities should have private collection initializers for navigation properties

### Domain Events

- Dispatch via `DispatchDomainEventsInterceptor`
- Handlers execute AFTER `SaveChanges`
- Events are collected in `DomainEvents` property

### Anti-Patterns (NEVER DO)

- ❌ NO `[Obsolete]` attributes in source code
- ❌ NO `// TODO:` or `// FIXME:` comments
- ❌ NO technical debt markers in source
- ❌ NO `as any`, `@ts-ignore`, `@ts-expect-error`
- ❌ NO empty catch blocks `catch(e) {}`
- ❌ NO `var` declarations - always explicit types

### Database

- Default: SQLite (`app.db`)
- Configuration: `src/Infrastructure/DependencyInjection.cs`
- Migrations: `dotnet ef migrations add <Name> --project src/Infrastructure`

### Testing

- Use NUnit as test runner
- Use Shouldly for assertions (not Assert)
- Test files go in `tests/` folder
- Follow naming: `[Feature].[Aspect]Tests.cs`

---

## Backend Conventions

### Application Layer

```
Application/
├── {Feature}/
│   ├── Commands/
│   │   ├── CreateXxx/
│   │   │   ├── CreateXxxCommand.cs
│   │   │   └── CreateXxxCommandValidator.cs
│   │   ├── UpdateXxx/
│   │   └── DeleteXxx/
│   ├── Queries/
│   │   └── GetXxx/
│   └── EventHandlers/
├── Common/
│   ├── Interfaces/
│   │   ├── IApplicationDbContext.cs
│   │   └── IIdentityService.cs
│   ├── Behaviours/
│   │   ├── ValidationBehaviour.cs
│   │   ├── AuthorizationBehaviour.cs
│   │   ├── PerformanceBehaviour.cs
│   │   └── LoggingBehaviour.cs
│   └── Models/
└── DependencyInjection.cs
```

### Infrastructure Layer

```
Infrastructure/
├── Data/
│   ├── ApplicationDbContext.cs
│   ├── Configurations/
│   │   └── {Entity}Configuration.cs
│   └── Interceptors/
│       ├── AuditableEntityInterceptor.cs
│       └── DispatchDomainEventsInterceptor.cs
└── Identity/
    ├── ApplicationUser.cs
    └── IdentityService.cs
```

---

## API Endpoints

All endpoints in `src/Web/Endpoints/`:

| Feature | File | Endpoints |
|---------|------|-----------|
| Todo Lists | TodoLists.cs | GET, POST, PUT, DELETE /api/todolists |
| Todo Items | TodoItems.cs | GET, POST, PUT, DELETE /api/todoitems |
| Users | Users.cs | GET /api/users |
| Weather | WeatherForecasts.cs | GET /api/weatherforecasts |

**Base URL**: `https://localhost:5000/`

**API Docs**: `/scalar/v1`

---

## Frontend Patterns

### Angular (src/Web/ClientApp/)

- Standard Angular 21 structure
- TypeScript strict mode
- Run: `npm start` (port 4200)

### React (src/Web/ClientApp-React/)

- React 19 with hooks
- TypeScript
- Run: `npm start` (port 5200)

---

## Unique Project Characteristics

1. **Dual SPA Frontends**: Both Angular AND React present
2. **.NET Aspire**: AppHost pattern for orchestration (not traditional single entry)
3. **Solution Format**: `.slnx` (slim XML) - NOT `.sln`
4. **Test Framework**: NUnit + Shouldly + Moq (NOT xUnit)
5. **BDD Testing**: Reqnroll with Playwright for acceptance tests

---

## Commands Reference

```bash
# Run application (Aspire dashboard)
dotnet run --project ./src/AppHost

# Build all projects
dotnet build

# Run tests
dotnet test

# Add migration
dotnet ef migrations add <Name> --project src/Infrastructure

# Update database
dotnet ef database update --project src/Infrastructure
```

---

## Notes

- GitHub Actions: 4 workflows in `.github/workflows/`
- No Dockerfile (not containerized yet)
- Max directory depth: 6
