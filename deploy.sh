#!/bin/bash
# Neo Armada

#Mostrar menu de bienvenida
mostrar_bienvenida() {
    echo "------------------------------------------"
    echo "BIENVENIDO AL DESPLEGADOR DE SERVIDORES"
    echo "------------------------------------------"
}

#Funcion que obtiene una lista de las carpetas de videojuegos y eliges de cual hacer el servidor.
seleccionar_juego() {
    local directorio_raiz="$1"
    local juegos=($(ls -d "$directorio_raiz"/*/ 2>/dev/null | xargs -n 1 basename))
    
    if [ ${#juegos[@]} -eq 0 ]; then
        echo "[-] No se encontraron carpetas de juegos en $directorio_raiz" >&2
        return 1
    fi

    echo "Seleccione una opción (número): " >&2
    select juego in "${juegos[@]}"; do
        if [ -n "$juego" ]; then
            echo "$juego"
            break
        else
            echo "[-] Selección no válida. Intenta de nuevo." >&2
        fi
    done
}

#Funcion que lista las diferentes versiones que puedes hacer de un servidor de un juego.
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

    echo "Selecciona el script de despliegue para $nombre_juego:"
    select script in "${scripts[@]}"; do
        if [ -n "$script" ]; then
            echo "🚀 Iniciando: $script"
            bash "./$script"
            break
        else
            echo "[-] Selección no válida."
        fi
    done
}

#Funcion que ejecuta el Script
main() {
    local TARGET_DIR="/Templates"
    
    mostrar_bienvenida
    
    local JUEGO_ELEGIDO=$(seleccionar_juego "$TARGET_DIR")
    
    if [ -n "$JUEGO_ELEGIDO" ]; then
        echo "[+] Has seleccionado: $JUEGO_ELEGIDO"
        ejecutar_despliegue "$JUEGO_ELEGIDO" "$TARGET_DIR"
    fi
}

main