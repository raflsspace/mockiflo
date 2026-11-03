# Local Reverse Tunneling

> Expose local development servers to your MockiFlo cloud workspace via duplex WebSockets.

MockiFlo Reverse Tunnel bridges your local machine (localhost:port) with your dedicated cloud subdomain. It enables you to receive live third-party webhooks (Stripe, GitHub, Shopify), test frontend-to-backend integrations, and share work-in-progress APIs without opening firewall ports, configuring router NAT, or exposing public IP addresses.

---

## ⚡ How It Works

1. **Multiplexed WebSocket Stream**: The mockiflo CLI establishes an outbound WebSocket connection to the MockiFlo edge gateway over HTTPS/WSS (Port 443).
2. **Selective Forwarding**: Inbound HTTP requests hitting your workspace subdomain are forwarded down the active WebSocket connection to your local machine.
3. **Local Loopback Dispatch**: The CLI forwards the request to your local service (http://127.0.0.1:PORT), captures the exact response, and sends it back up to the caller.
4. **Resilient Session Preemption**: Built-in connection takeover ensures that laptop sleep cycles or Wi-Fi network switches immediately preempt stale sessions without 409 Conflict errors or reconnection loops.
5. **Full Binary & Text Parity**: Transparently supports JSON, raw streams, Base64-encoded binary files (images, PDFs), and multipart payloads.

---

## 📦 Download & Installation

Pre-compiled standalone binaries are available on the [MockiFlo Releases](https://github.com/raflsspace/mockiflo/releases/latest) page.

| Platform | Architecture | Binary Archive |
| :--- | :--- | :--- |
| **macOS** | Apple Silicon | `mockiflo-darwin-arm64.tar.gz` |
| **macOS** | Intel (x86_64) | `mockiflo-darwin-x86_64.tar.gz` |
| **Linux** | x86_64 / amd64 | `mockiflo-linux-x86_64.tar.gz` |
| **Linux** | ARM64 / aarch64 | `mockiflo-linux-arm64.tar.gz` |
| **Windows** | x86_64 | `mockiflo-windows-x86_64.zip` |

---

### macOS Installation

1. Download the archive for your architecture:
```bash
# For Apple Silicon
curl -LO https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-darwin-arm64.tar.gz

# For Intel
curl -LO https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-darwin-x86_64.tar.gz
```

2. Extract and remove the macOS Gatekeeper quarantine attribute:
```bash
tar -xzf mockiflo-darwin-*.tar.gz
xattr -d com.apple.quarantine mockiflo
```

3. Make it executable and place it in your system PATH:
```bash
chmod +x mockiflo
sudo mv mockiflo /usr/local/bin/
```

4. Verify installation:
```bash
mockiflo --version
```

---

### Linux Installation

1. Download the archive for your architecture:
```bash
# For x86_64 / amd64
curl -LO https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-linux-x86_64.tar.gz

# For ARM64 / aarch64
curl -LO https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-linux-arm64.tar.gz
```

2. Extract and install to your PATH:
```bash
tar -xzf mockiflo-linux-*.tar.gz
chmod +x mockiflo
sudo mv mockiflo /usr/local/bin/
```

3. Verify installation:
```bash
mockiflo --version
```

---

### Windows Installation

Open **PowerShell** and execute the following commands:

1. Download and extract the archive:
```powershell
Invoke-WebRequest -Uri "https://github.com/raflsspace/mockiflo/releases/latest/download/mockiflo-windows-x86_64.zip" -OutFile "mockiflo.zip"
Expand-Archive -Path "mockiflo.zip" -DestinationPath "$HOME\bin" -Force
Remove-Item "mockiflo.zip"
```

2. Add the destination directory to your User PATH:
```powershell
setx PATH "$env:Path;$HOME\bin"
```

3. Verify installation:
```powershell
mockiflo --version
```

*(Alternatively, extract mockiflo.exe manually and move it into C:\Windows\System32 or any directory currently registered in your system PATH).*

---

## 🚀 Quickstart

### Method 1: Two-Step Setup (Recommended)

Save your workspace credentials once to ~/.mockiflo/config.json:

```bash
mockiflo login YOUR_WORKSPACE_TOKEN
```

Start forwarding inbound subdomain traffic to your local server (e.g., port 5000):

```bash
mockiflo tunnel 5000 --subdomain YOUR_SUBDOMAIN
```

### Method 2: Single Command (CI/CD or Ephemeral Shells)

Pass the token directly via CLI flag without persisting to disk:

```bash
mockiflo tunnel 5000 --subdomain YOUR_SUBDOMAIN --token YOUR_WORKSPACE_TOKEN
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
mockiflo tunnel 5000 --subdomain YOUR_SUBDOMAIN
```

| Parameter | Shorthand | Status | Description |
| :--- | :--- | :--- | :--- |
| `PORT` | — | Required | Local port to forward traffic to (e.g., 3000, 8080). |
| `--subdomain` | `-s` | Required | Workspace subdomain alias to bind to. |
| `--token` | `-t` | Optional | Workspace API token or tunnel key (overrides saved config). |
| `--server` | — | Optional | Base URL of the MockiFlo server (default: https://mockiflo.com). |

### Environment Variables

For headless environments and Docker containers, you can configure the CLI using environment variables:

```bash
export MOCKIFLO_TOKEN="your_workspace_token"
export MOCKIFLO_SERVER="https://mockiflo.com"

# Run directly without auth flags
mockiflo tunnel 5000 --subdomain my-api
```

---

## 🔍 Connection Lifecycle & Preemption

- **Heartbeat & Keepalive**: The client and server exchange WebSocket ping/pong frames every 15 seconds. If connectivity drops without a clean TCP teardown, timeout triggers at 45 seconds.
- **Session Preemption**: If a newer tunnel connects with the same subdomain and a valid token, the older connection is terminated with a clean preemption code (`Session preempted by newer connection`). The previous CLI exits immediately without entering reconnection loops.
- **Automatic Reconnect**: If the server drops connection due to server deployment or temporary network glitches, the CLI reconnects automatically using exponential backoff with full millisecond jitter (up to 7 attempts).
