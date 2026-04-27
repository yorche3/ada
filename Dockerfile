FROM alire/gnat:ubuntu-lts

# Instalamos gnat y las herramientas de ASIS (donde reside gnatcheck)
RUN apt-get update && \
    apt-get install -y gnat asis-programs && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace