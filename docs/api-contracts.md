# API Contracts

## Overview

The API is built using **Minimal APIs** with MediatR for CQRS. All endpoints are documented via OpenAPI/Scalar.

**Base URL**: `https://localhost:{port}/`

## Authentication

All endpoints (except weather) require **JWT Bearer Authentication**.

### Security Scheme

```
Authorization: Bearer {token}
```

## Endpoints

### 1. Todo Lists

#### GET /api/todolists

Get all todo lists for the current user.

**Authorization**: Required

**Response**: `200 OK`

```json
{
  "lists": [
    {
      "id": 1,
      "title": "My List",
      "colourCode": "#FF0000",
      "items": [...],
      "itemCount": 5,
      "completedItemCount": 2
    }
  ],
  "isAuthorized": true
}
```

#### POST /api/todolists

Create a new todo list.

**Authorization**: Required

**Request Body**:

```json
{
  "title": "New List",
  "colourCode": "#00FF00"
}
```

**Response**: `201 Created`

```json
{
  "id": 2,
  "title": "New List",
  "colourCode": "#00FF00"
}
```

#### PUT /api/todolists/{id}

Update an existing todo list.

**Authorization**: Required

**Request Body**:

```json
{
  "title": "Updated Title",
  "colourCode": "#0000FF"
}
```

**Response**: `204 No Content`

#### DELETE /api/todolists/{id}

Delete a todo list.

**Authorization**: Required

**Response**: `204 No Content`

---

### 2. Todo Items

#### GET /api/todolists/{listId}/items

Get all items in a todo list.

**Authorization**: Required

**Response**: `200 OK`

```json
[
  {
    "id": 1,
    "listId": 1,
    "title": "Task 1",
    "note": "Some notes",
    "priority": 2,
    "reminder": "2024-01-01T09:00:00Z",
    "done": false,
    "doneDate": null
  }
]
```

#### POST /api/todolists/{listId}/items

Create a new todo item.

**Authorization**: Required

**Request Body**:

```json
{
  "title": "New Task",
  "note": "Task notes",
  "priority": 1,
  "reminder": "2024-01-01T09:00:00Z"
}
```

**Response**: `201 Created`

```json
{
  "id": 2,
  "listId": 1,
  "title": "New Task",
  "note": "Task notes",
  "priority": 1,
  "reminder": "2024-01-01T09:00:00Z",
  "done": false,
  "doneDate": null
}
```

#### PUT /api/todoitems/{id}

Update a todo item.

**Authorization**: Required

**Request Body**:

```json
{
  "title": "Updated Task",
  "note": "Updated notes",
  "priority": 3,
  "reminder": "2024-01-02T09:00:00Z",
  "done": true
}
```

**Response**: `204 No Content`

#### PUT /api/todoitems/{id}/detail

Update todo item detail (including list assignment).

**Authorization**: Required

**Request Body**:

```json
{
  "title": "Updated Task",
  "note": "Updated notes",
  "priority": 3,
  "reminder": "2024-01-02T09:00:00Z",
  "done": true,
  "listId": 1
}
```

**Response**: `204 No Content`

#### DELETE /api/todoitems/{id}

Delete a todo item.

**Authorization**: Required

**Response**: `204 No Content`

---

### 3. Weather Forecasts (Sample)

#### GET /api/weatherforecasts

Get weather forecast sample data.

**Authorization**: Not required (public)

**Response**: `200 OK`

```json
[
  {
    "date": "2024-01-01",
    "temperatureC": 20,
    "temperatureF": 68,
    "summary": "Sunny"
  }
]
```

---

### 4. Users

#### GET /api/users

Get all users (requires admin/appropriate role).

**Authorization**: Required

**Response**: `200 OK`

```json
[
  {
    "id": "user-id-1",
    "userName": "user@example.com",
    "email": "user@example.com"
  }
]
```

---

## Request/Response Models

### CreateTodoListCommand

```csharp
public record CreateTodoListCommand(
    string Title,
    string? ColourCode
);
```

### UpdateTodoListCommand

```csharp
public record UpdateTodoListCommand(
    int Id,
    string Title,
    string? ColourCode
);
```

### CreateTodoItemCommand

```csharp
public record CreateTodoItemCommand(
    int ListId,
    string Title,
    string? Note,
    PriorityLevel Priority,
    DateTime? Reminder
);
```

### UpdateTodoItemCommand

```csharp
public record UpdateTodoItemCommand(
    int Id,
    string Title,
    string? Note,
    PriorityLevel Priority,
    DateTime? Reminder,
    bool Done
);
```

### UpdateTodoItemDetailCommand

```csharp
public record UpdateTodoItemDetailCommand(
    int Id,
    int ListId,
    string Title,
    string? Note,
    PriorityLevel Priority,
    DateTime? Reminder,
    bool Done
);
```

### GetTodosQuery

```csharp
public record GetTodosQuery : IRequest<TodosVm>;
```

---

## Error Responses

### 400 Bad Request

Validation errors.

```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.1",
  "title": "One or more validation errors occurred",
  "status": 400,
  "errors": {
    "Title": ["The Title field is required."]
  }
}
```

### 401 Unauthorized

Authentication required.

```json
{
  "type": "https://tools.ietf.org/html/rfc7235#section-3.1",
  "title": "Unauthorized",
  "status": 401,
  "detail": "Authentication required"
}
```

### 403 Forbidden

Authorization failed.

```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.3",
  "title": "Forbidden",
  "status": 403,
  "detail": "You do not have permission to perform this action"
}
```

### 404 Not Found

Resource not found.

```json
{
  "type": "https://tools.ietf.org/html/rfc7231#section-6.5.4",
  "title": "Not Found",
  "status": 404,
  "detail": "Resource not found"
}
```

---

## API Documentation

Interactive API documentation available at:

- **Scalar**: `/scalar/v1`

---

## MediatR Integration

All endpoints use MediatR for CQRS:

```
Endpoint → MediatR Send() → Handler → Repository → Database
```

### Pipeline Behaviors

1. **ValidationBehaviour** - Validates requests
2. **AuthorizationBehaviour** - Checks permissions
3. **PerformanceBehaviour** - Logs slow requests
4. **LoggingBehaviour** - Logs all requests
5. **UnhandledExceptionBehaviour** - Handles exceptions
