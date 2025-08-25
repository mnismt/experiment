FROM ghcr.io/coder/coder:latest

# Define build arguments
ARG CODER_ACCESS_URL
ARG CODER_PG_CONNECTION_URL
ARG CODER_DATA=/home/coder/.config/coderv2-docker
ARG CODER_CACHE_DIRECTORY=/home/coder/.config/coderv2-docker/cache
ARG CODER_PG_AUTO_MIGRATE=true
ARG CODER_VERBOSE=true
ARG DOCKER_HOST=unix:///var/run/docker.sock

# Convert build arguments to environment variables
ENV CODER_ACCESS_URL=${CODER_ACCESS_URL}
ENV CODER_PG_CONNECTION_URL=${CODER_PG_CONNECTION_URL}
ENV CODER_DATA=${CODER_DATA}
ENV CODER_CACHE_DIRECTORY=${CODER_CACHE_DIRECTORY}
ENV CODER_PG_AUTO_MIGRATE=${CODER_PG_AUTO_MIGRATE}
ENV CODER_VERBOSE=${CODER_VERBOSE}
ENV DOCKER_HOST=${DOCKER_HOST}

# Set user to root for setup
USER root

# Create necessary directories and set permissions
RUN mkdir -p ${CODER_DATA} && \
    mkdir -p ${CODER_CACHE_DIRECTORY} && \
    chown -R coder:coder /home/coder/.config

# Switch back to coder user
USER coder

# Expose the default Coder port
EXPOSE 7080

# Start Coder server
CMD ["coder", "server"]
