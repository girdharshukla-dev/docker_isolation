FROM ubuntu:26.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    git \
    && rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=24.19.0
RUN curl -fsSL "https://nodejs.org/dist/v24.19.0/node-v24.19.0-linux-x64.tar.xz" \
    | tar -xJ -C /usr/local --strip-components=1

RUN usermod -l my_agent ubuntu && \
    groupmod -n my_agent ubuntu && \
    usermod -d /home/my_agent -m my_agent
    
USER my_agent
    
ENV PNPM_HOME="/home/my_agent/.local/share/pnpm"
ENV PATH="${PNPM_HOME}:${PNPM_HOME}/bin:${PATH}"
ENV SHELL="/bin/bash"
RUN curl -fsSL https://get.pnpm.io/install.sh | sh -
# RUN echo "PATH=$PATH" \
    # && find "$PNPM_HOME" -maxdepth 3


RUN pnpm add -g --allow-build=opencode-ai opencode-ai

ENV CARGO_HOME="/home/my_agent/.cargo"
ENV RUSTUP_HOME="/home/my_agent/.rustup"
ENV PATH="${CARGO_HOME}/bin:${PATH}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

WORKDIR /agent_workspace

CMD ["/bin/bash"]
