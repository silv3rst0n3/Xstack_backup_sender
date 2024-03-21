#!/bin/bash

RED='\e[38;5;196m'
GOLD='\e[38;5;226m'
BLUE='\033[0;36m' 
WHITE='\033[0;37m' 

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
function show_help {
    echo "Usage: ./Xstack_Backup_Sender.sh [OPTIONS]"
    echo -e "${WHITE}Options:"
    echo -e "${RED} -p use for Custom directory for Backup."
    echo -e "${GOLD} -d For Default usage read from Config File."
}

function main {
    if [[ $# -lt 1 ]]; then
        show_help
        exit 1
    fi
}

main "$@"

sleep 8
echo "server Backup Send to Your Google Drive."
sleep 3
if [ -f $PWD/config.txt ]; then
    source $PWD/config.txt
fi

while getopts "p:d" opt; do
  case $opt in
    p)
      echo "Setting new zip path to : $OPTARG"
      path=$OPTARG
      if [[ "${path: -1}" == "/" ]]; then
      echo ""
      else
      echo -e "${RED} \n  [*]Your path input is Not correct !!! add '/' To End  "
      exit;
      fi
      ;;
    d)
      echo "Default Option" >&2
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      show_help
      exit 1
      ;;
  esac
done

echo " Start backup Files Directory : $path"

if [ -f /usr/bin/gdrive ]; then
    echo ""
else
    echo -e "${RED} \n  [*] The 'gdrive' is NOT install in the /usr/bin directory."
    exit;	
fi

if [[ "${zippath: -1}" == "/" ]]; then
      echo ""
else
      echo -e "${RED} \n  [*]Your ZipPath input is Not correct !!! add '/' To End  "
      exit;
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
      read -p "Please Input your Email: " email
      read -p "Please Input your Path: " path
      read -p "Please Input your Path zip File Save: " zippath
      vemail="email=$email"
      printf "$vemail\n" >> config.txt
      vpath="path=$path"
      printf "$vpath\n" >> config.txt
      vzippath="zippath=$zippath"
      printf "$vzippath\n" >> config.txt
else
    time=`TZ='Asia/Tehran' date +%Y-%m-%d_%H_%M`;
    zip $zippath$time.Zip $path -r
    sleep 20
    gdrive files upload $zippath$time.Zip 
    echo "server bacup send file to Email. on DATE:$time" 
fi


function main {
    if [[ $# -lt 1 ]]; then
        show_help
        exit 1
    fi
}
