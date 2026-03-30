# Development Guide

## Prerequisites

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| .NET SDK | 10.0+ | Backend runtime |
| Node.js | LTS | Frontend development |
| npm | Latest | Package management |
| Git | Any | Version control |

### Optional Tools

| Tool | Purpose |
|------|---------|
| Visual Studio 2022 | IDE |
| VS Code | Lightweight editor |
| Rider | Cross-platform .NET IDE |
| Docker Desktop | Containerization (optional) |

## Setup

### 1. Clone Repository

```bash
git clone <repository-url>
cd CleanArchitectureAA
```

### 2. Restore Dependencies

```bash
dotnet restore
```

### 3. Run the Application

```bash
dotnet run --project src/AppHost
```

This starts the **Aspire dashboard** at `http://localhost:17179` (default port).

### 4. Access Services

| Service | Default URL |
|---------|-------------|
| Aspire Dashboard | http://localhost:17179 |
| Web API | http://localhost:5000 |
| Scalar API Docs | http://localhost:5000/scalar/v1 |
| Angular App | http://localhost:4200 |
| React App | http://localhost:5200 |

## Project Structure

### Backend (src/)

```
src/
├── AppHost/           # Aspire orchestrator
├── Application/      # CQRS handlers
├── Domain/          # Entities, Value Objects
├── Infrastructure/   # EF Core, Identity
├── ServiceDefaults/ # Shared middleware
├── Shared/          # Cross-cutting
└── Web/             # API + Frontends
```

### Frontends

| Frontend | Path | Port |
|----------|------|------|
| Angular | src/Web/ClientApp/ | 4200 |
| React | src/Web/ClientApp-React/ | 5200 |

## Common Development Tasks

### Add a New Feature

1. **Create Domain Entity** (if needed)
   - Add to `src/Domain/Entities/`

2. **Add Application Handler**
   - Command/Query in `src/Application/{Feature}/`

3. **Add Endpoint**
   - Add to `src/Web/Endpoints/`

4. **Add Database Migration**
   ```bash
   dotnet ef migrations add <Name> --project src/Infrastructure
   ```

### Add Database Migration

```bash
dotnet ef migrations add <MigrationName> --project src/Infrastructure --startup-project src/Web
```

### Update Database

```bash
dotnet ef database update --project src/Infrastructure --startup-project src/Web
```

### Run Migrations in Code

The app automatically applies migrations on startup via `ApplicationDbContextInitialiser`.

## Building

### Build All Projects

```bash
dotnet build
```

### Build Specific Project

```bash
dotnet build src/Web/Web.csproj
```

### Publish

```bash
dotnet publish src/AppHost/AppHost.csproj -c Release
```

## Testing

### Run All Tests

```bash
dotnet test
```

### Run Specific Test Project

```bash
dotnet test tests/Application.UnitTests
```

### Run with Coverage

```bash
dotnet test --collect:"XPlat Code Coverage"
```

### Test Projects

| Project | Type |
|---------|------|
| Domain.UnitTests | Unit |
| Application.UnitTests | Unit |
| Application.FunctionalTests | Functional |
| Infrastructure.IntegrationTests | Integration |
| Web.AcceptanceTests | E2E |

### Acceptance Tests (Playwright)

```bash
cd tests/Web.AcceptanceTests
dotnet test
```

Requires: `npm install` in test project.

## Code Style

### Conventions

| Element | Style |
|---------|-------|
| Namespaces | File-scoped |
| Interfaces | `I` prefix (IPascalCase) |
| Private fields | `_camelCase` |
| Using directives | Outside namespace |
| Types | Explicit (not `var`) |
| Braces | Required for all blocks |

### Anti-Patterns

- ❌ No `[Obsolete]` in source
- ❌ No `// TODO:` or `// FIXME:`
- ❌ No `as any`, `@ts-ignore`
- ❌ No empty catch blocks

## Frontend Development

### Angular

```bash
cd src/Web/ClientApp
npm install
npm start
```

### React

```bash
cd src/Web/ClientApp-React
npm install
npm start
```

## Configuration

### Database

Default: SQLite (`app.db`)

To change database provider, update:

1. `src/Infrastructure/DependencyInjection.cs`
2. `src/Web/appsettings.json` (connection string)

### Environment Variables

| Variable | Description |
|----------|-------------|
| `ASPNETCORE_ENVIRONMENT` | Development/Production |
| `ConnectionStrings__DefaultConnection` | Database connection |

### appsettings.json Structure

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Data Source=app.db"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  }
}
```

## Troubleshooting

### Port Already in Use

Kill process on port:
```bash
# macOS/Linux
lsof -i :5000 | awk 'NR>1 {print $2}' | xargs kill

# Windows
netstat -ano | findstr :5000
taskkill /PID <pid> /F
```

### Database Issues

Delete and recreate:
```bash
rm app.db
dotnet ef database update --project src/Infrastructure --startup-project src/Web
```

### Clean Build

```bash
dotnet clean
dotnet build
```

## Contributing

1. Create feature branch
2. Make changes
3. Run tests
4. Create PR

### Commit Messages

Use conventional commits:
- `feat: add new feature`
- `fix: resolve bug`
- `docs: update documentation`
- `test: add tests`

## Additional Resources

- [Clean Architecture Book](https://docs.microsoft.com/en-us/dotnet/architecture/modern-web-apps-azure-common/web-api-architecture)
- [MediatR Documentation](https://github.com/jbogard/MediatR)
- [Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/)
- [.NET Aspire](https://learn.microsoft.com/en-us/dotnet/aspire/)
