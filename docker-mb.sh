# bash -c "$(wget -qLO - http://192.168.5.18:8080/share.cgi?ssid=0Du0EMM&fid=0Du0EMM&filename=docker-mb.sh&openfolder=forcedownload&ep=)"
# https://www.icloud.com/iclouddrive/001U0xd4CvAbKxu1K_mwrSwIw#docker-mb
#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"
    ____             __            
   / __ \____  _____/ /_  __  _____
  / / / / __ \/ ___/ //_/ _ \/ ___/
 / /_/ / /_/ / /__/ ,< /  __/ /    
/_____/\____/\___/_/|_|\___/_/     
 
EOF
}
header_info
echo -e "Loading..."
APP="Docker"
var_disk="4"
var_cpu="2"
var_ram="2048"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW="michael"
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH=yes"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /var ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Updating ${APP} LXC"
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
msg_ok "Updated ${APP} LXC"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"