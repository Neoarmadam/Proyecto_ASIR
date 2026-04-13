# update.sh

Script para actualizar el repositorio de automatización de Neo y configurar alias.

## Overview

Este script clona un repositorio de GitHub, gestiona archivos de configuración
en /etc/profile.d/ y aplica alias del sistema. Requiere privilegios de root.

## Index

* [comprobar_root](#comprobarroot)
* [comprobar_alias](#comprobaralias)
* [hacer_backup](#hacerbackup)
* [aplicar_alias](#aplicaralias)
* [reiniciar_servidor](#reiniciarservidor)
* [avisos](#avisos)
* [main](#main)

### comprobar_root

Comprueba si el usuario tiene privilegios de superusuario.

#### Exit codes

* **1**: Si el usuario no es root.

### comprobar_alias

Verifica la existencia de un archivo necesario para los alias.

#### Exit codes

* **1**: Si el archivo no existe.

### hacer_backup

Crea un backup con marca de tiempo y vacía el archivo original.

### aplicar_alias

Añade el contenido de un archivo a otro, eliminando formatos de línea de Windows (CRLF).

### reiniciar_servidor

Informa al usuario y reinicia el sistema.

### avisos

Muestra avisos legales y de confirmación al usuario.

#### Exit codes

* **1**: Si el usuario cancela la operación con cualquier tecla que no sea ENTER.

### main

Función principal que coordina la actualización del repo y los alias.

