# Remote Protocols & Transport Specification

## Overview
The platform supports multiple protocol adapters behind a unified `TvProtocol` interface.

## Transport Types
- `DIRECT_NETWORK`: Native network protocol (e.g. Android TV remote protocol, WebOS REST/WS, Tizen WS).
- `COMPANION_APP`: Custom TV companion app protocol over local encrypted TCP socket / HTTP service (`_smartremote._tcp`).
- `BLUETOOTH`: Bluetooth HID remote emulation.
- `IR_BLASTER`: Consumer IR hardware signaling (ConsumerIrManager on Android).

## Hikers TV Policy
Per strict engineering rules:
- Hikers direct protocol is unverified initially (`DIRECT_PROTOCOL_UNKNOWN`).
- `HikersAdapter` performs active capability probing.
- When unverified, the system seamlessly falls back to `CompanionProtocol` requiring the TV companion app.
