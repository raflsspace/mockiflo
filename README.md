# MockiFlo

> **Intercept & Mock HTTP Traffic Instantly**

A lightweight testing utility to inspect live HTTP traffic, debug webhooks, and synthesize realistic mock responses without configuration friction.

---

## ⚡ Quick Installation (CLI Companion)

Install the standalone MockiFlo CLI companion tool directly via your terminal:

### macOS & Linux
```bash
curl -fsSL https://raw.githubusercontent.com/raflsspace/mockiflo/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/raflsspace/mockiflo/main/install.ps1 | iex
```

> **Manual Downloads:** Standalone pre-compiled binaries are also available directly on [GitHub Releases](https://github.com/raflsspace/mockiflo/releases/latest).

---

## 🚀 Quickstart

### 1. Authenticate CLI
Get your workspace token from the MockiFlo Web Console, then run:
```bash
mockiflo login <YOUR_WORKSPACE_TOKEN>
```
*Credentials are stored locally in `~/.mockiflo/config.json`.*

### 2. Start Reverse Tunnel
Expose your local development port to your MockiFlo subdomain:
```bash
mockiflo tunnel 5000 -s <subdomain>
```
All inbound requests to `https://<subdomain>.mockiflo.com` will be forwarded directly to `http://127.0.0.1:5000` over a duplex WebSocket connection.

---

## ⚡ Core Capabilities

MockiFlo bridges cloud workspace mocking with local environment debugging through six core pillars:

- **[Live Traffic Telemetry](docs/capabilities/live-console.md)**  
  Inbound requests appear immediately on your console via Server-Sent Events (SSE), complete with headers, query parameters, latency markers, and foldable JSON/XML payload inspection.

- **[Dynamic Response Synthesizer](docs/capabilities/mock-engine.md)**  
  Simulate realistic payloads dynamically with UUIDs, timestamps, randomized values, and context variables extracted directly from incoming requests.

- **Latency & Timeout Verification**  
  Inject precise millisecond or second delays to evaluate slow dependencies, edge timeouts, and client cancellation behaviors during integration testing.

- **Isolated Workspaces**  
  Quick ephemeral environments clean up automatically after testing, while persistent workspaces keep mock rules active across multi-member teams.

- **[Local Reverse Tunneling (CLI)](docs/capabilities/tunnel/README.md)**  
  Bridge any local service port directly to your cloud subdomain via duplex WebSockets. Receive live webhooks and test frontend calls without port-forwarding or exposing public IPs.

- **Selective Route Interception**  
  Override specific API paths with cloud mock responses while forwarding the rest to your local backend. Seamlessly test unreleased microservices without mocking your entire stack.

---

## 🛠️ Built-in Tools

- **MockiFlo CLI (`mockiflo`)**  
  Native companion CLI providing persistent authentication (`mockiflo login`) and instant reverse tunneling (`mockiflo tunnel <PORT>`).
- **Dynamic Response Playground**  
  Interactive template synthesizer to test mock schemas, variables, and generative payloads before saving rules.
- **Payload Formatter**  
  Instant JSON & XML beautifier and payload validator.

---

## 🔮 Next in Development

Features actively being developed for upcoming releases:

- [ ] **Side-by-side text compare and payload diff tool**
- [ ] **OpenAPI / Swagger specification import for instant rule generation**
- [ ] **Outbound webhook replay and request forwarding**

For detailed architectural notes and release milestones, see [Roadmap & Deployment](docs/deployment/roadmap.md).

---

## 📚 Documentation Index

Explore detailed guides and reference material:

- **Tunneling & CLI**: [Reverse Tunnel Guide](docs/capabilities/tunnel/README.md) • [CLI Reference](docs/tools/cli-reference.md)
- **Mocking**: [Mock Engine & Dynamic Rules](docs/capabilities/mock-engine.md)
- **Monitoring**: [Live Traffic Console](docs/capabilities/live-console.md)
- **Project Roadmap**: [Development Milestones](docs/deployment/roadmap.md)
