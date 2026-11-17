# glance-railway

Wrapper image for [Glance](https://github.com/glanceapp/glance) (v0.8.8) on [Railway](https://railway.com).

Upstream's image ships no login: a deployed Glance dashboard is readable by anyone who finds the domain. The wrapper writes a
default config that puts the whole dashboard behind a login (`admin` and the `ADMIN_PASSWORD` variable), keeps a session secret
on the volume so logins survive a redeploy, listens on Railway's injected `PORT`, and trusts Railway's proxy headers.

- Variables: `ADMIN_PASSWORD` (required; the container refuses to start without it), optional `GLANCE_CONFIG` (a full Glance YAML config that replaces the file at every boot)
- Volume: `/app/config` (`glance.yml` and `.session-secret`)
- Health: `GET /api/healthz`
- Default config: `default-glance.yml`, written to the volume on first boot only. Edit `/app/config/glance.yml` afterwards, or set `GLANCE_CONFIG`.

Published as `ghcr.io/bon5co/glance-railway`. Template: see the Railway marketplace listing.
