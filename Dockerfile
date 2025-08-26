FROM ubuntu:22.04
# Install SSH server and other tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    curl \
    wget \
    nano \
    htop \
    && rm -rf /var/lib/apt/lists/*

# Keep container running
CMD ["tail", "-f", "/dev/null"]
