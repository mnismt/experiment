FROM ubuntu:22.04

# Basic packages only
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    wget \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Keep container running
CMD ["tail", "-f", "/dev/null"]
