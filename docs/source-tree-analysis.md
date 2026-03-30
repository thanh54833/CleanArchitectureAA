# Source Tree Analysis

## Project Root Structure

```
CleanArchitectureAA/
├── src/                      # Source code
│   ├── AppHost/              # Aspire orchestrator (entry point)
│   ├── Application/          # CQRS handlers
│   ├── Domain/               # Business entities
│   ├── Infrastructure/       # Data access, Identity
│   ├── ServiceDefaults/     # Shared middleware
│   ├── Shared/               # Cross-cutting
│   └── Web/                  # API + Frontends
├── tests/                    # Test projects
├── docs/                     # This documentation
├── .github/workflows/        # CI/CD pipelines
├── .aspire/                  # Aspire configuration
├── templates/                # Code generation templates
├── CleanArchitecture.slnx   # Solution file
└── README.md                 # Main readme
```

## Detailed Source Structure

### src/AppHost/ - Aspire Orchestrator

```
AppHost/
├── AppHost.csproj           # Project file
├── Program.cs               # Entry point - Aspire dashboard
└── Extensions.cs            # Service configurations
```

**Purpose**: Orchestrates all services via .NET Aspire dashboard.

### src/Application/ - CQRS Layer

```
Application/
├── Application.csproj
├── DependencyInjection.cs
├── GlobalUsings.cs
├── TodoLists/               # Feature: Todo Lists
│   ├── Commands/
│   │   ├── CreateTodoList/
│   │   ├── DeleteTodoList/
│   │   └── UpdateTodoList/
│   └── Queries/
│       └── GetTodos/
├── TodoItems/               # Feature: Todo Items
│   ├── Commands/
│   │   ├── CreateTodoItem/
│   │   ├── DeleteTodoItem/
│   │   ├── UpdateTodoItem/
│   │   └── UpdateTodoItemDetail/
│   └── EventHandlers/
│       └── LogTodoItemCompleted.cs
├── WeatherForecasts/        # Sample feature
│   └── Queries/
│       └── GetWeatherForecasts/
└── Common/
    ├── Interfaces/
    │   ├── IApplicationDbContext.cs
    │   ├── IIdentityService.cs
    │   └── IUser.cs
    ├── Models/
    │   ├── LookupDto.cs
    │   └── Result.cs
    ├── Behaviours/
    │   ├── AuthorizationBehaviour.cs
    │   ├── LoggingBehaviour.cs
    │   ├── PerformanceBehaviour.cs
    │   ├── UnhandledExceptionBehaviour.cs
    │   └── ValidationBehaviour.cs
    ├── Exceptions/
    │   ├── ForbiddenAccessException.cs
    │   └── ValidationException.cs
    └── Security/
        └── AuthorizeAttribute.cs
```

**Key Files**:
- `DependencyInjection.cs` - MediatR and behavior registrations

### src/Domain/ - Business Logic

```
Domain/
├── Domain.csproj
├── GlobalUsings.cs
├── Entities/
│   ├── TodoItem.cs
│   └── TodoList.cs
├── ValueObjects/
│   └── Colour.cs
├── Events/
│   └── TodoItemCompletedEvent.cs
├── Common/
│   ├── BaseEntity.cs
│   ├── BaseAuditableEntity.cs
│   ├── BaseEvent.cs
│   └── ValueObject.cs
├── Enums/
│   └── PriorityLevel.cs
├── Constants/
│   └── Roles.cs
└── Exceptions/
    └── UnsupportedColourException.cs
```

**Key Entities**:
- `TodoList` - Aggregate root for todo lists
- `TodoItem` - Child entity with priority and status

### src/Infrastructure/ - Data & External

```
Infrastructure/
├── Infrastructure.csproj
├── DependencyInjection.cs
├── GlobalUsings.cs
├── Data/
│   ├── ApplicationDbContext.cs
│   ├── ApplicationDbContextInitialiser.cs
│   ├── Configurations/
│   │   ├── TodoItemConfiguration.cs
│   │   └── TodoListConfiguration.cs
│   └── Interceptors/
│       ├── AuditableEntityInterceptor.cs
│       └── DispatchDomainEventsInterceptor.cs
└── Identity/
    ├── ApplicationUser.cs
    ├── IdentityService.cs
    └── IdentityResultExtensions.cs
```

### src/Web/ - API & Frontends

```
Web/
├── Web.csproj
├── Program.cs
├── DependencyInjection.cs
├── GlobalUsings.cs
├── Endpoints/                   # Minimal API endpoints
│   ├── TodoLists.cs
│   ├── TodoItems.cs
│   ├── Users.cs
│   └── WeatherForecasts.cs
├── Services/
│   └── CurrentUser.cs
├── Infrastructure/
│   ├── WebApplicationExtensions.cs
│   ├── EndpointRouteBuilderExtensions.cs
│   ├── IEndpointGroup.cs
│   ├── BearerSecuritySchemeTransformer.cs
│   ├── IdentityApiOperationTransformer.cs
│   ├── ApiExceptionOperationTransformer.cs
│   ├── ProblemDetailsExceptionHandler.cs
│   └── MethodInfoExtensions.cs
├── ClientApp/                  # Angular 21
│   ├── src/
│   │   ├── app/
│   │   ├── environments/
│   │   └── main.ts
│   ├── angular.json
│   ├── package.json
│   └── README.md
└── ClientApp-React/            # React 19
    ├── src/
    │   ├── components/
    │   ├── hooks/
    │   ├── services/
    │   └── App.tsx
    ├── package.json
    └── README.md
```

### src/ServiceDefaults/ - Shared

```
ServiceDefaults/
├── ServiceDefaults.csproj
└── Extensions.cs
```

### src/Shared/ - Cross-Cutting

```
Shared/
├── Shared.csproj
└── Services.cs
```

## Test Projects

```
tests/
├── Domain.UnitTests/
│   └── ValueObjects/
│       └── ColourTests.cs
├── Application.UnitTests/
│   ├── Common/
│   │   ├── Behaviors/
│   │   └── Mappings/
│   └── GlobalUsings.cs
├── Application.FunctionalTests/
│   ├── TodoLists/
│   │   ├── Commands/
│   │   └── Queries/
│   ├── TodoItems/
│   │   └── Commands/
│   ├── Infrastructure/
│   ├── GlobalUsings.cs
│   └── FunctionalTestSetup.cs
├── Infrastructure.IntegrationTests/
│   └── GlobalUsings.cs
├── Web.AcceptanceTests/
│   ├── Pages/
│   │   ├── BasePage.cs
│   │   ├── HomePage.cs
│   │   ├── LoginPage.cs
│   │   ├── CounterPage.cs
│   │   └── WeatherPage.cs
│   ├── StepDefinitions/
│   │   ├── HomeStepDefinitions.cs
│   │   ├── LoginStepDefinitions.cs
│   │   ├── CounterStepDefinitions.cs
│   │   └── WeatherStepDefinitions.cs
│   ├── PlaywrightSetup.cs
│   ├── AspireSetup.cs
│   └── GlobalUsings.cs
└── TestAppHost/
    └── Program.cs
```

## Entry Points

| Purpose | Entry Point |
|---------|--------------|
| Run App | `dotnet run --project src/AppHost` |
| API | `src/Web/Program.cs` |
| Angular | `src/Web/ClientApp/src/main.ts` |
| React | `src/Web/ClientApp-React/src/main.tsx` |
| Tests | `dotnet test` |

## Critical Directories

| Directory | Purpose | Key Files |
|-----------|---------|-----------|
| `src/Web/Endpoints/` | API routes | `TodoLists.cs`, `TodoItems.cs` |
| `src/Application/*/` | Business logic | Handlers, Validators |
| `src/Domain/Entities/` | Domain models | `TodoList.cs`, `TodoItem.cs` |
| `src/Infrastructure/Data/` | EF Core setup | `ApplicationDbContext.cs` |
| `tests/*/` | Test suites | Various test files |

## Integration Points

1. **Frontend → Backend**: HTTP REST calls to API endpoints
2. **Application → Domain**: Direct entity references
3. **Application → Infrastructure**: Interface implementations
4. **Web → Application**: MediatR dispatch
5. **Infrastructure → Database**: EF Core DbContext
