FROM alire/gnat:ubuntu-lts

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalamos dependencias incluyendo librerías de desarrollo de C
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl unzip ca-certificates pkg-config build-essential \
    gnat asis-programs \
    libssl-dev zlib1g-dev libgtk-3-dev \
    libc6-dev make && \
    rm -rf /var/lib/apt/lists/*

# 2. Instalar Alire 2.1.0
RUN curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip && \
    unzip /tmp/alr.zip -d /tmp/alr_extracted && \
    mv /tmp/alr_extracted/bin/alr /usr/bin/alr && \
    chmod +x /usr/bin/alr && \
    rm -rf /tmp/alr.zip /tmp/alr_extracted

# 3. VARIABLES DE ENTORNO CRUCIALES
# Esto permite que las toolchains descargadas por Alire vean las libs del sistema
ENV C_INCLUDE_PATH=/usr/include:/usr/include/x86_64-linux-gnu
ENV LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu
ENV LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:/lib/x86_64-linux-gnu

WORKDIR /workspace