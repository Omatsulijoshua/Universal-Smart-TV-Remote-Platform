# Testing Strategy

## Test Harness & Strategy
- **Shared Definitions:** Evaluated via unit tests (`shared/dart`, `@smart-tv-remote/shared`).
- **Protocol Adapters:** Unit tests verify hierarchy resolution, capability flags, and fallback behavior (e.g. `HikersAdapter` returning unknown status).
- **Static Analysis:** Strict Dart analysis (`dart analyze`) and TypeScript compilation (`tsc`) across all packages.
