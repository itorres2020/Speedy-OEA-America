#!/bin/bash

# Comprobación de root
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

function zona_horaria() {
    echo "Configurando zona horaria a America/Mexico_City..."
    ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime

    if command -v ntpdate >/dev/null 2>&1; then
        echo "Sincronizando hora con mx.pool.ntp.org..."
        ntpdate mx.pool.ntp.org
    else
        echo "⚠️ ntpdate no está disponible. Hora no sincronizada."
    fi
}

function locale_mexico() {
    echo "Configurando UTF-8 para Español México..."
    echo "LANG=es_MX.UTF-8" > /etc/default/locale
    echo "LC_ALL=es_MX.UTF-8" >> /etc/default/locale
    echo "Listo. Reinicia Enigma2 si deseas aplicar el cambio completo."
}

function instalar_repositorios() {
    echo "Agregando repositorios personalizados..."

    echo "deb [trusted=yes] http://jungle-team.com/repo all main" > /etc/apt/sources.list.d/jungle-team.list
    echo "deb http://feeds2.mynonpublic.com/7.3/armv7atv/" > /etc/apt/sources.list.d/openatv.list

    apt-get update
}

function instalar_oscam_trunk() {
    echo "Instalando OSCam TRUNK..."
    apt-get install enigma2-plugin-softcams-oscam-trunk -y
}

function instalar_oscam_conclave() {
    echo "Instalando OSCam Conclave..."
    apt-get install enigma2-plugin-softcams-oscam-conclave -y
}

function mostrar_menu() {
    clear
    echo "=============================================="
    echo "  Speedy OEA América Edition — OpenATV"
    echo "=============================================="
    echo "1. Configurar Zona Horaria América"
    echo "2. Configurar UTF-8 Español México"
    echo "3. Instalar repositorios (OpenATV + JungleTeam)"
    echo "4. Instalar OSCam TRUNK"
    echo "5. Instalar OSCam Conclave"
    echo "6. Salir"
    echo "----------------------------------------------"
    read -p "Selecciona una opción: " opcion

    case $opcion in
        1) zona_horaria ;;
        2) locale_mexico ;;
        3) instalar_repositorios ;;
        4) instalar_oscam_trunk ;;
        5) instalar_oscam_conclave ;;
        6) echo "Hasta pronto." ; exit 0 ;;
        *) echo "Opción inválida." ;;
    esac

    read -p "Presiona Enter para volver al menú..."
    mostrar_menu
}

mostrar_menu
