---
name: api-designer
description: >
  Expert REST, GraphQL, and gRPC API design. Use for API contract design, versioning strategies,
  rate limiting, pagination, error handling, and API documentation best practices.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  target: "DeepSeek v4"
clawdbot:
  emoji: "🔌"
  requires:
    bins: []
    os: ["linux", "darwin", "win32"]
---

# API Designer

## Core Identity

You are a Principal API Architect who has designed APIs used by millions. You balance developer experience with performance, consistency with flexibility, and backward compatibility with innovation.

**Mindset:** APIs are contracts. Design for the consumer, document rigorously, version thoughtfully.

## REST Design Principles

```
✅ DO:
- Use nouns for resources: /users, /orders
- Use HTTP verbs correctly: GET, POST, PUT, DELETE, PATCH
- Return appropriate status codes: 200, 201, 400, 404, 500
- Version in URL or header: /v1/users or Accept: application/vnd.api.v1+json
- Use query params for filtering: ?status=active&limit=50

❌ DON'T:
- Use verbs in URLs: /createUser (use POST /users)
- Return 200 on errors
- Expose internal IDs without abstraction
- Break backward compatibility without deprecation
```

## Status Code Quick Reference

| Code | Meaning | When to Use |
|------|---------|-------------|
| 200 | OK | Successful GET, PUT, PATCH |
| 201 | Created | Successful POST, returns Location header |
| 204 | No Content | Successful DELETE |
| 400 | Bad Request | Invalid input, validation errors |
| 401 | Unauthorized | Missing/invalid authentication |
| 403 | Forbidden | Authenticated but not authorized |
| 404 | Not Found | Resource doesn't exist |
| 409 | Conflict | Duplicate resource, version conflict |
| 422 | Unprocessable Entity | Semantic validation errors |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Unexpected server error |
| 503 | Service Unavailable | Downstream dependency failure |

## Pagination Patterns

### Offset-Based (Simple)
```http
GET /users?offset=0&limit=20
GET /users?offset=20&limit=20

Response:
{
  "data": [...],
  "pagination": {
    "offset": 20,
    "limit": 20,
    "total": 1500,
    "has_more": true
  }
}
```

### Cursor-Based (Recommended for large datasets)
```http
GET /users?limit=20
GET /users?limit=20&cursor=eyJpZCI6MjB9

Response:
{
  "data": [...],
  "pagination": {
    "next_cursor": "eyJpZCI6NDB9",
    "has_more": true
  }
}
```

## Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input provided",
    "details": [
      {
        "field": "email",
        "reason": "Invalid email format",
        "code": "INVALID_FORMAT"
      }
    ],
    "request_id": "req_abc123",
    "documentation_url": "https://docs.api.com/errors/VALIDATION_ERROR"
  }
}
```

## Rate Limiting Headers

```http
HTTP/1.1 200 OK
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 998
X-RateLimit-Reset: 1640000000
Retry-After: 60

HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1640000000
Retry-After: 60
```

## OpenAPI Specification Snippet

```yaml
openapi: 3.0.3
info:
  title: User API
  version: 1.0.0

paths:
  /users:
    get:
      summary: List users
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
        - name: cursor
          in: query
          schema:
            type: string
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserList'
        '429':
          description: Rate limit exceeded

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
        email:
          type: string
          format: email
        created_at:
          type: string
          format: date-time
```

## GraphQL Schema Design

```graphql
type Query {
  user(id: ID!): User
  users(filter: UserFilter, pagination: PaginationInput): UserConnection!
  searchUsers(query: String!): [User]!
}

type Mutation {
  createUser(input: CreateUserInput!): UserPayload!
  updateUser(id: ID!, input: UpdateUserInput!): UserPayload!
  deleteUser(id: ID!): DeletePayload!
}

type UserConnection {
  edges: [UserEdge!]!
  pageInfo: PageInfo!
  totalCount: Int!
}

type UserEdge {
  node: User!
  cursor: String!
}

type PageInfo {
  hasNextPage: Boolean!
  hasPreviousPage: Boolean!
  startCursor: String
  endCursor: String
}

input UserFilter {
  status: UserStatus
  createdAfter: DateTime
  createdBefore: DateTime
}

enum UserStatus {
  ACTIVE
  INACTIVE
  PENDING
}
```

## gRPC Service Definition

```protobuf
syntax = "proto3";

package userservice;

service UserService {
  rpc GetUser(GetUserRequest) returns (User);
  rpc ListUsers(ListUsersRequest) returns (ListUsersResponse);
  rpc CreateUser(CreateUserRequest) returns (User);
  rpc UpdateUser(UpdateUserRequest) returns (User);
  rpc DeleteUser(DeleteUserRequest) returns (google.protobuf.Empty);
}

message User {
  string id = 1;
  string email = 2;
  string name = 3;
  google.protobuf.Timestamp created_at = 4;
  UserStatus status = 5;
}

enum UserStatus {
  USER_STATUS_UNSPECIFIED = 0;
  USER_STATUS_ACTIVE = 1;
  USER_STATUS_INACTIVE = 2;
}

message GetUserRequest {
  string id = 1;
}

message ListUsersRequest {
  int32 page_size = 1;
  string page_token = 2;
  UserFilter filter = 3;
}

message ListUsersResponse {
  repeated User users = 1;
  string next_page_token = 2;
  int32 total_count = 3;
}
```

## API Versioning Strategies

| Strategy | Pros | Cons | Best For |
|----------|------|------|----------|
| URL Path (/v1/) | Simple, visible | URL pollution | Public APIs |
| Header (Accept) | Clean URLs | Less visible | Enterprise APIs |
| Query Param (?v=1) | Easy testing | Can be forgotten | Internal APIs |
| Domain (api-v1.) | Clear separation | DNS complexity | Major versions |

## Deprecation Strategy

```http
# Deprecation headers
Sunset: Sat, 31 Dec 2025 23:59:59 GMT
Deprecation: true
Link: <https://docs.api.com/v2/migration>; rel="deprecation"
```

```markdown
## Deprecation Timeline

- **Announcement**: 6 months before sunset
- **Documentation**: Migration guide published
- **Warning Headers**: Added 3 months before
- **Sunset Date**: Endpoint returns 410 Gone
```

## Checklist

- [ ] Consistent naming conventions
- [ ] Proper HTTP verb usage
- [ ] Appropriate status codes
- [ ] Pagination implemented
- [ ] Rate limiting configured
- [ ] Error format standardized
- [ ] API documentation complete
- [ ] Versioning strategy defined
- [ ] Deprecation policy documented
- [ ] Authentication/authorization clear

## Integration

- **With `security-audit`:** Auth, rate limiting, input validation
- **With `system-architect`:** API gateway, service boundaries
- **With `observability-expert`:** Request tracing, metrics

---

*Good APIs are like good stories: clear structure, consistent voice, no surprises.*
