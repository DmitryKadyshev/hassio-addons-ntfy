# ntfy Home Assistant Add-on

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ntfy](https://img.shields.io/badge/ntfy-v2.21.1-green.svg)](https://github.com/binwiederhier/ntfy)

Run a self-hosted [ntfy](https://ntfy.sh/) notification server directly in [Home Assistant](https://www.home-assistant.io/) as an add-on.

## Features

- Self-hosted ntfy server inside Home Assistant
- Web interface
- HTTP PUT/POST notifications
- Android, iOS and desktop clients
- Optional authentication and access control
- Optional file attachments
- Optional Firebase Cloud Messaging integration
- Optional SMTP configuration for email notifications
- ARM64 (`aarch64`) and AMD64 support

## Installation

### Home Assistant Add-on Store

1. Open **Settings → Add-ons → Add-on Store**.
2. Open the three-dot menu in the upper-right corner.
3. Select **Repositories**.
4. Add this repository:

   `https://github.com/DmitryKadyshev/hassio-addons-ntfy`

5. Find **ntfy** and install the add-on.

### Manual installation

Clone the repository into the Home Assistant add-ons directory:

```bash
cd /config/addons
git clone https://github.com/DmitryKadyshev/hassio-addons-ntfy.git
```

Then open the Add-on Store and refresh the add-on list.

## Configuration

The add-on listens on port **8095** by default.

| Option | Default | Description |
| --- | --- | --- |
| `base_url` | `""` | Public URL of the ntfy server, for example `https://ntfy.example.com` |
| `listen_port` | `8095` | HTTP port used by ntfy |
| `cache_duration` | `12h` | How long messages are cached |
| `attachment_enabled` | `false` | Enable file attachments |
| `auth_enabled` | `false` | Enable authentication and access control |
| `auth_default_access` | — | Default access policy when authentication is enabled |
| `timezone` | `UTC` | Server timezone |
| `firebase_key_file` | — | Firebase service-account key file |
| `smtp_sender_addr` | — | SMTP server address |
| `smtp_sender_from` | — | Sender address used for email notifications |
| `smtp_sender_user` | — | SMTP username |
| `smtp_sender_pass` | — | SMTP password |

For a basic installation, the default configuration can be used without changes.

## Accessing ntfy

After installation and startup, open the add-on Web UI or connect to:

```text
http://<HOME_ASSISTANT_IP>:8095
```

Replace `<HOME_ASSISTANT_IP>` with the address of your Home Assistant host.

## Sending notifications

### curl

```bash
curl -d "Hello from Home Assistant" http://<HOME_ASSISTANT_IP>:8095/homeassistant
```

### Home Assistant REST command

Add a command to `configuration.yaml`:

```yaml
rest_command:
  ntfy_notify:
    url: "http://<HOME_ASSISTANT_IP>:8095/homeassistant"
    method: POST
    content_type: "text/plain"
    payload: "{{ message }}"
```

Then call it from an automation or script:

```yaml
action:
  - action: rest_command.ntfy_notify
    data:
      message: "Hello from Home Assistant!"
```

## Mobile clients

Use the official ntfy client on Android or iOS and configure it to connect to your self-hosted server.

- Android: [F-Droid](https://f-droid.org/packages/io.heckel.ntfy/) or [Google Play](https://play.google.com/store/apps/details?id=io.heckel.ntfy)
- iOS: [App Store](https://apps.apple.com/us/app/ntfy/id1619301169)

## Authentication

Authentication is disabled by default. If you expose the server outside your local network, enable authentication and configure an appropriate default access policy.

For production deployments, it is recommended to put ntfy behind HTTPS and configure `base_url` with the public HTTPS URL.

## Documentation

- [ntfy documentation](https://docs.ntfy.sh/)
- [ntfy GitHub repository](https://github.com/binwiederhier/ntfy)
- [Home Assistant add-on documentation](https://www.home-assistant.io/addons/)

## License

This add-on is distributed under the Apache License 2.0. See [LICENSE](ntfy/LICENSE) for details.

The ntfy project itself is licensed under the terms described in its upstream repository.
