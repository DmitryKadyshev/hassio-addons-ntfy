# ntfy Add-on for Home Assistant

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ntfy](https://img.shields.io/badge/ntfy-v2.21.0-green.svg)](https://github.com/binwiederhier/ntfy)

Send push notifications to your phone or desktop using PUT/POST from Home Assistant.

## About

This add-on allows you to self-host [ntfy](https://ntfy.sh/) server in your Home Assistant environment. 
ntfy is a simple HTTP-based pub-sub notification service that allows you to send notifications to your phone or desktop.

## Features

- Self-hosted push notification server
- No account required
- Works with Android, iOS, and Desktop apps
- CLI support
- Web interface included
- Supports attachments
- Email notifications
- Firebase Cloud Messaging support (optional)

## Installation

### Option 1: Add repository to Home Assistant

1. Open Home Assistant Supervisor
2. Go to **Supervisor** → **Add-on Store**
3. Click on the three dots menu (⋮) in the top right corner
4. Select **Repositories**
5. Add this URL: `https://github.com/DmitryKadyshev/hassio-addons-ntfy`
6. Click **Add**

### Option 2: Manual installation

1. Clone this repository into your Home Assistant addons folder:
   ```bash
   cd /config/addons
   git clone https://github.com/DmitryKadyshev/hassio-addons-ntfy.git
   ```
2. Go to **Supervisor** → **Add-on Store** → Three dots menu → **Check for updates**
3. Find "ntfy" in the list and install it

## Configuration

After installation, configure the following options:

| Option | Default | Description |
|--------|---------|-------------|
| `base_url` | `""` | Public facing base URL of the service (e.g., `https://ntfy.example.com`) |
| `listen_port` | `80` | HTTP listen port |
| `cache_duration` | `12h` | Duration for which messages are cached |
| `attachment_enabled` | `false` | Enable file attachments |
| `auth_enabled` | `false` | Enable authentication and access control |
| `timezone` | `UTC` | Timezone for the server |

### Example Configuration

```yaml
base_url: ""
listen_port: 80
cache_duration: "12h"
attachment_enabled: false
auth_enabled: false
timezone: "UTC"
```

### Advanced Configuration (with authentication)

```yaml
base_url: "https://ntfy.example.com"
listen_port: 80
cache_duration: "12h"
attachment_enabled: true
auth_enabled: true
auth_default_access: "deny-all"
timezone: "Europe/Moscow"
```

## Usage

### Sending notifications

Once installed, you can send notifications using various methods:

#### Using curl
```bash
curl -d "Your notification message" http://localhost:80/yourtopic
```

#### Using Home Assistant REST Command

Add to your `configuration.yaml`:
```yaml
rest_command:
  ntfy_notify:
    url: "http://localhost:80/homeassistant"
    method: POST
    content_type: "text/plain"
    payload: "{{ message }}"
```

Then call the service:
```yaml
service: rest_command.ntfy_notify
data:
  message: "Hello from Home Assistant!"
```

#### Using the Web Interface

Open `http://YOUR_HOME_ASSISTANT_IP:80` in your browser to access the ntfy web interface.

### Mobile Apps

- **Android**: [Download from F-Droid](https://f-droid.org/packages/io.heckel.ntfy/) or [Google Play](https://play.google.com/store/apps/details?id=io.heckel.ntfy)
- **iOS**: [Download from App Store](https://apps.apple.com/us/app/ntfy/id1619301169)

Subscribe to your topics (e.g., `homeassistant`, `alerts`, etc.) in the mobile app using your server URL.

## Support

- [ntfy Documentation](https://docs.ntfy.sh/)
- [ntfy GitHub Repository](https://github.com/binwiederhier/ntfy)
- [Home Assistant Community](https://community.home-assistant.io/)

## License

This add-on is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

The ntfy project is dual-licensed under Apache 2.0 and GPL 2.0.
