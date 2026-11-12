# Proyecto_Final_Telematica

**Entrega 2 – Interconexión de sistemas autónomos y acceso a servicios (Packet Tracer)**
Integrantes: David Cuadros y Felipe Gomez

## Contenido

| Ruta | Qué es |
| :--- | :--- |
| `Entrega_2_Telematica.pkt` | Topología completa en Cisco Packet Tracer 9.0.1 (25 equipos), configurada y probada |
| `informe/INFORME_ENTREGA_2.pdf` | Informe técnico con decisiones de ingeniería y pruebas (fuente: `INFORME_ENTREGA_2.md`) |
| `informe/capturas/` | Capturas reales de las pruebas |
| `configs/AS1`, `configs/AS2`, `configs/AS99` | Configuración IOS de cada router y switch |
| `configs/Servidores_y_PCs/GUIA_SERVIDORES_Y_PCS.md` | Cableado, módulos y configuración de los servidores DHCP, DNS, WEB y de los PC |
| `scripts/generar_informe_pdf.py` | Regenera el HTML y el PDF del informe a partir del Markdown |
| `Entrega 2.pdf` | Enunciado |

## Resumen de la solución

- **AS1:** OSPF. **AS2:** RIPv2. **AS99** (proveedor con los servidores DNS y WEB): OSPF 99.
- Cada cliente usa VLAN (10, 20 y 30) y su propio servidor DHCP, al que llegan las solicitudes por DHCP Relay.
- Las redes de los clientes se superponen (`10.0.0.0/24` y `172.16.0.0/24`). Para resolverlo, cada router de borde hace PAT hacia un bloque público único (`198.51.100.0/29` y `198.51.100.8/29`) y lo anuncia por eBGP a AS99.
- Packet Tracer no permite iBGP, así que `AS99-R6` es el único router de AS99 con BGP y propaga una ruta por defecto en OSPF 99.
