#!/usr/bin/env bash
set -euo pipefail
bold="$(tput bold)"; normal="$(tput sgr0)"
blue="$(tput setaf 6)"; green="$(tput setaf 2)"; gray="$(tput setaf 8)"

clear

if command -v figlet >/dev/null 2>&1; then
  printf "${blue}${bold}"
  figlet -w 100 "BARE BRANCH"
  printf "${normal}\n"
else
  # Fallback ASCII art (generated with Figlet “standard” font)
  printf "${blue}${bold}"
  cat <<'BANNER'
.______   .______       _______   ___________    ____ 
|   _  \  |   _  \     |       \ |   ____\   \  /   / 
|  |_)  | |  |_)  |    |  .--.  ||  |__   \   \/   /  
|   _  <  |   _  <     |  |  |  ||   __|   \      /   
|  |_)  | |  |_)  |  __|  '--'  ||  |____   \    /    
|______/  |______/  (__)_______/ |_______|   \__/                                                                
BANNER
  printf "${normal}\n"
fi

printf "${green}${bold}SERVER HOSTED BY BARE BRANCH${normal}  •  ${gray}Starting your server…${normal}\n\n"

JAVA_FLAGS=(
  -Xms128M
  -XX:MaxRAMPercentage=95.0
  -Dterminal.jline=false
  -Dterminal.ansi=true
)

: "${SERVER_JARFILE:=server.jar}"

exec java "${JAVA_FLAGS[@]}" -jar "$SERVER_JARFILE"
