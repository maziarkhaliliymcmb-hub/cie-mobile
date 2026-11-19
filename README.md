# CIE Mobile

Flutter-based Android control-panel prototype for the Collective Intelligence Engine.

## Current scope

- Persian RTL dashboard shell.
- Navigation sections for overview, agents, tasks, and activity reports.
- Explicit offline/unconfigured state: the CIE Core API is not connected yet.
- GitHub Actions workflow that generates Android platform files, analyzes and tests the Flutter project, builds a release APK, and uploads it as a workflow artifact.

## Build

The workflow runs on pushes to `main` and `setup/**`, pull requests, and manual dispatch.

The Android Gradle project is generated in the CI runner with:

```bash
flutter create --platforms=android --org com.collectiveintelligence --project-name cie_mobile --no-pub .
```

Then CI runs:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

The APK is published as the `cie-mobile-debuggable-release-apk` workflow artifact for 14 days. It is not yet signed for Play Store distribution.

## Next integration step

Configure a secure CIE Core API endpoint and authentication flow. Do not commit API tokens, private keys, or production credentials to this repository. Use GitHub Actions secrets for CI-only credentials when required.
