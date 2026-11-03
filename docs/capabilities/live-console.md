# Live Traffic Telemetry

> Real-time request inspection and debugging console powered by Server-Sent Events (SSE) and NATS pub/sub.

The Live Traffic Console provides instantaneous visibility into every HTTP request hitting your workspace subdomain. There is no need to manually refresh or poll the server—events are streamed directly to your active browser tab with millisecond latency tracking.

---

## ⚡ Core Features

- **Instant Event Streaming**: Inbound traffic events are published across the internal NATS bus and broadcasted to connected browser consoles over Server-Sent Events (SSE).
- **Comprehensive Request Inspection**: Expand any captured traffic card to inspect:
  - Exact HTTP method, path, and full URL.
  - Complete request & response headers.
  - Query parameters parsed into readable key-value pairs.
  - Request and response body with automated formatting (JSON & XML syntax highlighting).
- **Latency & Status Tracking**: Live timing measurements (`latency_ms`) show execution duration, helping spot slow dependencies and unexpected timeouts.
- **Quick cURL Replay**: Generate an exact `curl` command with one click to reproduce any captured request from your local terminal.
- **Tunnel Indicator**: Telemetry cards automatically badge whether a response was synthesized by cloud mock rules or forwarded live from a local reverse tunnel.

---

## 🔄 Lifecycle of a Traffic Event

```text
[ Client Request ]
       │
       ▼
[ MockiFlo Gateway ] ──► (Process Route / Evaluate Mock Rule / Forward Tunnel)
       │
       ├──► [ Internal NATS Bus ] ──► [ SSE Stream Handler ]
       │                                     │
       ▼                                     ▼
[ HTTP Client Response ]           [ Live Browser Console UI ]
```

---

## 🛡️ Telemetry & Large Payload Safeguards

To prevent memory leaks and maintain browser responsiveness during high-throughput testing:
- **Binary Payloads**: Raw binary files (images, PDFs, archives) are truncated in telemetry and marked with size indicators (e.g., `[Binary Data: 512 KB]`) while serving the full content to the caller.
- **In-Memory Retention**: Ephemeral workspaces keep a circular buffer of recent events in memory, automatically dropping the oldest entries to prevent tab freezing.
