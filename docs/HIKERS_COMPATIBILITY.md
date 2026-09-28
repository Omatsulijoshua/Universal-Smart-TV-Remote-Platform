# Hikers TV Compatibility Report & Testing Strategy

## Target Device Status
- **Target Manufacturer:** Hikers
- **Status:** TESTING / EXPERIMENTAL
- **Direct Network Protocol:** UNVERIFIED (`DIRECT_PROTOCOL_UNKNOWN`)
- **Companion App Support:** Supported (Target platform: Android TV / Google TV compatible)

## Fallback Strategy
1. Mobile app detects Hikers TV on local Wi-Fi.
2. Probe direct network protocol endpoints.
3. Fallback to `CompanionProtocol` when direct API is unverified.
4. Prompt user to launch or install TV companion app.
