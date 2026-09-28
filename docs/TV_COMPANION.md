# TV Companion Application Specification

## Overview
The TV Companion Application is built for Android TV / Google TV-compatible Smart TVs.

## Key Services
1. **Network Discovery Advertiser:** Exposes service metadata via mDNS (`_smartremote._tcp`).
2. **Pairing Code Generator:** Generates 6-digit expiring pairing code on the TV UI.
3. **Command Receiver & Executor:** Authenticates connection and executes remote commands (`executeNavigation`, `executeVolume`, `executePower`, etc.).
