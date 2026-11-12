#!/usr/bin/env bash
# =====================================================================
# Asistente Interactivo para Entrega 2 - Packet Tracer (Telemática)
# Permite copiar al portapapeles cada bloque de configuración IOS,
# consultar el cableado exacto, o lanzar Cisco Packet Tracer.
# =====================================================================
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$BASE_DIR/configs"

copy_to_clipboard() {
    local file="$1"
    if command -v wl-copy >/dev/null 2>&1; then
        wl-copy < "$file"
        echo "✅ Copiado al portapapeles (Wayland / wl-copy): $(basename "$file")"
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard < "$file"
        echo "✅ Copiado al portapapeles (X11 / xclip): $(basename "$file")"
    else
        echo "⚠️  No se detectó wl-copy ni xclip. Mostrando contenido en pantalla:"
        cat "$file"
    fi
}

show_menu() {
    echo "========================================================================="
    echo "   PROYECTO TELEMÁTICA - ENTREGA 2 (AS1 + AS2 + AS99 EN PACKET TRACER)"
    echo "========================================================================="
    echo "  [1] Copiar config AS1-SW1 (Switch VLAN 10/20 Cliente 1)"
    echo "  [2] Copiar config AS1-R1  (Gateway 10.0.0.1 + DHCP Relay + OSPF 1)"
    echo "  [3] Copiar config AS1-R2  (Router Interno + OSPF 1)"
    echo "  [4] Copiar config AS1-R3  (Gateway 172.16.0.1 + DHCP Relay + OSPF 1)"
    echo "  [5] Copiar config AS1-R4  (Borde AS1: NAT/PAT + eBGP AS1 + OSPF 1)"
    echo "  [17] Copiar config AS1-SW2 (Switch VLAN 20/30 + troncal a R3)"
    echo "  -----------------------------------------------------------------------"
    echo "  [6] Copiar config AS2-SW1 (Switch VLAN 10/20 Cliente 2)"
    echo "  [7] Copiar config AS2-R1  (Gateway 10.0.0.1 + DHCP Relay + RIPv2)"
    echo "  [8] Copiar config AS2-R2  (Borde AS2: NAT/PAT + eBGP AS2 + RIPv2)"
    echo "  [9] Copiar config AS2-R3  (Gateway 172.16.0.1 + DHCP Relay + RIPv2)"
    echo "  [10] Copiar config AS2-R4 (Router Interno + RIPv2)"
    echo "  [18] Copiar config AS2-SW2 (Switch VLAN 20/30 + troncal a R3)"
    echo "  -----------------------------------------------------------------------"
    echo "  [11] Copiar config AS99-R6 (Borde Proveedor ISP: eBGP AS99 + OSPF 99)"
    echo "  [12] Copiar config AS99-R5 (Router Servidor DNS + OSPF 99)"
    echo "  [13] Copiar config AS99-R7 (Router Servidor WEB + OSPF 99)"
    echo "  -----------------------------------------------------------------------"
    echo "  [14] Ver guía de Servidores (DHCP, DNS, WEB) y PCs"
    echo "  [15] Regenerar Informe Técnico PDF (INFORME_ENTREGA_2.pdf)"
    echo "  [0] Salir"
    echo "========================================================================="
}

if [[ "${1:-}" == "--verify" ]]; then
    echo "Verificando archivos de configuración, topología .pkt e informe..."
    for f in \
        "$BASE_DIR/Entrega_2_Telematica.pkt" \
        "$CONFIG_DIR/AS1/AS1_SW1.ios" \
        "$CONFIG_DIR/AS1/AS1_R1.ios" \
        "$CONFIG_DIR/AS1/AS1_R2.ios" \
        "$CONFIG_DIR/AS1/AS1_R3.ios" \
        "$CONFIG_DIR/AS1/AS1_R4.ios" \
        "$CONFIG_DIR/AS2/AS2_SW1.ios" \
        "$CONFIG_DIR/AS2/AS2_R1.ios" \
        "$CONFIG_DIR/AS2/AS2_R2.ios" \
        "$CONFIG_DIR/AS2/AS2_R3.ios" \
        "$CONFIG_DIR/AS2/AS2_R4.ios" \
        "$CONFIG_DIR/AS99/AS99_R6.ios" \
        "$CONFIG_DIR/AS99/AS99_R5.ios" \
        "$CONFIG_DIR/AS99/AS99_R7.ios" \
        "$CONFIG_DIR/Servidores_y_PCs/GUIA_SERVIDORES_Y_PCS.md" \
        "$BASE_DIR/informe/INFORME_ENTREGA_2.md" \
        "$BASE_DIR/informe/INFORME_ENTREGA_2.pdf"; do
        if [[ -s "$f" ]]; then
            echo "  [OK] $f ($(wc -c < "$f") bytes)"
        else
            echo "  [ERROR] Falta o está vacío: $f"
            exit 1
        fi
    done
    echo "✅ Todos los archivos del proyecto están completos y listos."
    exit 0
fi

while true; do
    show_menu
    read -rp "Selecciona una opción [0-18]: " opt
    case "$opt" in
        1) copy_to_clipboard "$CONFIG_DIR/AS1/AS1_SW1.ios" ;;
        2) copy_to_clipboard "$CONFIG_DIR/AS1/AS1_R1.ios" ;;
        3) copy_to_clipboard "$CONFIG_DIR/AS1/AS1_R2.ios" ;;
        4) copy_to_clipboard "$CONFIG_DIR/AS1/AS1_R3.ios" ;;
        5) copy_to_clipboard "$CONFIG_DIR/AS1/AS1_R4.ios" ;;
        6) copy_to_clipboard "$CONFIG_DIR/AS2/AS2_SW1.ios" ;;
        7) copy_to_clipboard "$CONFIG_DIR/AS2/AS2_R1.ios" ;;
        8) copy_to_clipboard "$CONFIG_DIR/AS2/AS2_R2.ios" ;;
        9) copy_to_clipboard "$CONFIG_DIR/AS2/AS2_R3.ios" ;;
        10) copy_to_clipboard "$CONFIG_DIR/AS2/AS2_R4.ios" ;;
        11) copy_to_clipboard "$CONFIG_DIR/AS99/AS99_R6.ios" ;;
        12) copy_to_clipboard "$CONFIG_DIR/AS99/AS99_R5.ios" ;;
        13) copy_to_clipboard "$CONFIG_DIR/AS99/AS99_R7.ios" ;;
        14) less "$CONFIG_DIR/Servidores_y_PCs/GUIA_SERVIDORES_Y_PCS.md" ;;
        15) python3 "$BASE_DIR/scripts/generar_informe_pdf.py" ;;
        17) copy_to_clipboard "$CONFIG_DIR/AS1/AS1_SW2.ios" ;;
        18) copy_to_clipboard "$CONFIG_DIR/AS2/AS2_SW2.ios" ;;
        0) exit 0 ;;
        *) echo "Opción no válida." ;;
    esac
    echo ""
done
