FROM alire/gnat:ubuntu-lts

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalamos dependencias (añadiendo GTK3 y pkg-config)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gnat \
    asis-programs \
    curl \
    unzip \
    ca-certificates \
    pkg-config \
    libgtk-3-dev && \
    rm -rf /var/lib/apt/lists/*

# 2. Instalar Alire 2.1.0
RUN curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip && \
    unzip /tmp/alr.zip -d /tmp/alr_extracted && \
    mv /tmp/alr_extracted/bin/alr /usr/bin/alr && \
    chmod +x /usr/bin/alr && \
    rm -rf /tmp/alr.zip /tmp/alr_extracted

# 3. Configuración de herramientas del sistema
RUN alr --non-interactive toolchain --select gnat_native && \
    alr --non-interactive toolchain --select gprbuild

WORKDIR /workspace