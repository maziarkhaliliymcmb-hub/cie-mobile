# 36OS Mobile Node — PWA

Static, installable cross-platform web app shell for iOS Safari and Android Chrome.

## Local preview
Serve this directory over HTTPS (or localhost for development). Open `index.html`.

## Install
- iOS: open the HTTPS URL in Safari → Share → Add to Home Screen.
- Android: open the HTTPS URL in Chrome → Install app / Add to Home screen.

## Deploy
Deploy the `pwa/` directory as the static output/root directory of a separate Vercel project, or configure an existing static host to serve this folder. Do not overwrite the native iOS project or its existing release workflows.

## Security and current boundary
- The CIE token is held in tab-scoped `sessionStorage`, not persistent local storage.
- Use a restricted user token only. Never embed Supabase service-role keys, internal CIE-to-36OS credentials, or secrets in this client.
- Connection testing calls `GET /v1/agents/identity` then `GET /v1/36os/knowledge/health`. The CIE API must permit the PWA origin via a narrowly configured CORS policy.
- No API data is cached by the service worker; only the static app shell is cached.
- Worker dispatch, node registration/heartbeat, local inference, native hardware telemetry and background compute are not implemented in this PWA shell.
- Browser background execution and hardware access are platform-limited. Use native platform adapters for capabilities that require them.
