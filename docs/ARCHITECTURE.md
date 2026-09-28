# Architecture Overview

## Monorepo Layout
```text
smart-tv-remote/
├── mobile/            # Flutter Mobile Application (Android / iOS)
├── tv/                # Flutter/Android TV Companion Application
├── backend/           # NestJS REST & Real-time Metadata API
├── admin/             # Admin Management Dashboard
├── shared/            # Shared Protocol Definitions & Models
│   ├── ts/            # TypeScript package (@smart-tv-remote/shared)
│   └── dart/          # Dart package (shared)
└── docs/              # Comprehensive Technical Documentation
```

## Transport & Capability Hierarchy
```text
1. Existing supported TV network protocol
                 ↓
2. TV companion application
                 ↓
3. Bluetooth/HID where supported
                 ↓
4. IR blaster where the phone has IR hardware
                 ↓
5. Unsupported-device explanation
```

## Mobile Application Architecture
```text
Flutter UI
    ↓
Remote Controller
    ↓
Device Manager
    ↓
Connection Manager
    ↓
Transport Adapter
    ↓
Protocol Adapter (CompanionProtocol, HikersAdapter, AndroidTvProtocol, etc.)
    ↓
Target Smart TV
```
