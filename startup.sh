#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────
#  Bare Branch Minecraft startup script
# ──────────────────────────────────────────────────────────
set -euo pipefail

# ── Fancy banner ──────────────────────────────────────────
bold="$(tput bold)"; normal="$(tput sgr0)"
blue="$(tput setaf 6)"; green="$(tput setaf 2)"; gray="$(tput setaf 8)"

clear
printf "${blue}${bold}"
cat <<'BANNER'
 ____                  ____                      _     
| __ )  ___  _ __ ___ | __ )  __ _ ___  ___ _ __| |__  
|  _ \ / _ \| '_ ` _ \|  _ \ / _` / __|/ _ \ '__| '_ \ 
| |_) | (_) | | | | | | |_) | (_| \__ \  __/ |  | |_) |
|____/ \___/|_| |_| |_|____/ \__,_|___/\___|_|  |_.__/ 
BANNER
printf "${normal}\n"
printf "${green}${bold}Server hosted by Bare Branch${normal}  •  ${gray}Starting your server…${normal}\n\n"

# ── Launch Minecraft server ──────────────────────────────
JAVA_FLAGS=(
  -Xms128M
  -XX:MaxRAMPercentage=95.0
  -Dterminal.jline=false
  -Dterminal.ansi=true
)

: "${SERVER_JARFILE:=server.jar}"

exec java "${JAVA_FLAGS[@]}" -jar "$SERVER_JARFILE"
