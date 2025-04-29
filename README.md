# 🇲🇽 Speedy-OEA-America

Instalador automático de complementos post-instalación para imágenes Enigma2, adaptado especialmente para México y América Latina.

🎯 **Objetivo:** Facilitar la configuración de zona horaria, idioma, listas de satélites y OSCam en receptores con OpenATV u otras imágenes compatibles.

> 🔧 Basado en el proyecto original de [Jungle-Team](https://github.com/jungla-team/Speedy-OEA-autoinstall), esta versión no oficial ha sido adaptada por la comunidad para usuarios de América.

---

## 🛠️ Funciones principales

✅ Detección automática de imagen instalada  
✅ Configuración de zona horaria: `America/Mexico_City`  
✅ Locale en `UTF-8 Español México (es_MX)`  
✅ Repositorios Jungle-Team y OpenATV  
✅ Instalación directa de:
- OSCam TRUNK
- OSCam Conclave

---

## 🗺️ Imágenes compatibles

- ✅ OpenATV 7.x  
- 🚧 OpenPLi *(planeado para V2)*  
- 🚧 Egami, OpenSPA *(bajo exploración)*

---

## 📦 Instalación rápida

Desde tu receptor Enigma2 (por SSH como root):

```bash
cd /tmp
wget https://raw.githubusercontent.com/itorres2020/Speedy-OEA-America/main/install.sh -O install.sh
chmod +x install.sh
./install.sh

