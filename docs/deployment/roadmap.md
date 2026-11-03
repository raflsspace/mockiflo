# Roadmap & Deployment

> Architectural vision and upcoming release milestones for MockiFlo.

---

## 🚀 Active Roadmap

### 1. Payload Diff & Text Compare
- Side-by-side visual comparison between expected mock contracts and captured live payloads.
- JSON key diff highlighting missing fields, extra fields, or mismatched types.

### 2. OpenAPI / Swagger Specification Importer
- Upload `openapi.json` or `swagger.yaml` to generate complete workspace mock route collections instantly.
- Automated dynamic schema synthesis based on OpenAPI example objects and property formats.

### 3. Outbound Webhook Replay & Forwarding
- One-click resend for any captured request directly from the console card to another URL.
- Automated webhook delivery retry simulation with configurable backoff intervals.

---

## 🏗️ Architecture Overview

```text
               ┌───────────────────────┐
               │    Inbound Traffic    │
               │ (*.mockiflo.com:443)  │
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │  Edge Routing Gateway │
               │     (Axum / Rust)     │
               └─────┬───────────┬─────┘
                     │           │
     [Dynamic Mock]  │           │  [Tunnel Session]
                     ▼           ▼
         ┌───────────────┐   ┌───────────────────────────┐
         │  Mock Engine  │   │ Tunnel Service Registry   │
         │  (Synthesizer)│   │ (Duplex WebSocket Router) │
         └───────┬───────┘   └─────────────┬─────────────┘
                 │                         │
                 │                         ▼
                 │               ┌───────────────────┐
                 │               │   MockiFlo CLI    │
                 │               │  (Developer PC)   │
                 │               └─────────┬─────────┘
                 │                         │
                 │                         ▼
                 │               ┌───────────────────┐
                 │               │  localhost:<PORT> │
                 │               └───────────────────┘
                 │
                 ▼
         ┌───────────────────────────────────────────────┐
         │             NATS Messaging Plane              │
         │ (KV Cache • Pub/Sub Events • Console SSE Hub) │
         └───────────────────────────────────────────────┘
```

---

## 📦 Deployment Models

- **Managed Cloud**: Zero-configuration multi-tenant cloud workspaces hosted on high-performance edge infrastructure.
- **Self-Hosted (Planned)**: Single-binary and Docker Compose deployments allowing internal enterprise teams to run MockiFlo behind corporate firewalls.
