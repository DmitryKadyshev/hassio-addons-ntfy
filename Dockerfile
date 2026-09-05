ARG BUILD_FROM
FROM ${BUILD_FROM} AS build

# Download ntfy binary
ARG NTFY_VERSION=v2.21.0
ARG TARGETARCH
ARG TARGETOS

RUN apk add --no-cache curl && \
    if [ "${TARGETARCH}" = "amd64" ]; then \
        ARCH="amd64"; \
    elif [ "${TARGETARCH}" = "arm64" ]; then \
        ARCH="arm64"; \
    elif [ "${TARGETARCH}" = "arm" ]; then \
        ARCH="armv7"; \
    else \
        ARCH="${TARGETARCH}"; \
    fi && \
    version="ntfy_${NTFY_VERSION#v}_${TARGETOS}_${ARCH}" && \
    download_url="https://github.com/binwiederhier/ntfy/releases/download/${NTFY_VERSION}/$version.tar.gz" && \
    echo "$download_url" && \
    curl --fail --location --retry 3 --retry-delay 2 -o /tmp/ntfy.tar.gz "$download_url" && \
    tar --strip-components=1 -xzf /tmp/ntfy.tar.gz -C /usr/local/bin "$version/ntfy" && \
    chmod +x /usr/local/bin/ntfy && \
    rm /tmp/ntfy.tar.gz

FROM ${BUILD_FROM} AS final

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="ntfy Add-on Community" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="ntfy Add-on Community" \
    org.opencontainers.image.licenses="Apache-2.0" \
    org.opencontainers.image.url="https://ntfy.sh" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}

# Install runtime dependencies
RUN apk add --no-cache tzdata ca-certificates wget

# Copy ntfy binary from build stage
COPY --from=build /usr/local/bin/ntfy /usr/local/bin/ntfy

# Create necessary directories
RUN mkdir -p /var/cache/ntfy /var/lib/ntfy /etc/ntfy

# Copy root filesystem, including the s6-rc service definition
COPY rootfs /
RUN chmod +x /etc/s6-overlay/s6-rc.d/ntfy/run /etc/s6-overlay/s6-rc.d/ntfy/finish

# Expose port
EXPOSE 80/tcp

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:80/health || exit 1
