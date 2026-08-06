FROM ubuntu:26.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN usermod -l my_agent ubuntu && \
    groupmod -n my_agent ubuntu && \
    usermod -d /home/my_agent -m my_agent

USER my_agent

CMD ["/bin/bash"]
