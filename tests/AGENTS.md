# TESTS

## OVERVIEW
NUnit test suite with Shouldly assertions, Moq mocking, and Playwright E2E testing.

## STRUCTURE
```
tests/
├── Domain.UnitTests/           # Entity/value object unit tests
├── Application.UnitTests/      # Handler/mapping/validation tests
├── Application.FunctionalTests/  # HTTP client integration tests
├── Infrastructure.IntegrationTests/  # Database integration tests
├── Web.AcceptanceTests/        # Reqnroll BDD + Playwright E2E
└── TestAppHost/                # Aspire test orchestrator
```

## WHERE TO LOOK
| Test Type | Project | Key Files |
|-----------|---------|-----------|
| Entity/VO | Domain.UnitTests | `[Entity]Tests.cs` in subfolders |
| Handlers | Application.UnitTests | `Commands/`/`Queries/` folders |
| HTTP integration | Application.FunctionalTests | `TestBase.cs`, `TestApp.cs` |
| DB tests | Infrastructure.IntegrationTests | Uses real DB context |
| E2E/BDD | Web.AcceptanceTests | `Features/*.feature`, `StepDefinitions/` |
| Test setup | TestAppHost | `Program.cs` |

## CONVENTIONS
- **Files**: `[ClassName]Tests.cs` (e.g., `ColourTests.cs`)
- **Methods**: Sentence style starting with `Should`, `Given`, `When` (e.g., `ShouldReturnCorrectColourCode`)
- **Assertions**: Shouldly fluent API (`ShouldBe()`, `ShouldThrow<T>()`)
- **Mocking**: Moq with `[Mock]` attribute and `GetMock<T>()` pattern
- **Setup**: `[OneTimeSetUp]` for fixtures, `[SetUp]` per test
- **BDD**: Feature files in `Features/`, step definitions in `StepDefinitions/`

## ANTI-PATTERNS
- No `Assert` class use; use Shouldly extensions instead
- No `new Mock<T>()` directly; use test base helper methods
- No hardcoded URLs in tests; use `TestApp` factory
- No async void test methods; always return `Task`

## COMMANDS
```bash
# Run all tests
dotnet test

# Run unit tests only
dotnet test --filter "Category=Unit"

# Run acceptance tests
dotnet test tests/Web.AcceptanceTests

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"
```
