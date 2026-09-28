# Deployment & Packaging Guide

## Monorepo Projects
- **mobile:** `flutter build apk` / `flutter build appbundle` / `flutter build ipa`
- **tv:** `flutter build apk --target-platform android-arm,android-arm64` (Android TV target)
- **backend:** `npm run build && npm run start`
- **admin:** `npm run build`
