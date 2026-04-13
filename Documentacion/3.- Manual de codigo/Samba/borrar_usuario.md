# Borrar_Usuarios_Samba.sh

Script interactivo para listar y eliminar usuarios de Samba y del sistema Linux.

## Overview

Proporciona un menú sencillo para visualizar qué usuarios tienen acceso a Samba,
a qué grupos pertenecen y permite eliminarlos de la base de datos TDB de Samba y,
opcionalmente, borrar su cuenta de sistema y directorio personal.

## Index

* [comprobar_root](#comprobarroot)
* [listar_usuarios](#listarusuarios)
* [borrar_usuario](#borrarusuario)
* [main](#main)

### comprobar_root

Comprueba si el script se ejecuta con privilegios de superusuario.

#### Exit codes

* **1**: Si el usuario no es root.

### listar_usuarios

Para cada usuario, muestra los grupos del sistema a los que está asociado.

#### Exit codes

* **1**: Si no se encuentran usuarios en la base de datos de Samba.

#### Output on stdout

* Tabla con la relación Usuario | Grupos.

### borrar_usuario

Primero verifica la existencia del usuario en Samba, lo elimina con smbpasswd
y pregunta al administrador si desea realizar un 'userdel -r' en el sistema Linux.

#### Exit codes

* **0**: Si la operación se cancela o finaliza correctamente.

### main

Función principal que despliega el menú de navegación del script.

