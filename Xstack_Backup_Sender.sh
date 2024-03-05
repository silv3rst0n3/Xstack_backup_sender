#!/bin/bash

RED='\e[38;5;196m'
GOLD='\e[38;5;226m'

echo -e "${RED}                                                                             
 #   #   ###   #####    #     ###   #   #         #####  #####    #    #   # 
 #   #  #   #    #     # #   #   #  #  #            #    #       # #   ## ## 
  # #   #        #    #   #  #      # #             #    #      #   #  # # # 
   #     ###     #    #   #  #      ##              #    ####   #   #  # # # 
  # #       #    #    #####  #      # #             #    #      #####  #   # 
 #   #  #   #    #    #   #  #   #  #  #            #    #      #   #  #   # 
 #   #   ###     #    #   #   ###   #   #           #    #####  #   #  #   # 
${GOLD}                                                                                                                                                         
"
sleep 8
echo "server Backup Send to Email TOOLS"
sleep 3
if [ -f $PWD/config.txt ]; then
    source config.txt
fi

if [ -z "$email" ]
then
      echo -e "${RED} Install Zip tools..."
      sleep 4;
      os=$(grep -E '^(NAME)=' /etc/os-release | cut -d "=" -f 2 | tr -d '"' )
      if [ "$os" = "Ubuntu" ] || [ "$os" = "Debian" ] || [ "$os" = "Mint" ]; then
          sudo apt install zip
      elif [ "$os" = "RedHa" ] || [ "$os" = "CentOS" ] || [ "$os" = "Fedora" ]; then
            sudo dnf install zip
      elif [ "$os" = "Arch" ] || [ "$os" = "Manjaro Linux" ]; then
            sudo pacman -S zip
      elif [ "$os" = "OpenSUSE" ]; then
            sudo zypper install zip
      fi
      echo -e  "\n"
      echo -e "${GOLD}Config File is Empty ADD DATA To config file..."
      read -p "Please Input Outlook Email: " outemail
      read -p "Please Input Outlook Email Password: " outemailpass
      read -p "Please Input your Email: " email
      read -p "Please Input your Path: " path
      read -p "Please Input your Path zip File Save: " zippath
      voutemail="outemail=$outemail"
      printf "$voutemail\n" > config.txt
      voutemailpass="outemailpass=$outemailpass"
      printf "$voutemailpass\n" >> config.txt
      vemail="email=$email"
      printf "$vemail\n" >> config.txt
      vpath="path=$path"
      printf "$vpath\n" >> config.txt
      vzippath="zippath=$zippath"
      printf "$vzippath\n" >> config.txt
else
    time=`TZ='Asia/Tehran' date +%Y-%m-%d_%H_%M`;
    zip $zippath$time.Zip $path*
    sleep 20
    curl --url 'smtp://smtp-mail.outlook.com:587' --ssl-reqd   --mail-from $outemail --mail-rcpt $email   --user $outemail:$outemailpass   -F "=@$zippath$time.Zip"   -H "Subject: EMail Bacup from server(Xstack Team)"   -H "From: SERVER Bacup <$outemail>"   -H "To: <$email>"
    echo "server bacup send file to Email. on DATE:$time" 
fi




