FROM ubuntu:26.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash my_agent
USER my_agent

WORKDIR /agent_workspace

CMD ["/bin/bash"]
