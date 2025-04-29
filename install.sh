#!/bin/bash
# Speedy OEA América Launcher - Versión 1

GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR_VERSION=$(echo "$PYTHON_VERSION" | cut -d'.' -f1)
TIEMPO_ESPERA="sleep 5"
TEXTO_SALIDA="se procede a cerrar la ejecución de Speedy OEA América Edition"
BANDERA_IDIOMA="🇲🇽"

clear
echo -e "${GREEN}******************************************************************************${RESET}"
echo -e "${GREEN}*                   Speedy OEA Autoinstall — América Edition                  *${RESET}"
echo -e "${GREEN}*           Repositorio: github.com/itorres2020/Speedy-OEA-America           *${RESET}"
echo -e "${GREEN}******************************************************************************${RESET}"
echo
echo "$BANDERA_IDIOMA es el idioma usado en los mensajes de salida del script."

if [ "$PYTHON_MAJOR_VERSION" = "2" ]; then
    echo -e "${RED}⛔️ Python 2 no es compatible. $TEXTO_SALIDA${RESET}"
    $TIEMPO_ESPERA
    exit 1
fi

if [ -f /etc/image-version ]; then
    DISTRO=$(grep distro /etc/image-version | sed -e 's/distro=//')
elif grep -qs "openpli" /etc/issue; then
    DISTRO="openpli"
else
    echo -e "${RED}⚠️ No se pudo detectar la imagen instalada. $TEXTO_SALIDA${RESET}"
    $TIEMPO_ESPERA
    exit 1
fi

echo "🔎 Imagen detectada: $DISTRO"
BASE_URL="https://raw.githubusercontent.com/itorres2020/Speedy-OEA-America/main/images-execute"

case "$DISTRO" in
    openatv)
        echo -e "${YELLOW}👍 Ejecutando Speedy América para OpenATV...${RESET}"
        $TIEMPO_ESPERA
        wget -q --no-check-certificate "$BASE_URL/execute_speedy_openatv.sh"
        chmod +x execute_speedy_openatv.sh
        bash execute_speedy_openatv.sh
        rm -f execute_speedy_openatv.sh
        ;;
    *)
        echo -e "${RED}⛔️ Imagen $DISTRO no compatible. $TEXTO_SALIDA${RESET}"
        $TIEMPO_ESPERA
        exit 1
        ;;
esac
