# Servidores/deploy.sh

Orquestador interactivo para el despliegue de servidores de videojuegos.

## Overview

Este script escanea un directorio raíz en busca de carpetas de juegos y,
tras seleccionar uno, permite ejecutar cualquiera de los scripts de despliegue (.sh)
encontrados en su interior.

## Index

* [mostrar_bienvenida](#mostrarbienvenida)
* [seleccionar_juego](#seleccionarjuego)
* [ejecutar_despliegue](#ejecutardespliegue)
* [main](#main)

### mostrar_bienvenida

Muestra el encabezado visual de bienvenida en la terminal.

### seleccionar_juego

Utiliza la salida de errores (stderr) para el menú y la salida estándar (stdout) para el resultado.

#### Exit codes

* **1**: Si no se encuentran carpetas en el directorio especificado.

#### Output on stdout

* El nombre de la carpeta del juego seleccionado.

### ejecutar_despliegue

Navega a la carpeta del juego y ofrece un menú con los scripts .sh disponibles para ejecución.

#### Exit codes

* **1**: Si la ruta no es accesible o no contiene scripts .sh.

### main

Función principal. Define el directorio objetivo y coordina el flujo de selección y ejecución.

