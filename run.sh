#!/usr/bin/env bash
set -euo pipefail

# Usage: ./run.sh /<path to project>
#
# What this deliberately does NOT do (on purpose, matching our threat model):
#   - no -v /var/run/docker.sock  (would allow container escape via host docker daemon)
#   - no --privileged
#   - no ~/.ssh or ~/.aws mount
#   - no git credentials
#   - only ONE bind mount: your project dir -> /agent_workspace
#
# Result: cd .. inside the container hits the container's own /, not your host.
# Sibling directories on your host simply do not exist from in here.

IMAGE_NAME="agent_sandbox"
PROJECT_DIR="${1:?Usage: ./run.sh /<path to project>}"

# Resolve to an absolute path so docker -v behaves predictably
PROJECT_DIR="$(cd "$PROJECT_DIR" && pwd)"

docker build -t "$IMAGE_NAME" "$(dirname "$0")"

docker run -it --rm \
    --name agent_sandbox_run \
    -v "${PROJECT_DIR}:/agent_workspace" \
    --workdir /agent_workspace \
    --network none \
    --cap-drop ALL \
    --security-opt no-new-privileges \
    "$IMAGE_NAME"
