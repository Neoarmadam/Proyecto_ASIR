#!/bin/bash
# Neo Armada

# @file Servidores/deploy.sh
# @brief Orquestador interactivo para el despliegue de servidores de videojuegos.
# @description Este script escanea un directorio raíz en busca de carpetas de juegos y,
# tras seleccionar uno, permite ejecutar cualquiera de los scripts de despliegue (.sh)
# encontrados en su interior.

# @description Muestra el encabezado visual de bienvenida en la terminal.
mostrar_bienvenida() {
    echo "------------------------------------------"
    echo "BIENVENIDO AL DESPLEGADOR DE SERVIDORES"
    echo "------------------------------------------"
}

# @description Lista las carpetas dentro del directorio raíz y permite elegir una mediante un menú.
# @description Utiliza la salida de errores (stderr) para el menú y la salida estándar (stdout) para el resultado.
# @param $1 string Ruta del directorio donde se encuentran las carpetas de los juegos.
# @stdout El nombre de la carpeta del juego seleccionado.
# @exitcode 1 Si no se encuentran carpetas en el directorio especificado.
seleccionar_juego() {
    local directorio_raiz="$1"
    local juegos=($(ls -d "$directorio_raiz"/*/ 2>/dev/null | xargs -n 1 basename))

    if [ ${#juegos[@]} -eq 0 ]; then
        echo "[-] No se encontraron carpetas de juegos en $directorio_raiz" >&2
        return 1
    fi

    echo "--- Seleccione una opción (número): " >&2
    select juego in "${juegos[@]}"; do
        if [ -n "$juego" ]; then
            echo "$juego"
            break
        else
            echo "[-] Selección no válida. Intenta de nuevo." >&2
        fi
    done
}

# @description Navega a la carpeta del juego y ofrece un menú con los scripts .sh disponibles para ejecución.
# @param $1 string Nombre del juego (carpeta).
# @param $2 string Directorio raíz de los servidores.
# @exitcode 1 Si la ruta no es accesible o no contiene scripts .sh.
ejecutar_despliegue() {
    local nombre_juego="$1"
    local base_dir="$2"
    local ruta_completa="$base_dir/$nombre_juego"

    cd "$ruta_completa" || { echo "[-] No se pudo acceder a $ruta_completa"; return 1; }

    local scripts=($(ls *.sh 2>/dev/null))

    if [ ${#scripts[@]} -eq 0 ]; then
        echo "[-] No hay scripts .sh en $ruta_completa"
        return 1
    fi

    echo "--- Selecciona el script de despliegue para $nombre_juego:"
    select script in "${scripts[@]}"; do
        if [ -n "$script" ]; then
            echo "Iniciando: $script"
            bash "./$script"
            break
        else
            echo "[-] Selección no válida."
        fi
    done
}

# @description Función principal. Define el directorio objetivo y coordina el flujo de selección y ejecución.
main() {
    local TARGET_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    mostrar_bienvenida

    local JUEGO_ELEGIDO=$(seleccionar_juego "$TARGET_DIR")

    if [ -n "$JUEGO_ELEGIDO" ]; then
        echo "[+] Has seleccionado: $JUEGO_ELEGIDO"
        ejecutar_despliegue "$JUEGO_ELEGIDO" "$TARGET_DIR"
    fi
}

main
