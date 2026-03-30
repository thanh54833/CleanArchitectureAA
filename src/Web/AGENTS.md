# AGENTS.md

## OVERVIEW

ASP.NET Core Web API with dual frontend SPAs (Angular 21 + React 19 + Vite).

## STRUCTURE

```
src/Web/
├── ClientApp/          # Angular 21 SPA (default frontend)
├── ClientApp-React/   # React 19 + Vite SPA (alternative)
├── Endpoints/         # Minimal API endpoint definitions
├── Infrastructure/    # Web infrastructure (extensions, handlers)
├── Services/          # Web-scoped services
├── Program.cs         # Entry point
└── DependencyInjection.cs
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add API endpoint | `Endpoints/*.cs` | Minimal API with `IEndpointGroup` pattern |
| Angular frontend | `ClientApp/src/app/` | Angular 21 components, services |
| React frontend | `ClientApp-React/src/` | React 19 + Vite, JSX components |
| Auth integration | `ClientApp/src/api-authorization/` | Angular auth |
| Auth (React) | `ClientApp-React/src/components/api-authorization/` | React auth context |
| App configuration | `Program.cs` | Minimal API registration |
| Current user service | `Services/CurrentUser.cs` | User context access |

## CONVENTIONS

- **Dual Frontend**: Both Angular and React present. Default routing serves Angular; React available at `/react` or separate port.
- **Minimal APIs**: Endpoints use `IEndpointGroup` pattern with `MapEndpoints()` extension.
- **Angular**: Standalone components, SCSS styling, TypeScript.
- **React**: JSX components, Vite bundler, `.jsx` extensions.
- **API**: RESTful Minimal APIs, ProblemDetails for errors.

## ANTI-PATTERNS

- Do not add both Angular and React components for the same feature unless specifically required.
- Avoid adding traditional MVC controllers; use Minimal APIs only.
- Do not modify `wwwroot/` directly for SPA serving (handled by middleware).
