# ☁️ Cloudflare DNS Switcher

A high-availability failover utility for Cloudflare DNS, designed to switch between redundant IPs quickly and safely.

---

## ✨ Features

- **🚀 Smart Failover**: Ping-based `auto` mode that detects which server is online.
- **🛡 Protected Records**: Hardcoded safeguards to prevent accidental changes to critical infrastructure.
- **🕵️‍♂️ Surgical Updates**: Only targets `A` records matching a specific source IP.
- **🔐 Secure Credentials**: Stores tokens in `cloudflare_keys` (ignored by git).
- **🎨 Interactive Setup**: Automatically opens the Cloudflare API dashboard and helps you save your first token.

---

## 🚀 Quick Start

1. **Permissions**: Make the script executable:
   ```bash
   chmod +x switch-ip.sh
   ```

2. **Run**: Switch between two public IPs:
   ```bash
   ./switch-ip.sh yourdomain.com 1.2.3.4 5.6.7.8
   ```

---

## 📖 Usage

```bash
./switch-ip.sh <domain> <source_ip> <target_ip> [mode]
```

### Modes

| Mode | Description |
| :--- | :--- |
| **`manual`** | (Default) Forcefully replaces all records with `source_ip` to `target_ip`. |
| **`auto`** | Pings both IPs and only switches if the target is online and source is offline. |

---

## 🔒 Configuration & Security

The script stores tokens in a local file named `cloudflare_keys`.
- **Format**: `domain:api_token`
- **Recommended**: Use a Cloudflare API token with **Zone:DNS:Edit** permissions for specific zones.
- **Git Safety**: This file is automatically ignored by `.gitignore` to prevent secret leaks.

---

## 🛡 Protected Infrastructure

The script will automatically skip any records named:
- `matolaspar-s`, `matolaspar-p`
- `millenniump-s`, `millenniump-p`
- And their subdomains.

---

## 🛠 Prerequisites

- `curl` for API communication.
- `jq` for parsing Cloudflare's responses.
- macOS (recommended for auto-browser opening) or any standard Unix/Linux shell.
