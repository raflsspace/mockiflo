# Dynamic Response Synthesizer

> Create dynamic, context-aware mock endpoints with rule-based matching, template expressions, and latency simulation.

The Mock Engine allows teams to simulate complete backend services before APIs are built, or replace unstable third-party dependencies during integration tests.

---

## ⚡ Key Capabilities

### 1. Selective Route Interception
You do not need to mock an entire backend at once. Define mock rules for specific endpoints (e.g., `POST /v1/checkout`), while allowing all other paths to pass through directly to your local service via reverse tunnel.

### 2. Dynamic Variables & Generators
Synthesize realistic responses instead of static strings. The engine supports inline template helpers:
- `{{uuid}}` - Generates a standard UUID v4.
- `{{timestamp}}` - Generates current ISO-8601 or UNIX epoch timestamps.
- `{{random.number(100, 999)}}` - Generates numbers within a range.
- `{{req.header.X-Request-Id}}` - Echoes incoming request headers back into the response.
- `{{req.query.user_id}}` - Injects query parameter values directly into payload fields.

### 3. Latency & Fault Injection
Evaluate client timeout handling and resilience by simulating imperfect network conditions:
- **Fixed Delay**: Add a deterministic delay (e.g., 500ms, 2500ms) to any rule.
- **Error Status Simulation**: Return custom HTTP error codes (`400`, `401`, `429 Too Many Requests`, `500 Internal Server Error`) with corresponding problem details payloads.

---

## 📋 Rule Matching Precedence

When an inbound request hits a workspace:
1. **Exact Path & Method Match**: Rules with strict path and HTTP method equality take highest precedence.
2. **Wildcard / Prefix Match**: Rules defined with wildcards (e.g., `/api/v1/users/*`) evaluate next.
3. **Fallback to Tunnel / Default 404**: If no mock rule matches and an active CLI tunnel is connected, the request is dispatched to your local machine. If no tunnel is active, the workspace returns standard default mock responses.
