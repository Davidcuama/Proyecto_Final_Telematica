# Configuración de Servidores (DHCP, DNS, WEB) y PCs en Packet Tracer

Esta guía detalla los valores exactos que debes ingresar en la interfaz gráfica (GUI) de cada servidor y PC dentro de Cisco Packet Tracer.

---

## 0. Armado de la topología (hacerlo antes de pegar las configuraciones)

### 0.1 Equipos (25 en total)
| AS | Equipos |
| :--- | :--- |
| AS1 | `AS1-R1`, `AS1-R2`, `AS1-R3`, `AS1-R4` (2911), `AS1-SW1`, `AS1-SW2` (2960-24TT), `AS1-PC1`, `AS1-PC2` (PC-PT), `AS1-DHCP` (Server-PT) |
| AS2 | `AS2-R1`, `AS2-R2`, `AS2-R3`, `AS2-R4` (2911), `AS2-SW1`, `AS2-SW2` (2960-24TT), `AS2-PC1`, `AS2-PC2` (PC-PT), `AS2-DHCP` (Server-PT) |
| AS99 | `AS99-R5`, `AS99-R6`, `AS99-R7` (2911), `AS99-DNS`, `AS99-WEB` (Server-PT) |

### 0.2 Módulos
El Cisco 2911 solo trae `Gi0/0`, `Gi0/1` y `Gi0/2` (no existe `Gi0/3`).
- **`AS1-R4`, `AS2-R2` y `AS99-R6`**: pestaña *Physical* → apagar el router → arrastrar **`HWIC-2T`** al slot 0 → encender. Aparecen `Serial0/0/0` y `Serial0/0/1`.
- **`AS1-R3` y `AS2-R3`** no necesitan módulo: usan *Router-on-a-Stick* (subinterfaces `Gi0/0.20` y `Gi0/0.30`) hacia el switch `SW2`.

### 0.3 Cableado
| Origen | Destino | Cable |
| :--- | :--- | :--- |
| `ASx-PC1` Fa0 | `ASx-SW1` Fa0/1 | Copper Straight-Through |
| `ASx-SW1` Fa0/2 | `ASx-R1` Gi0/0 | Copper Straight-Through |
| `ASx-PC2` Fa0 | `ASx-SW2` Fa0/1 | Copper Straight-Through |
| `ASx-DHCP` Fa0 | `ASx-SW2` Fa0/2 | Copper Straight-Through |
| `ASx-SW2` Gi0/1 | `ASx-R3` Gi0/0 (troncal) | Copper Straight-Through |
| `ASx-R1` Gi0/1 | `ASx-R3` Gi0/1 | Copper Cross-Over |
| `ASx-R1` Gi0/2 | `ASx-R2` Gi0/2 | Copper Cross-Over |
| `ASx-R3` Gi0/2 | `ASx-R4` Gi0/2 | Copper Cross-Over |
| `ASx-R2` Gi0/1 | `ASx-R4` Gi0/1 | Copper Cross-Over |
| `AS99-R6` Se0/0/0 | `AS1-R4` Se0/0/0 | **Serial DCE** (hacer clic primero en R6) |
| `AS99-R6` Se0/0/1 | `AS2-R2` Se0/0/0 | **Serial DCE** (hacer clic primero en R6) |
| `AS99-R6` Gi0/0 | `AS99-R5` Gi0/1 | Copper Cross-Over |
| `AS99-R6` Gi0/1 | `AS99-R7` Gi0/1 | Copper Cross-Over |
| `AS99-R5` Gi0/2 | `AS99-R7` Gi0/2 | Copper Cross-Over |
| `AS99-R5` Gi0/0 | `AS99-DNS` Fa0 | Copper Cross-Over |
| `AS99-R7` Gi0/0 | `AS99-WEB` Fa0 | Copper Cross-Over |

(`ASx` = `AS1` y `AS2`.)

### 0.4 Orden recomendado
1. Switches (`SW1`, `SW2`) → 2. Routers de AS99 → 3. Routers internos de AS1/AS2 → 4. Routers de borde (`AS1-R4`, `AS2-R2`) → 5. Servidores (DHCP, DNS, WEB) → 6. PCs en DHCP.
Pegar cada archivo `.ios` en la pestaña *CLI* del equipo.

---

## 1. Servidor DHCP del Cliente 1 (`AS1-DHCP`)
- **Ubicación:** Conectado a `AS1-SW2` puerto `Fa0/2` (VLAN 30), que llega a `AS1-R3` por la subinterfaz `Gi0/0.30` (subred `192.168.1.96/29`).
- **Configuración IP (Desktop -> IP Configuration):**
  - **IPv4 Address:** `192.168.1.100`
  - **Subnet Mask:** `255.255.255.248`
  - **Default Gateway:** `192.168.1.97`
  - **DNS Server:** `203.0.113.66`

- **Configuración del Servicio DHCP (Services -> DHCP -> Interfaz FastEthernet0):**
  - **Service:** `On`
  - **Pool 1 (Modificar `serverPool` por defecto para no dejar un pool vacío):**
    - **Pool Name:** `serverPool`
    - **Default Gateway:** `192.168.1.97`
    - **DNS Server:** `203.0.113.66`
    - **Start IP Address:** `192.168.1.101`
    - **Subnet Mask:** `255.255.255.248`
    - **Maximum Number of Users:** `3`
    - *(Clic en **Save**)*
  - **Pool 2 (Para la VLAN 10 — Red `10.0.0.0/24` detrás de R1):**
    - **Pool Name:** `POOL_VLAN10_10`
    - **Default Gateway:** `10.0.0.1`
    - **DNS Server:** `203.0.113.66`
    - **Start IP Address:** `10.0.0.10`
    - **Subnet Mask:** `255.255.255.0`
    - **Maximum Number of Users:** `200`
    - *(Clic en **Add**)*
  - **Pool 3 (Para la VLAN 20 — Red `172.16.0.0/24` detrás de R3):**
    - **Pool Name:** `POOL_VLAN20_172`
    - **Default Gateway:** `172.16.0.1`
    - **DNS Server:** `203.0.113.66`
    - **Start IP Address:** `172.16.0.10`
    - **Subnet Mask:** `255.255.255.0`
    - **Maximum Number of Users:** `200`
    - *(Clic en **Add**)*

---

## 2. Servidor DHCP del Cliente 2 (`AS2-DHCP`)
- **Ubicación:** Conectado a `AS2-SW2` puerto `Fa0/2` (VLAN 30), que llega a `AS2-R3` por la subinterfaz `Gi0/0.30` (subred `192.168.2.96/29`).
- **Configuración IP (Desktop -> IP Configuration):**
  - **IPv4 Address:** `192.168.2.100`
  - **Subnet Mask:** `255.255.255.248`
  - **Default Gateway:** `192.168.2.97`
  - **DNS Server:** `203.0.113.66`

- **Configuración del Servicio DHCP (Services -> DHCP -> Interfaz FastEthernet0):**
  - **Service:** `On`
  - **Pool 1 (Modificar `serverPool` por defecto):**
    - **Pool Name:** `serverPool`
    - **Default Gateway:** `192.168.2.97`
    - **DNS Server:** `203.0.113.66`
    - **Start IP Address:** `192.168.2.101`
    - **Subnet Mask:** `255.255.255.248`
    - **Maximum Number of Users:** `3`
    - *(Clic en **Save**)*
  - **Pool 2 (Para la VLAN 10 — Red `10.0.0.0/24` detrás de R1 en AS2):**
    - **Pool Name:** `POOL_VLAN10_10`
    - **Default Gateway:** `10.0.0.1`
    - **DNS Server:** `203.0.113.66`
    - **Start IP Address:** `10.0.0.10`
    - **Subnet Mask:** `255.255.255.0`
    - **Maximum Number of Users:** `200`
    - *(Clic en **Add**)*
  - **Pool 3 (Para la VLAN 20 — Red `172.16.0.0/24` detrás de R3 en AS2):**
    - **Pool Name:** `POOL_VLAN20_172`
    - **Default Gateway:** `172.16.0.1`
    - **DNS Server:** `203.0.113.66`
    - **Start IP Address:** `172.16.0.10`
    - **Subnet Mask:** `255.255.255.0`
    - **Maximum Number of Users:** `200`
    - *(Clic en **Add**)*

---

## 3. Servidor DNS en AS99 (`AS99-DNS`)
- **Ubicación:** Conectado a `AS99-R5` en el puerto `GigabitEthernet0/0` (subred `203.0.113.64/26`).
- **Configuración IP (Desktop -> IP Configuration):**
  - **IPv4 Address:** `203.0.113.66`
  - **Subnet Mask:** `255.255.255.192`
  - **Default Gateway:** `203.0.113.65`
  - **DNS Server:** `203.0.113.66`

- **Configuración del Servicio DNS (Services -> DNS):**
  - **DNS Service:** `On`
  - **Registros tipo `A Record` a agregar:**
    1. **Name:** `www.as99.com` | **Type:** `A Record` | **Address:** `203.0.113.130` -> *(Clic en **Add**)*
    2. **Name:** `as99.com` | **Type:** `A Record` | **Address:** `203.0.113.130` -> *(Clic en **Add**)*
    3. **Name:** `web.as99.com` | **Type:** `A Record` | **Address:** `203.0.113.130` -> *(Clic en **Add**)*
    4. **Name:** `dns.as99.com` | **Type:** `A Record` | **Address:** `203.0.113.66` -> *(Clic en **Add**)*

---

## 4. Servidor WEB en AS99 (`AS99-WEB`)
- **Ubicación:** Conectado a `AS99-R7` en el puerto `GigabitEthernet0/0` (subred `203.0.113.128/26`).
- **Configuración IP (Desktop -> IP Configuration):**
  - **IPv4 Address:** `203.0.113.130`
  - **Subnet Mask:** `255.255.255.192`
  - **Default Gateway:** `203.0.113.129`
  - **DNS Server:** `203.0.113.66`

- **Configuración del Servicio HTTP/HTTPS (Services -> HTTP):**
  - **HTTP:** `On`
  - **HTTPS:** `On`
  - *(Opcional)* Editar `index.html` y pegar el siguiente código HTML para personalizar la evidencia en el navegador:
    ```html
    <html>
    <head><title>Portal Centralizado AS99 - Telematica</title></head>
    <body bgcolor="#f4f6f9">
      <center>
        <hr>
        <h1 style="color:#004488;">AS99 - Proveedor de Servicios Centralizados</h1>
        <h3>Servicio WEB y DNS Operativo (203.0.113.130 - www.as99.com)</h3>
        <p>Acceso exitoso desde Sistemas Autonomos de Clientes (AS1 / AS2) mediante eBGP + NAT/PAT.</p>
        <hr>
      </center>
    </body>
    </html>
    ```

---

## 5. PCs Clientes en AS1 y AS2 (`AS1-PC1`, `AS1-PC2`, `AS2-PC1`, `AS2-PC2`)
- **En cada uno de los 4 PCs:**
  - Abrir **Desktop -> IP Configuration**
  - Seleccionar **DHCP** (en lugar de Static).
  - Observar cómo `ip helper-address` en `R1` y `R3` encapsula el broadcast `DHCPDISCOVER` como unicast hacia el servidor DHCP local de cada AS (`192.168.1.100` en AS1, `192.168.2.100` en AS2) y asigna automáticamente:
    - **`AS1-PC1` y `AS2-PC1`:** IP `10.0.0.10/24`, Gateway `10.0.0.1`, DNS `203.0.113.66`
    - **`AS1-PC2` y `AS2-PC2`:** IP `172.16.0.10/24`, Gateway `172.16.0.1`, DNS `203.0.113.66`
