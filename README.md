# 🚀 Fedora Automation Suite | Proyecto Final ASIR

Este ecosistema de automatización ha sido desarrollado como proyecto final para el grado de **ASIR (Administración de Sistemas Informáticos en Red)**. Su objetivo es centralizar la gestión de servidores Fedora mediante scripts Bash, optimizando la administración de almacenamiento y el despliegue de servicios mediante contenedores.

---

## 🛠️ Funcionalidades Principales

* **Abstracción de Comandos:** Inyección de alias "españolizados" para facilitar la administración diaria del sistema.
* **Gestión de Almacenamiento (SMB):** Automatización de infraestructura Samba con jerarquía de grupos (`editores`, `streamers`, `admins`) y gestión de permisos.
* **Virtualización con Podman:** Despliegue automatizado de servidores de videojuegos en contenedores ligeros y seguros.
* **Sincronización:** Sistema de atajos para actualizar el repositorio y los scripts localmente con un solo comando.

---

## 🚀 Instalación y Configuración

Para poner en marcha el entorno, clona el repositorio y ejecuta el script de inicialización:

```bash
git clone https://github.com/Neoarmadam/Proyecto_ASIR
cd Proyecto_ASIR/Automatizacion
chmod +x Españolizar.sh
./Españolizar.sh
```

Despues puedes borrar el repositorio que has clonado, al iniciar el entorno el repositorio se clona en raiz, y con los permisos necesarios para que todas las funciones esten disponibles:

```bash
rm -r Proyecto_ASIR
```
