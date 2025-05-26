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

.______   .______       _______   ___________    ____ 
|   _  \  |   _  \     |       \ |   ____\   \  /   / 
|  |_)  | |  |_)  |    |  .--.  ||  |__   \   \/   /  
|   _  <  |   _  <     |  |  |  ||   __|   \      /   
|  |_)  | |  |_)  |  __|  '--'  ||  |____   \    /    
|______/  |______/  (__)_______/ |_______|   \__/     
                                                      
 
BANNER
printf "${normal}\n"
printf "${green}${bold}Server hosted by Bare Branch${normal}  •  ${gray}Starting your server…${normal}\n\n"

# ── Launch Minecraft server ──────────────────────────────
JAVA_FLAGS=(
  -Xms128M
  -XX:MaxRAMPercentage=95.0
  -Dterminal.jline=false
  -Dterminal.ansi=true
  -XX:+ParallelRefProcEnabled
  -XX:MaxGCPauseMillis=200
  -XX:+UnlockExperimentalVMOptions
  -XX:+DisableExplicitGC
  -XX:+AlwaysPreTouch
  -XX:G1NewSizePercent=30
  -XX:G1MaxNewSizePercent=40
  -XX:G1HeapRegionSize=8M
  -XX:G1ReservePercent=20
  -XX:G1HeapWastePercent=5
  -XX:G1MixedGCCountTarget=4
  -XX:InitiatingHeapOccupancyPercent=15
  -XX:G1MixedGCLiveThresholdPercent=90
  -XX:G1RSetUpdatingPauseTimePercent=5
  -XX:SurvivorRatio=32
  -XX:+PerfDisableSharedMem
  -XX:MaxTenuringThreshold=1
  -Dusing.aikars.flags=https://mcflags.emc.gs
  -Daikars.new.flags=true
)

: "${SERVER_JARFILE:=server.jar}"

exec java "${JAVA_FLAGS[@]}" -jar "$SERVER_JARFILE"
