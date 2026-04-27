FROM alire/gnat:ubuntu-lts

ENV DEBIAN_FRONTEND=noninteractive

# 1. Instalamos dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gnat \
    asis-programs \
    curl \
    unzip \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. Descargar y extraer correctamente
# Extraemos en /tmp, movemos el binario a /usr/bin y limpiamos
RUN curl -fSL https://github.com/alire-project/alire/releases/download/v2.1.0/alr-2.1.0-bin-x86_64-linux.zip -o /tmp/alr.zip && \
    unzip /tmp/alr.zip -d /tmp/alr_extracted && \
    mv /tmp/alr_extracted/bin/alr /usr/bin/alr && \
    chmod +x /usr/bin/alr && \
    rm -rf /tmp/alr.zip /tmp/alr_extracted

WORKDIR /workspace