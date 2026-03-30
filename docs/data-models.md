# Data Models Documentation

## Domain Entities

### TodoList (Aggregate Root)

```csharp
public class TodoList : BaseAuditableEntity
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public Colour? Colour { get; set; }
    public IList<TodoItem> Items { get; private set; } = new List<TodoItem>();
}
```

**Properties**:
| Property | Type | Constraints | Description |
|----------|------|-------------|-------------|
| Id | int | PK, Identity | Unique identifier |
| Title | string | Required, max 100 chars | List title |
| Colour | Colour? | Optional | Display color |
| Items | IList<TodoItem> | 1:many | Child items |
| CreatedBy | string | Required | Creator ID |
| CreatedOn | DateTimeOffset | Required | Creation timestamp |
| LastModifiedBy | string? | Optional | Last modifier ID |
| LastModifiedOn | DateTimeOffset? | Optional | Last modification |

### TodoItem (Entity)

```csharp
public class TodoItem : BaseAuditableEntity
{
    public int Id { get; set; }
    public int ListId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Note { get; set; }
    public PriorityLevel Priority { get; set; }
    public DateTime? Reminder { get; set; }
    public bool Done { get; set; }
    public DateTime? DoneDate { get; set; }
    public TodoList List { get; set; } = null!;
}
```

**Properties**:
| Property | Type | Constraints | Description |
|----------|------|-------------|-------------|
| Id | int | PK, Identity | Unique identifier |
| ListId | int | FK, Required | Parent list ID |
| Title | string | Required, max 100 chars | Item title |
| Note | string? | Optional | Additional notes |
| Priority | PriorityLevel | Required, default: None | Priority level |
| Reminder | DateTime? | Optional | Reminder timestamp |
| Done | bool | Required, default: false | Completion status |
| DoneDate | DateTime? | Optional | Completion timestamp |
| CreatedBy | string | Required | Creator ID |
| CreatedOn | DateTimeOffset | Required | Creation timestamp |
| LastModifiedBy | string? | Optional | Last modifier ID |
| LastModifiedOn | DateTimeOffset? | Optional | Last modification |

## Value Objects

### Colour

```csharp
public sealed class Colour : ValueObject
{
    public string Code { get; }
    
    public static Colour From(string code);
    public static Colour White { get; }
    public static Colour Red { get; }
    public static Colour Orange { get; }
    public static Colour Yellow { get; }
    public static Colour Green { get; }
    public static Colour Blue { get; }
    public static Colour Purple { get; }
    public static Colour Magenta { get; }
    public static Colour Teal { get; }
}
```

**Valid Colors**: White, Red, Orange, Yellow, Green, Blue, Purple, Magenta, Teal

### PriorityLevel (Enum)

```csharp
public enum PriorityLevel
{
    None = 0,
    Low = 1,
    Medium = 2,
    High = 3
}
```

## Base Classes

### BaseEntity

```csharp
public abstract class BaseEntity
{
    public int Id { get; set; }
}
```

### BaseAuditableEntity

```csharp
public abstract class BaseAuditableEntity : BaseEntity
{
    public string CreatedBy { get; set; } = string.Empty;
    public DateTimeOffset CreatedOn { get; set; }
    public string? LastModifiedBy { get; set; }
    public DateTimeOffset? LastModifiedOn { get; set; }
}
```

### BaseEvent

```csharp
public abstract class BaseEvent
{
    public DateTimeOffset OccurredOn { get; }
    public string EventType { get; }
}
```

## Domain Events

### TodoItemCompletedEvent

Dispatched when a todo item is marked as complete.

## Identity Models

### ApplicationUser

```csharp
public class ApplicationUser : IdentityUser
{
    // Inherits from IdentityUser:
    // - Id
    // - UserName
    // - Email
    // - EmailConfirmed
    // - PhoneNumber
    // - etc.
}
```

## DTOs

### TodoListDto

```csharp
public class TodoListDto
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? ColourCode { get; set; }
    public List<TodoItemDto> Items { get; set; } = new();
    public int ItemCount { get; set; }
    public int CompletedItemCount { get; set; }
}
```

### TodoItemDto

```csharp
public class TodoItemDto
{
    public int Id { get; set; }
    public int ListId { get; set; }
    public string Title { get; set; } = string.Empty;
    public string? Note { get; set; }
    public PriorityLevel Priority { get; set; }
    public DateTime? Reminder { get; set; }
    public bool Done { get; set; }
    public DateTime? DoneDate { get; set; }
}
```

### TodosVm

```csharp
public class TodosVm
{
    public List<TodoListDto> Lists { get; set; } = new();
    public bool IsAuthorized { get; set; }
}
```

### LookupDto

```csharp
public class LookupDto
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
}
```

## Database Configuration

### Entity Relationships

```
TodoList (1) ─────< (N) TodoItem
```

- **One-to-Many**: TodoList has many TodoItems
- **Cascade Delete**: Deleting TodoList deletes all TodoItems

### Indexes

| Entity | Index | Columns |
|--------|-------|---------|
| TodoItem | IX_TodoItems_ListId | ListId |
| TodoItem | IX_TodoItems_Done | Done |

## Audit Fields

All auditable entities automatically track:

| Field | Type | Description |
|-------|------|-------------|
| CreatedBy | string | User ID who created |
| CreatedOn | DateTimeOffset | Creation timestamp |
| LastModifiedBy | string? | User ID who last modified |
| LastModifiedOn | DateTimeOffset? | Last modification timestamp |

Managed via `AuditableEntityInterceptor`.

## Domain Events

Events are dispatched via `DispatchDomainEventsInterceptor`:

1. Entity modifies
2. Events collected in `DomainEvents` property
3. Events dispatched after `SaveChanges`
4. Handlers execute with valid database state

## Database Provider

Default: SQLite
Configurable: PostgreSQL, SQL Server

Connection string in `appsettings.json`.
