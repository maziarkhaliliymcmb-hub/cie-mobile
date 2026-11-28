const CACHE = "36os-mobile-node-shell-v2";
const ASSETS = [
  "./",
  "./index.html",
  "./styles.css",
  "./app.js",
  "./manifest.webmanifest",
  "./icons/icon.svg"
];
const STATIC_ASSETS = new Set(
  ASSETS.map((path) => new URL(path, self.registration.scope).href)
);

self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll([...STATIC_ASSETS]))
  );
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((key) => key !== CACHE).map((key) => caches.delete(key))
      )
    )
  );
});

self.addEventListener("fetch", (event) => {
  const request = event.request;
  // Only the explicit static shell allowlist is cacheable. API and other
  // same-origin GET requests are deliberately left to the network.
  if (request.method !== "GET" || !STATIC_ASSETS.has(request.url)) return;

  event.respondWith(
    caches.open(CACHE).then((cache) =>
      cache.match(request).then(
        (cached) =>
          cached ||
          fetch(request)
            .then((response) => {
              if (!response.ok) return response;
              return cache.put(request, response.clone()).then(() => response);
            })
            .catch(() =>
              cache.match(new URL("./index.html", self.registration.scope).href)
            )
      )
    )
  );
});
