# DOMAIN LAYER

## OVERVIEW
Core business entities, value objects, and domain logic with zero external dependencies.

## STRUCTURE
| Directory | Purpose |
|-----------|---------|
| Common/ | Base classes (BaseEntity, ValueObject, BaseEvent) |
| Entities/ | Domain entities (TodoItem, TodoList) |
| ValueObjects/ | Immutable objects (Colour) |
| Events/ | Domain events (TodoItemCompletedEvent) |
| Exceptions/ | Domain-specific exceptions |
| Enums/ | Domain enumerations (PriorityLevel) |
| Constants/ | Static domain constants (Roles) |

## WHERE TO LOOK
| Task | Location |
|------|----------|
| Entity base class | Common/BaseEntity.cs |
| Value object pattern | Common/ValueObject.cs |
| Domain events | Common/BaseEvent.cs, Events/ |
| Example entity | Entities/TodoItem.cs |
| Example value object | ValueObjects/Colour.cs |

## CONVENTIONS
- Entities inherit from BaseEntity or BaseAuditableEntity
- Value objects extend ValueObject and implement GetEqualityComponents()
- Domain events inherit from BaseEvent
- All members are virtual for extensibility and testing
- Collections exposed as IReadOnlyCollection<T>

## ANTI-PATTERNS
- No dependencies on other layers (Application, Infrastructure, Web)
- Repository interfaces belong in Application layer, not Domain
- No database-specific attributes or ORM dependencies
- No business logic in base classes
