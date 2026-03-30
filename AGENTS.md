# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-30
**Commit:** cb4f0ac
**Branch:** main

## OVERVIEW
.NET 10 Clean Architecture solution with ASP.NET Core, Angular 21 + React 19 frontends, Entity Framework Core, MediatR, and .NET Aspire orchestration.

## STRUCTURE
```
./
├── src/
│   ├── AppHost/           # Aspire orchestrator (entry point)
│   ├── Application/      # CQRS, MediatR handlers
│   ├── Domain/           # Entities, value objects
│   ├── Infrastructure/   # EF Core, data access
│   ├── ServiceDefaults/  # Shared middleware
│   ├── Shared/           # Cross-cutting
│   └── Web/              # API + ClientApp + ClientApp-React
├── tests/                # NUnit + Shouldly + Playwright
├── .aspire/              # Aspire config
└── templates/            # Use case templates
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| Run app | `dotnet run --project src/AppHost` | Aspire dashboard |
| Add feature | Use `templates/ca-use-case/` | Code generation |
| DB migrations | `src/Infrastructure/` | EF Core |
| API endpoints | `src/Web/Endpoints/` | Minimal APIs |

## CONVENTIONS (THIS PROJECT)
- **Namespaces**: File-scoped, outside namespace
- **Interfaces**: `I` prefix (IPascalCase)
- **Private fields**: `_camelCase`
- **Using directives**: Outside namespace
- **Prefer var**: FALSE (explicit types)
- **Braces**: Required for all blocks

## ANTI-PATTERNS (THIS PROJECT)
- No `[Obsolete]` attributes in source
- No `// TODO:` or `// FIXME:` comments
- Source code is clean of technical debt markers
- No `var` declarations - always explicit types

## UNIQUE STYLES
- Dual SPA: Both Angular (`ClientApp`) and React (`ClientApp-React`) present
- .NET Aspire: AppHost pattern instead of traditional single entry
- Solution format: `.slnx` (slim XML) not `.sln`
- Test framework: NUnit + Shouldly + Moq (not xUnit)
- BDD: Reqnroll with Playwright for acceptance tests
- Node 24.x (bleeding edge - consider 22.x LTS)

## CI/CD (GitHub Actions)
- 4 workflows: build.yml, codeql.yml, release.yml, test-templates.yml
- Template matrix testing (9 combinations: 3 frontends × 3 databases)
- Dual frontend cache inefficiency (caches both Angular+React)

## COMMANDS
```bash
# Run (Aspire dashboard)
dotnet run --project ./src/AppHost

# Build all
dotnet build

# Test
dotnet test

# Add migration
dotnet ef migrations add --project src/Infrastructure
```

## NOTES
- 2 frontend packages: `src/Web/ClientApp/` (Angular) + `src/Web/ClientApp-React/` (React)
- GitHub workflows: 4 workflows in `.github/workflows/`
- No Dockerfile (no containerization)
- Max directory depth: 6
