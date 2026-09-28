# Pairing & Authentication Specification

## Pairing Process

```text
Phone                           TV
┌──────┐                     ┌──────┐
│Search│ ───── mDNS ───────> │Listen│
└──────┘                     └──────┘
   │                            │
   │                         Generate 6-digit Code (e.g. 482 719)
   │                         Display on TV Screen & QR
   │                            │
Enter Code ─────────────────> Verify Code
   │                            │
   │ <───── Session Key ─────── │
   │                            │
Encrypted Session Established
```

## Security Requirements
- 6-digit short-lived pairing codes (expires in 2 minutes).
- Session tokens stored securely in Flutter Secure Storage / Keychain / Keystore.
- Rate-limiting on incorrect pairing attempts.
