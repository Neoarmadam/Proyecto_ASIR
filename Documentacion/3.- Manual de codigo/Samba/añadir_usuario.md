# Samba/añadir_usurio.sh

Script para la creación de usuarios Samba con grupos de acceso específicos.

## Overview

Este script permite crear usuarios en el sistema sin acceso a shell
y los vincula a grupos predefinidos (editores, streamers, admins) para gestionar
permisos en recursos compartidos de Samba.

## Index

* [comprobar_root](#comprobarroot)
* [seleccionar_grupo](#seleccionargrupo)
* [crear_usuario_linux](#crearusuariolinux)
* [configurar_samba](#configurarsamba)
* [main](#main)

### comprobar_root

Comprueba si el script se ejecuta con privilegios de superusuario.

#### Exit codes

* **1**: Si el usuario no es root.

### seleccionar_grupo

Define la variable global GRUPO.

#### Exit codes

* **1**: Si la opción ingresada no está entre 1 y 3.

### crear_usuario_linux

Define la variable global USUARIO.

#### Exit codes

* **1**: Si el usuario ya existe en el sistema.

### configurar_samba

Reinicia el servicio smb para aplicar los cambios.

### main

Función principal. Coordina la creación y configuración del usuario Samba.

