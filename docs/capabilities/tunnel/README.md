# Local Reverse Tunneling

> Expose local development servers to your MockiFlo cloud workspace via duplex WebSockets.

MockiFlo Reverse Tunnel bridges your local machine (`localhost:<port>`) with your dedicated cloud subdomain. It enables you to receive live third-party webhooks (Stripe, GitHub, Shopify), test frontend-to-backend integrations, and share work-in-progress APIs without opening firewall ports, configuring router NAT, or exposing public IP addresses.

---

## ⚡ How It Works

1. **Multiplexed WebSocket Stream**: The `mockiflo` CLI establishes an outbound WebSocket connection to the MockiFlo edge gateway over HTTPS/WSS (Port 443).
2. **Selective Forwarding**: Inbound HTTP requests hitting your workspace subdomain are forwarded down the active WebSocket connection to your local machine.
3. **Local Loopback Dispatch**: The CLI forwards the request to your local service (`http://127.0.0.1:PORT`), captures the exact response, and sends it back up to the caller.
4. **Resilient Session Preemption**: Built-in connection takeover ensures that laptop sleep cycles or Wi-Fi network switches immediately preempt stale sessions without 409 Conflict errors or reconnection loops.
5. **Full Binary & Text Parity**: Transparently supports JSON, raw streams, Base64-encoded binary files (images, PDFs), and multipart payloads.

---

## 📦 Quick Installation (Recommended)

Install the standalone MockiFlo CLI companion tool directly via your terminal:

### macOS & Linux
```bash
curl -fsSL https://raw.githubusercontent.com/raflsspace/mockiflo/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/raflsspace/mockiflo/main/install.ps1 | iex
```

---

## 💾 Manual Installation

If you prefer to download standalone binaries directly without running the installer script, download them from the [MockiFlo Releases](https://github.com/raflsspace/mockiflo/releases/latest) page.

| Platform | Architecture | Binary Asset |
| :--- | :--- | :--- |
| **macOS** | Apple Silicon (M1/M2/M3/M4) | `mockiflo-macos-arm64` |
| **macOS** | Intel (x86_64) | `mockiflo-macos-intel` |
| **Linux** | x86_64 / amd64 | `mockiflo-linux-amd64` |
| **Windows** | x86_64 / amd64 | `mockiflo-windows-amd64.exe` |

### Manual Setup: macOS

1. Download the binary matching your CPU:
```bash
# Apple Silicon
curl -LO https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-macos-arm64

# Intel
curl -LO https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-macos-intel
```

2. Make executable and move to system bin:
```bash
chmod +x mockiflo-macos-*
sudo mv mockiflo-macos-* /usr/local/bin/mockiflo
```

3. Remove quarantine attribute if blocked by macOS Gatekeeper:
```bash
sudo xattr -d com.apple.quarantine /usr/local/bin/mockiflo
```

### Manual Setup: Linux

```bash
curl -LO https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-linux-amd64
chmod +x mockiflo-linux-amd64
sudo mv mockiflo-linux-amd64 /usr/local/bin/mockiflo
```

### Manual Setup: Windows

1. Download `mockiflo-windows-amd64.exe` from Releases.
2. Rename it to `mockiflo.exe`.
3. Move it to a folder in your PATH (e.g. `%LOCALAPPDATA%\mockiflo\bin`).

---

## 🚀 Quickstart

### Method 1: Two-Step Setup (Recommended)

Save your workspace credentials once to `~/.mockiflo/config.json`:

```bash
mockiflo login YOUR_WORKSPACE_TOKEN
```

Start forwarding inbound subdomain traffic to your local server (e.g., port 5000):

```bash
mockiflo tunnel 5000 -s YOUR_SUBDOMAIN
```

### Method 2: Single Command (CI/CD or Ephemeral Shells)

Pass the token directly via CLI flag without persisting to disk:

```bash
mockiflo tunnel 5000 -s YOUR_SUBDOMAIN -t YOUR_WORKSPACE_TOKEN
```

---

## ⚙️ Configuration & Flags

### CLI Commands & Arguments

```bash
# General help
mockiflo --help

# Save auth token
mockiflo login YOUR_TOKEN

# Save auth token with custom server target
mockiflo login YOUR_TOKEN --server https://mockiflo.com

# Open reverse tunnel
mockiflo tunnel 5000 -s YOUR_SUBDOMAIN
```

| Parameter | Shorthand | Status | Description |
| :--- | :--- | :--- | :--- |
| `PORT` | — | Required | Local port to forward traffic to (e.g., 3000, 5000, 8080). |
| `--subdomain` | `-s` | Required | Workspace subdomain alias to bind to. |
| `--token` | `-t` | Optional | Workspace API token or tunnel key (overrides saved config). |
| `--server` | — | Optional | Base URL of the MockiFlo server (default: `https://mockiflo.com`). |

### Environment Variables

For headless environments and Docker containers, you can configure the CLI using environment variables:

```bash
export MOCKIFLO_TOKEN="your_workspace_token"
export MOCKIFLO_SERVER="https://mockiflo.com"

# Run directly without auth flags
mockiflo tunnel 5000 -s my-api
```

---

## 🔍 Connection Lifecycle & Preemption

- **Heartbeat & Keepalive**: The client and server exchange WebSocket ping/pong frames every 15 seconds. If connectivity drops without a clean TCP teardown, timeout triggers at 45 seconds.
- **Session Preemption**: If a newer tunnel connects with the same subdomain and a valid token, the older connection is terminated with a clean preemption code (`Session preempted by newer connection`). The previous CLI exits immediately without entering reconnection loops.
- **Automatic Reconnect**: If the server drops connection due to server deployment or temporary network glitches, the CLI reconnects automatically using exponential backoff with full millisecond jitter (up to 7 attempts).
