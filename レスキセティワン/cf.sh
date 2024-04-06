#!/bin/bash
# =========================================
# Menu For Script
# Edition : Stable Edition V2.0
# Auther  : Tekirovpn X Lynzvpn
# (C) Copyright 2023-2024
# =========================================
MYIP=$(wget -qO- icanhazip.com);
apt install jq curl -y
clear
read -p "Masukan Domain contoh :sg80 :" domen
DOMAIN=tekirovpn.my.id
sub=${domen}
#(</dev/urandom tr -dc a-z0-9 | head -c5)
dns=${sub}.jabar.shop
CF_ID=nelihsukarna9@gmail.com
CF_KEY=d42c65988dde5c910f39c771734f52c4fa83f
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating Domain for ${dns}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${dns}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${dns}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "$dns" > /root/domain
echo "$dns" > /root/scdomain
echo "$dns" > /etc/xray/domain
echo "$dns" > /etc/v2ray/domain
echo "$dns" > /etc/xray/scdomain
echo "$MYIP=$dns" > /var/lib/lynz/ipvps.conf
cd
