FROM ubuntu:22.04

# Build arguments
ARG CODER_ACCESS_URL=""
ARG CODER_PG_CONNECTION_URL=""
ARG CODER_VERSION="latest"

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    systemctl \
    && rm -rf /var/lib/apt/lists/*

# Install Docker (for Docker-in-Docker if needed)
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create coder user
RUN useradd -m -s /bin/bash coder \
    && usermod -aG docker coder \
    && echo 'coder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Coder
RUN curl -fsSL https://coder.com/install.sh | sh

# Set environment variables
ENV CODER_ACCESS_URL=${CODER_ACCESS_URL} \
    CODER_PG_CONNECTION_URL=${CODER_PG_CONNECTION_URL} \
    CODER_DATA=/home/coder/.config/coder \
    CODER_CACHE_DIRECTORY=/home/coder/.config/coder/cache \
    CODER_PG_AUTO_MIGRATE=true \
    CODER_VERBOSE=true

# Create startup script
COPY startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Create directories
RUN mkdir -p /home/coder/.config/coder /home/coder/.config/coder/cache \
    && chown -R coder:coder /home/coder

# Expose ports
EXPOSE 7080

# Use startup script
ENTRYPOINT ["/usr/local/bin/startup.sh"]
