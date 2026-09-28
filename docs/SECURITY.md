# Security Specification

## Principles
1. **Privacy-First Local Execution:** Remote control commands, text input, and voice intents are processed locally and never transmitted to external cloud servers.
2. **Encrypted Storage:** Session tokens and credentials are stored exclusively in Android Keystore / iOS Keychain via secure storage.
3. **Replay Protection:** Commands carry timestamps and sequence numbers to prevent replay attacks on the local network.
4. **Pairing Expiration:** Temporary pairing codes expire after 2 minutes. Rate limiting prevents brute force pairing.
