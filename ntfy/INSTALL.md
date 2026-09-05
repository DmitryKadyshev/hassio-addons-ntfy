# Инструкция по установке ntfy Add-on для Home Assistant

## Структура репозитория

```
hassio-addon-ntfy/
├── README.md           # Документация
├── config.yaml         # Конфигурация аддона для Home Assistant
├── Dockerfile          # Dockerfile для сборки образа
├── build.yaml          # Параметры сборки для разных архитектур
├── repository.yaml     # Информация о репозитории
├── CHANGELOG.md        # История изменений
├── LICENSE             # Лицензия
├── .gitignore          # Игнорируемые файлы Git
└── rootfs/
    └── usr/
        └── bin/
            └── entrypoint.sh  # Скрипт запуска и конфигурации
```

## Подготовка к публикации

1. **Замените плейсхолдеры в файлах:**

   В `config.yaml`:
   - Замените `{username}` на ваш GitHub username

   В `build.yaml`:
   - Замените `YOUR_USERNAME` на ваш GitHub username

   В `repository.yaml`:
   - Замените `YOUR_USERNAME` на ваш GitHub username
   - Замените `your-email@example.com` на ваш email

2. **Создайте GitHub репозиторий:**
   ```bash
   cd /workspace
   git init
   git add .
   git commit -m "Initial commit: ntfy Home Assistant addon"
   git remote add origin https://github.com/DmitryKadyshev/ntfy-hassio-addon.git
   git push -u origin main
   ```

3. **Настройте GitHub Actions для авто-сборки (опционально):**
   
   Создайте файл `.github/workflows/build.yml` для автоматической сборки образов при релизах.

## Установка в Home Assistant

### Способ 1: Добавление репозитория

1. Откройте Home Assistant
2. Перейдите в **Настройки** → **Дополнения** → **Магазин дополнений**
3. Нажмите на три точки (⋮) в правом верхнем углу
4. Выберите **Репозитории**
5. Добавьте URL вашего репозитория: `https://github.com/DmitryKadyshev/ntfy-hassio-addon`
6. Нажмите **Добавить**
7. Найдите "ntfy" в списке и установите его

### Способ 2: Локальная установка (для разработки)

1. Скопируйте папку с аддоном в директорию addons Home Assistant:
   ```bash
   cp -r /workspace /config/addons/ntfy
   ```

2. В Home Assistant перейдите в **Настройки** → **Дополнения**
3. Нажмите на три точки (⋮) → **Проверить обновления**
4. Найдите "ntfy" в списке локальных аддонов и установите

## Конфигурация

После установки настройте аддон через веб-интерфейс Home Assistant:

### Базовая конфигурация

```yaml
base_url: ""              # Оставьте пустым для локального использования
listen_port: 80           # Порт HTTP сервера
cache_duration: "12h"     # Время хранения сообщений в кэше
attachment_enabled: false # Включить поддержку вложений
auth_enabled: false       # Включить аутентификацию
timezone: "UTC"           # Часовой пояс
```

### Расширенная конфигурация (с аутентификацией)

```yaml
base_url: "https://ntfy.example.com"
listen_port: 80
cache_duration: "12h"
attachment_enabled: true
auth_enabled: true
auth_default_access: "deny-all"
timezone: "Europe/Moscow"
```

### Конфигурация с Email уведомлениями

```yaml
smtp_sender_addr: "smtp.example.com:587"
smtp_sender_from: "ntfy@example.com"
smtp_sender_user: "username"
smtp_sender_pass: "password"
```

## Использование

### Отправка уведомлений через curl

```bash
curl -d "Сообщение из Home Assistant" http://localhost:80/homeassistant
```

### Интеграция с Home Assistant

Добавьте в `configuration.yaml`:

```yaml
rest_command:
  ntfy_notify:
    url: "http://localhost:80/homeassistant"
    method: POST
    content_type: "text/plain"
    payload: "{{ message }}"
    
  ntfy_notify_priority:
    url: "http://localhost:80/homeassistant"
    method: POST
    headers:
      Title: "{{ title }}"
      Priority: "{{ priority }}"
    content_type: "text/plain"
    payload: "{{ message }}"
```

Используйте в автоматизациях:

```yaml
automation:
  - alias: "Отправить уведомление при открытии двери"
    trigger:
      platform: state
      entity_id: binary_sensor.front_door
      to: "on"
    action:
      service: rest_command.ntfy_notify
      data:
        message: "Внимание! Открыта входная дверь!"
```

### Мобильные приложения

1. **Android**: Установите приложение из [F-Droid](https://f-droid.org/packages/io.heckel.ntfy/) или [Google Play](https://play.google.com/store/apps/details?id=io.heckel.ntfy)
2. **iOS**: Установите из [App Store](https://apps.apple.com/us/app/ntfy/id1619301169)

В приложении:
1. Добавьте новый сервер с адресом `http://ВАШ_IP_HOME_ASSISTANT:80`
2. Подпишитесь на нужные топики (например, `homeassistant`, `alerts`)

## Мониторинг и логи

- Логи аддона доступны в интерфейсе Home Assistant
- Health check endpoint: `http://localhost:80/health`
- Статистика: `http://localhost:80/metrics`

## Решение проблем

### Аддон не запускается

1. Проверьте логи в интерфейсе Home Assistant
2. Убедитесь, что порт 80 не занят другим сервисом
3. Проверьте права доступа к директориям

### Не приходят уведомления

1. Проверьте, что мобильное приложение подключено к правильному серверу
2. Убедитесь, что топик существует и подписчик активен
3. Проверьте настройки фаервола

## Обновление

При выходе новой версии ntfy:

1. Обновите `NTFY_VERSION` в `Dockerfile`
2. Обновите `version` в `config.yaml`
3. Обновите `CHANGELOG.md`
4. Создайте новый релиз в GitHub

## Поддержка

- [Документация ntfy](https://docs.ntfy.sh/)
- [GitHub ntfy](https://github.com/binwiederhier/ntfy)
- [Форум Home Assistant](https://community.home-assistant.io/)
