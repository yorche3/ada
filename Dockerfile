FROM alire/gnat:ubuntu-lts

# Asegura que gnat check esté disponible
RUN apt-get update && \
    apt-get install -y gnat && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace