# APPLICATION

## OVERVIEW
CQRS implementation with MediatR handlers for all business operations.

## STRUCTURE
```
Application/
├── Common/
│   ├── Behaviours/     # MediatR pipeline (logging, validation, auth, performance)
│   ├── Exceptions/    # Custom exceptions
│   ├── Interfaces/    # IApplicationDbContext, IIdentityService, IUser
│   ├── Models/        # Result, LookupDto
│   └── Security/      # Authorization attributes
├── DependencyInjection.cs  # DI setup for MediatR, AutoMapper, FluentValidation
├── TodoItems/        # Commands (CRUD), EventHandlers
├── TodoLists/        # Commands + Queries
└── WeatherForecasts/ # Sample query
```

## WHERE TO LOOK
| Task | Location |
|------|----------|
| Add new command | `src/Application/{Entity}/Commands/` |
| Add new query | `src/Application/{Entity}/Queries/` |
| Pipeline behavior | `src/Application/Common/Behaviours/` |
| DI registration | `src/Application/DependencyInjection.cs` |
| Validation | `{Handler}CommandValidator.cs` in same folder |

## CONVENTIONS
- Handlers: `IRequestHandler<Command, Result>` or `IRequestHandler<Query, Response>`
- Validators: `{Name}CommandValidator.cs` using FluentValidation
- DTOs: Separate files per type (Vm, Dto)
- Pipeline order: Logging → Authorization → Validation → Performance → Handler

## ANTI-PATTERNS
- Never put business logic in handlers (delegate to Domain/Application services)
- Never skip validators (use FluentValidation)
- Never return void/null (use `Result` type)
- Handlers should only orchestrate, not implement
