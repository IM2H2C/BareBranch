#!/bin/ash
# Quiet Paper Installation Script + Bare Branch startup.sh fetch + auto-start
# Server files live in /mnt/server
set -euo pipefail

PROJECT=paper

# ── helper: silent curl (shows errors only) ───────────────────────────────
curlq() { curl -sSL --fail --show-error "$@"; }

# ── resolve Paper download URL ────────────────────────────────────────────
if [ -n "${DL_PATH:-}" ]; then
    DOWNLOAD_URL="$(eval echo "$(echo "${DL_PATH}" | sed -e 's/{{/${/g' -e 's/}}/}/g')")"
else
    API="https://api.papermc.io/v2/projects/${PROJECT}"
    VERSIONS_JSON="$(curlq "${API}")"
    LATEST_VERSION="$(echo "${VERSIONS_JSON}" | jq -r '.versions[-1]')"

    if ! echo "${VERSIONS_JSON}" | jq -e --arg v "${MINECRAFT_VERSION}" '.versions[] | select(. == $v)' >/dev/null; then
        MINECRAFT_VERSION="${LATEST_VERSION}"
    fi

    BUILDS_JSON="$(curlq "${API}/versions/${MINECRAFT_VERSION}")"
    LATEST_BUILD="$(echo "${BUILDS_JSON}" | jq -r '.builds[-1]')"

    if ! echo "${BUILDS_JSON}" | jq -e --arg b "${BUILD_NUMBER}" '.builds[] | select(.|tostring == $b)' >/dev/null; then
        BUILD_NUMBER="${LATEST_BUILD}"
    fi

    JAR_NAME="${PROJECT}-${MINECRAFT_VERSION}-${BUILD_NUMBER}.jar"
    DOWNLOAD_URL="${API}/versions/${MINECRAFT_VERSION}/builds/${BUILD_NUMBER}/downloads/${JAR_NAME}"
fi

cd /mnt/server

# ── Paper jar download ────────────────────────────────────────────────────
[ -f "${SERVER_JARFILE}" ] && mv "${SERVER_JARFILE}" "${SERVER_JARFILE}.old"
echo "Downloading Paper ${MINECRAFT_VERSION}-${BUILD_NUMBER} …"
curlq -o "${SERVER_JARFILE}" "${DOWNLOAD_URL}"

# ── server.properties (only if absent) ────────────────────────────────────
[ -f server.properties ] || curlq -o server.properties \
    https://raw.githubusercontent.com/parkervcp/eggs/master/minecraft/java/server.properties

# ── Bare Branch startup.sh (read + exec only) ─────────────────────────────
echo "Fetching Bare Branch startup.sh …"
curlq -o startup.sh https://raw.githubusercontent.com/IM2H2C/BareBranch/main/startup.sh
chmod 555 startup.sh

echo "Install complete. Launching server …"
exec ./startup.sh
