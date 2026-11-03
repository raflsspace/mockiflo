# MockiFlo CLI Reference

> Command-line companion for local reverse tunneling and workspace management.

The `mockiflo` binary is a standalone executable built in Rust. It requires zero external dependencies and runs across macOS, Linux, and Windows.

---

## 📦 Global Options

```bash
mockiflo [OPTIONS] <COMMAND>
```

| Flag | Description |
| :--- | :--- |
| `-h, --help` | Print help information and usage instructions. |
| `-V, --version` | Print current CLI version. |

---

## 🛠️ Commands

### `mockiflo login`
Store workspace credentials on the local filesystem.

```bash
mockiflo login <TOKEN> [OPTIONS]
```

- **Arguments**:
  - `<TOKEN>`: Workspace API key or tunnel token generated from the web dashboard.
- **Options**:
  - `--server <URL>`: Override the default MockiFlo server target (default: `https://mockiflo.com`).
- **Configuration Storage**:
  - Credentials are saved to `~/.mockiflo/config.json` (macOS/Linux) or `%USERPROFILE%\.mockiflo\config.json` (Windows).

---

### `mockiflo tunnel`
Establish an outbound reverse tunnel bridging a local port to a cloud workspace subdomain.

```bash
mockiflo tunnel <PORT> --subdomain <SUBDOMAIN> [OPTIONS]
```

- **Arguments**:
  - `<PORT>`: Local target port to forward incoming requests to (e.g., `3000`, `5000`, `8080`).
- **Required Flags**:
  - `-s, --subdomain <NAME>`: Subdomain alias of your workspace.
- **Optional Flags**:
  - `-t, --token <TOKEN>`: Override saved credentials for this session (fallback: `MOCKIFLO_TOKEN` env).
  - `--server <URL>`: Override server base URL for this session (fallback: `MOCKIFLO_SERVER` env).

---

## 🌐 Environment Variables

| Variable | Description |
| :--- | :--- |
| `MOCKIFLO_TOKEN` | Authentication token used when `--token` is omitted. |
| `MOCKIFLO_SERVER` | Target server URL (useful for self-hosted instances). |

---

## 🛑 Exit Codes & Signals

- `0`: Clean exit triggered by user (`Ctrl+C` / SIGINT).
- `1`: Authentication failed (invalid token or unauthorized subdomain).
- `2`: Network connection exhausted after maximum retry attempts.
- `Preempted`: Automatically terminates when a newer session connects to the same subdomain.
