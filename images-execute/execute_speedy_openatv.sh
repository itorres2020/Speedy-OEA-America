#!/bin/bash

######################  Speedy OEA México by tochtly2020  ########################
# Versión tropicalizada para receptores con OpenATV en América Latina              #
# Configura zona horaria, idioma, feed Jungle-Team, EPG MX y paquetes esenciales   #
######################################################################################

# Colores para salida en terminal
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"
RED_BOLD="\e[1;31m"
GREEN_BOLD="\e[1;32m"
YELLOW_BOLD="\e[1;33m"
BLUE_BOLD="\e[1;34m"

# Log del instalador
LOG_PATH="/var/log/speedy_mexico_autoinstall.log"

# Feed Jungle-Team
REPO_JUNGLE="http://tropical.jungle-team.online/script/jungle-feed.conf"

# Barra de progreso
function progress_bar() {
    local duration=${1}
    local BAR_LENGTH=10
    local BAR_CHARACTER="▇"
    local EMPTY_CHARACTER=" "

    for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
        local completed_blocks=$((elapsed * BAR_LENGTH / duration))
        local remaining_blocks=$((BAR_LENGTH - completed_blocks))
        local percentage=$((elapsed * 100 / duration))

        printf "${GREEN}"
        printf "%0.s${BAR_CHARACTER}" $(seq 1 $completed_blocks)
        printf "${RESET}"
        printf "%0.s${EMPTY_CHARACTER}" $(seq 1 $remaining_blocks)
        printf "| %3d%%\r" $percentage
        sleep 1
    done
    printf "\n"
}

# Temporizador con opción a cancelar
function temporizador() {
    local tiempo=15
    echo
    echo -e "${RED_BOLD}⚠️   Si continúas, se ejecutará la instalación. Pulsa Ctrl+C para cancelar.${RESET}"
    for ((i=tiempo; i>0; i--)); do
        printf "\rTienes ${GREEN_BOLD}%2d segundos${RESET} para pulsar ${YELLOW_BOLD}Ctrl+C${RESET} y cancelar..." $i
        sleep 1
    done
    echo "\n"
}

# Zona horaria y localización
function configurar_localizacion() {
    echo -e "${BLUE}Configurando zona horaria y localización para México...${RESET}"
    ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
    echo "es_MX.UTF-8 UTF-8" > /etc/locale.gen
    export LANG=es_MX.UTF-8
    echo -e "LANG=es_MX.UTF-8" > /etc/default/locale
    echo -e "${GREEN}Zona horaria y localización configuradas.${RESET}"
}

# Verificar conexión a Internet
function verificar_conexion() {
    echo -e "${BLUE}Verificando conexión a Internet...${RESET}"
    wget -q --spider http://google.com
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: No hay conexión a Internet. Salida forzada.${RESET}"
        exit 1
    fi
    echo -e "${GREEN}Conexión a Internet OK.${RESET}"
}

# Instalar feed Jungle-Team
function instalar_feed_jungle() {
    if [ -f "/etc/opkg/jungle-feed.conf" ]; then
        echo -e "${YELLOW}Feed Jungle-Team ya instalado.${RESET}"
    else
        echo -e "${BLUE}Instalando feed Jungle-Team...${RESET}"
        wget "$REPO_JUNGLE" -O /etc/opkg/jungle-feed.conf >> $LOG_PATH 2>&1
        echo -e "${GREEN}Feed Jungle-Team instalado.${RESET}"
    fi
}

# Actualizar OPKG
function actualizar_opkg() {
    echo -e "${BLUE}Actualizando repositorios OPKG...${RESET}"
    opkg update >> $LOG_PATH 2>&1
    echo -e "${GREEN}Repositorios actualizados.${RESET}"
}

# Instalar paquetes esenciales
function instalar_paquetes_esenciales() {
    echo -e "${BLUE}Instalando paquetes base para América...${RESET}"
    opkg install enigma2-plugin-softcams-oscam-trunk >> $LOG_PATH 2>&1
    opkg install enigma2-plugin-softcams-oscam-conclave >> $LOG_PATH 2>&1
    opkg install enigma2-plugin-extensions-epgimport >> $LOG_PATH 2>&1
    opkg install enigma2-plugin-extensions-tdtchannels >> $LOG_PATH 2>&1
    echo -e "${GREEN}Paquetes base instalados.${RESET}"
}

# Instalar fuentes EPG México y activar importación
function instalar_epg_mx() {
    echo -e "${BLUE}Instalando fuentes EPG para canales de México...${RESET}"

    mkdir -p /etc/epgimport/mx
    cd /etc/epgimport/mx

    wget -q https://raw.githubusercontent.com/iptv-org/epg/master/guides/mx/espndeportes.com.mexico.xml -O espndeportes.xml
    wget -q https://raw.githubusercontent.com/iptv-org/epg/master/guides/mx/foxplay.com.mx.xml -O foxplay.xml
    wget -q https://raw.githubusercontent.com/iptv-org/epg/master/guides/mx/izzi.mx.xml -O izzi.xml
    wget -q https://raw.githubusercontent.com/iptv-org/epg/master/guides/mx/mexicotravelchannel.com.mx.xml -O travel.xml
    wget -q https://raw.githubusercontent.com/iptv-org/epg/master/guides/mx/startvmexico.com.xml -O startv.xml

    echo -e "${GREEN}Fuentes EPG descargadas correctamente.${RESET}"

    echo -e "${BLUE}Activando actualización automática de EPG...${RESET}"
    if [ -f /etc/enigma2/epgimport.conf ]; then
        sed -i 's/^enable=.*/enable=1/' /etc/enigma2/epgimport.conf
    fi
    init 4 && sleep 2 && init 3
    echo -e "${GREEN}Actualización automática de EPG activada.${RESET}"
}

# Mostrar logo ASCII clásico
function mostrar_logo() {
    echo -e "${GREEN}"
    cat << "EOF"
                        .::::-----:::.            
                     .::::::::::::::::-:          
                   :::::::::::::::::::::-.         
               .::-::::::::::::::::::::::-.       
            :-::::::::::::::::::::::::::::-        
          :-::::::::::::::::::::::::::::::::      
        :-:::::::::::::::::::::::::::::::::-       
       -::::::::::::::::::::::::::::::::::::-      
     .-::::::::---::::::::::::::::::::::::::=:::   
    --:::::::-=+*#%%%#*+==-::::::::::::::::::=::   
   --::::::--=+**#%%%%@@@@%*-::::::::::::::::=:    
  =-::::::::--==+= +++++++**+=:::::::::::::::+     
  =-------==++++*-*+++++=:.=+++=-::::::::::::-     
  :-:::::=+++++#@@@%#++=.==+++++++=::::::::::-     
   :=----+++++*+*###++++++*+++++++++-:----::::.    
    .--::-+++++*+++++*%@*++++++++++++++++++-::-    
      .:-:-++++++*%%@@@#++++++++++++-::...:=::::   
         .:-=++++%@@@@*+++++++++++=-:.....:-::::-. 
             :****###+++++++++++++=:....:-:::::::-
  ..       :*%%%%%##****+==+==--:--=----:::::::::. 
  =: .::  :%%%%%%*=#%%%%%-  :::::--------:::::.    
  -+:.    #%#*=-.  :#%%%%%-  ..                    
 :+-     :*..        :*%%%-   :=:  .:              
 ++         .           =*      :==-.              
 .         .            .        ++.              
           .            .        -*:              
                        .        :=               
              .  .... .=                            
               .  .   . :.                           
               .  :  ..   ...                        
                 =  :=       ......                 
EOF
    echo -e "${RESET}"
}

# Ejecutar el script base
mostrar_logo
temporizador
verificar_conexion
configurar_localizacion
instalar_feed_jungle
actualizar_opkg
instalar_paquetes_esenciales
instalar_epg_mx

# Aquí continuará el bloque IPTV (cuando se habilite)
