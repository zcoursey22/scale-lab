#!/usr/bin/env bash
# Usage: ./deploy.sh <image-tag>
# Runs on the server. Pulls the image, checks it on a spare port, swaps it in
# on port 80, and restores the previous version if the swap fails.
set -euo pipefail

IMAGE=zcoursey22/scale-lab-api
TAG=${1:?usage: deploy.sh <image-tag>}
NAME=scale-lab-api
CANDIDATE=$NAME-candidate
CANDIDATE_PORT=3001
LIVE_PORT=80

# Poll /healthz on a port for up to ~30s (a new container needs a moment to boot).
healthy() {
  for _ in $(seq 1 15); do
    curl -fs "localhost:$1/healthz" >/dev/null && return 0
    sleep 2
  done
  return 1
}

docker pull "$IMAGE:$TAG"

# Remember what is running now so we can go back to it.
PREVIOUS=$(docker inspect --format '{{.Config.Image}}' "$NAME" 2>/dev/null || true)

# Start the new version on a spare port. The old one keeps serving on 80.
docker rm -f "$CANDIDATE" >/dev/null 2>&1 || true
docker run -d --name "$CANDIDATE" -p "$CANDIDATE_PORT:3000" "$IMAGE:$TAG" >/dev/null

if ! healthy "$CANDIDATE_PORT"; then
  echo "New version failed its health check. Still running: ${PREVIOUS:-nothing}" >&2
  docker logs "$CANDIDATE" >&2 || true
  docker rm -f "$CANDIDATE" >/dev/null
  exit 1
fi

# Swap: remove the test container and the old one, start the new one on 80.
docker rm -f "$CANDIDATE" >/dev/null
docker rm -f "$NAME" >/dev/null 2>&1 || true
docker run -d --name "$NAME" --restart unless-stopped -p "$LIVE_PORT:3000" "$IMAGE:$TAG" >/dev/null

if ! healthy "$LIVE_PORT"; then
  echo "New version failed on port $LIVE_PORT. Rolling back to ${PREVIOUS:-nothing}" >&2
  docker rm -f "$NAME" >/dev/null
  if [ -n "$PREVIOUS" ]; then
    docker run -d --name "$NAME" --restart unless-stopped -p "$LIVE_PORT:3000" "$PREVIOUS" >/dev/null
  fi
  exit 1
fi

echo "Deployed $IMAGE:$TAG"
