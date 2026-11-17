# Glance wrapper for Railway. The boot script keeps the dashboard config and the session secret on the volume, writes a default
# config that is behind a login whose password is the generated ADMIN_PASSWORD, and listens on Railway's injected PORT.
# upstream: glanceapp/glance
FROM glanceapp/glance:v0.8.8@sha256:4d7445bc7971836858ffddee5d7501f1efbabb6e694a45b1dde1a789bb1943bb

COPY default-glance.yml /app/default-glance.yml
COPY boot.sh /usr/local/bin/railway-boot.sh
RUN chmod +x /usr/local/bin/railway-boot.sh

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-boot.sh"]
