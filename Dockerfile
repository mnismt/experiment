FROM ghcr.io/coder/coder:latest

# Define build arguments with defaults
ARG CODER_ACCESS_URL=""
ARG CODER_PG_CONNECTION_URL=""
ARG CODER_DATA="/home/coder/.config/coderv2-docker"
ARG CODER_CACHE_DIRECTORY="/home/coder/.config/coderv2-docker/cache"
ARG CODER_PG_AUTO_MIGRATE="true"
ARG CODER_VERBOSE="true"
ARG DOCKER_HOST="unix:///var/run/docker.sock"
ARG CODER_PROVISIONER_DAEMONS="1"

# Convert all build arguments to environment variables
ENV CODER_ACCESS_URL=${CODER_ACCESS_URL} \
    CODER_PG_CONNECTION_URL=${CODER_PG_CONNECTION_URL} \
    CODER_DATA=${CODER_DATA} \
    CODER_CACHE_DIRECTORY=${CODER_CACHE_DIRECTORY} \
    CODER_PG_AUTO_MIGRATE=${CODER_PG_AUTO_MIGRATE} \
    CODER_VERBOSE=${CODER_VERBOSE} \
    DOCKER_HOST=${DOCKER_HOST} \
    CODER_PROVISIONER_DAEMONS=${CODER_PROVISIONER_DAEMONS}

# Setup as root
USER root

# Create directories and set permissions
RUN mkdir -p "${CODER_DATA}" "${CODER_CACHE_DIRECTORY}" && \
    chown -R coder:coder /home/coder/.config

# Switch to coder user
USER coder

# Expose port
EXPOSE 7080

# Start Coder server directly
CMD ["coder", "server"]
