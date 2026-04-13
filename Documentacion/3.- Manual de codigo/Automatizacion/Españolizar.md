# Espanolizar_Servidor.sh

Script para instalar dependencias críticas, ZeroTier y configurar alias globales.

## Overview

Este script automatiza la instalación de paquetes DNF (Cockpit, Podman),
configura ZeroTier y aplica una configuración de alias personalizada para todos los usuarios.

## Index

* [comprobar_root](#comprobarroot)
* [instalar_dependencias](#instalardependencias)
* [comprobar_alias](#comprobaralias)
* [hacer_backup](#hacerbackup)
* [aplicar_alias](#aplicaralias)
* [reiniciar_servidor](#reiniciarservidor)
* [dibujar_bandera](#dibujarbandera)
* [avisos](#avisos)
* [main](#main)

### comprobar_root

Comprueba si el usuario tiene privilegios de superusuario usando EUID.

#### Exit codes

* **1**: Si el usuario no tiene privilegios de root.

### instalar_dependencias

También clona el repositorio principal si no existe en el destino.

### comprobar_alias

Verifica la existencia del archivo de texto que contiene los alias.

#### Exit codes

* **1**: Si el archivo no es encontrado.

### hacer_backup

Realiza copia de seguridad del archivo de configuración y lo inicializa.

### aplicar_alias

Limpia caracteres CRLF y concatena los alias al archivo de configuración global.

### reiniciar_servidor

Reinicia el sistema tras una breve pausa para aplicar cambios.

### dibujar_bandera

Dibuja una bandera de España en la terminal usando códigos de color ANSI.

### avisos

Gestiona los avisos de responsabilidad y confirmaciones de usuario.

#### Exit codes

* **1**: Si el usuario decide no continuar.

### main

Punto de entrada principal. Orquestación de dependencias, visuales y alias.

