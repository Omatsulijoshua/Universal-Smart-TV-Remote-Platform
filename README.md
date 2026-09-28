<<<<<<< HEAD
# Universal-Smart-TV-Remote-Platform
a production-quality universal Smart TV remote-control platform
=======
# Universal Smart TV Remote Platform

A production-quality universal Smart TV remote-control platform supporting Android, iOS, Android TV / Google TV, protocol abstraction, local pairing, and admin management.

## Monorepo Project Structure

```text
smart-tv-remote/
├── mobile/            # Flutter Mobile Application (Android / iOS)
├── tv/                # Flutter/Android TV Companion Application
├── backend/           # NestJS API Backend (PostgreSQL database models)
├── admin/             # Admin Dashboard for Brand & Protocol Management
├── shared/            # Protocol definitions & command models (TS & Dart)
├── docs/              # Architecture, Protocol, Pairing, Security & Compatibility Docs
└── README.md
```

## Transport & Capability Hierarchy
```text
1. Existing supported TV network protocol
                 ↓
2. TV companion application
                 ↓
3. Bluetooth/HID where supported
                 ↓
4. IR blaster where phone has IR hardware
                 ↓
5. Unsupported-device explanation
```

## First Supported TV: Hikers TV
In accordance with platform design principles, Hikers direct network protocol is initially probed for capability verification (`HikersAdapter`). When unverified (`DIRECT_PROTOCOL_UNKNOWN`), the platform gracefully falls back to the TV Companion application (`CompanionProtocol`).

## Development Status
- **Phase 1 (Architecture & Skeleton):** COMPLETE
- **Phase 2 (Mobile UI):** READY
>>>>>>> 77c0349 (feat: Phase 1 monorepo architecture and project skeleton)
