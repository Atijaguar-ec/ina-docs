# Informe Empírico de Despliegue en Instancia Limpia GCP (Rama `main`)

- **Fecha:** 2026-11-16
- **Proyecto GCP:** `ai-lab-sandbox-514619` (`us-central1-a`, recurso efímero destruido al cierre)
- **VM Aprovisionada:** `inatrace-clean-test-vm` · `e2-standard-4` (`4 vCPU x86_64`, `16 GB RAM`, `60 GB SSD`, IP efímera `34.68.22.62`)
- **Sistema Operativo:** Ubuntu 24.04.5 LTS (`noble`, kernel `7.0.0-1017-gcp`)
- **Dominio TLS de Prueba:** `34.68.22.62.sslip.io` (certificado Let's Encrypt real emitido durante la prueba)
- **Código Fuente Compilado (`main`):**
  - `https://github.com/Atijaguar-ec/backend` (`main` @ `a0d1951decdca4743250a1ed74d3f348baeec63e`, 15 migraciones Flyway)
  - `https://github.com/Atijaguar-ec/fe` (`main` @ `18e17fe26feb708510fe5511557a0a18fb29721b`)
- **Documento Validado:** [`01-manual-instalacion-despliegue.md`](./manuales/01-manual-instalacion-despliegue.md) (junto con [`docker-compose.verificado.yml`](./manuales/verificado/docker-compose.verificado.yml), rutas iniciales de [`02-manual-configuracion-multitenant-multicadena.md`](./manuales/02-manual-configuracion-multitenant-multicadena.md), [`03-manual-operacion-trazabilidad.md`](./manuales/03-manual-operacion-trazabilidad.md) y respaldo de [`05-manual-mantenimiento-migraciones-troubleshooting.md`](./manuales/05-manual-mantenimiento-migraciones-troubleshooting.md))

---

## 1. Hallazgos Corregidos Antes y Durante la Prueba

1. **Orden invertido de secciones §3 y §4 en el Módulo 01:** En el borrador previo se invocaban `git clone` y `docker build` antes de instalar `git` y `docker-ce`. Se reordenó el manual dejando primero §3 (sistema operativo, Docker Engine y cortafuegos) y luego §4 (clonación de rama `main`, *swap* y compilación).
2. **Secuencia interactiva `newgrp docker`:** En bloques de comandos por SSH, `newgrp docker` abre una subshell y detiene el flujo. Se sustituyó por reconexión de sesión SSH o comprobación inmediata con `sg docker -c "docker compose version"`.
3. **Cortafuegos VPC del proveedor cloud (§3.3):** Las instancias cloud bloquean `80/tcp` y `443/tcp` en su perímetro VPC por defecto, lo que provoca *timeout* en `certbot --standalone` si solo se configura `ufw`. Se añadió la advertencia explícita en §3.3.
4. **Sincronización Backend → Keycloak en altas nuevas (§6.2, §9.1, §9.2):**
   - `KeycloakAdminConfig` requiere `INATRACE_KEYCLOAK_ADMIN_CLIENT_SECRET: ${KEYCLOAK_CLIENT_SECRET}` (sin esa variable usaba el valor por defecto `backend-secret-123` y fallaba al pedir token `client_credentials`).
   - El cliente de servicio `service-account-inatrace-backend` requiere el rol `manage-users` de `realm-management` en Keycloak.
   - Con ambos activos, `POST /api/user/register` (`UserService.createUser()`) crea el usuario automáticamente en Keycloak con contraseña temporal y `emailVerified: false`. Por eso el §9.2 se actualizó para verificar y fijar la contraseña mediante `PUT` idempotente (con respaldo `POST` si no existía), evitando errores `HTTP 409 Conflict`.
5. **Tiempo real de primera compilación del Frontend (§4.2):** Sin caché previa de `npm`/Nx, la compilación completa del frontend sobre `4 vCPU` tardó **344 s (5 min 44 s)**, superando la estimación previa de «2–4 minutos». Se ajustó el comentario del manual a 5–7 minutos.

---

## 2. Evidencia Empírica de Ejecución en la VM Limpia

| Fase / Prueba | Resultado | Tiempos y Evidencia Observada |
|---|---|---|
| **§3 OS + Docker + UFW** | **PASS (`exit 0`)** | **78 s** · Docker `29.10.0`, Compose `v5.7.1`, UFW activo en `22/tcp`, `80/tcp`, `443/tcp`; `sg docker -c "docker compose version"` y grupo `docker` activos en nueva sesión SSH. |
| **§4 Clonación `main` + Swap + Builds** | **PASS (`exit 0`)** | **448 s total** · `backend` (`a0d1951d`, 15 SQLs): **98 s** (`669 MB`); `fe` (`18e17fe2`): **344 s** (`136 MB`); `/swapfile` de `4 GiB` activo. |
| **§5–§7 `initdb`, `.env`, TLS y Nginx** | **PASS (`exit 0`)** | **20 s** · Certificado Let's Encrypt emitido vía `certbot --standalone` para `34.68.22.62.sslip.io`; `docker compose config -q` en `0`; `nginx -t` sobre Nginx `1.24.0` con 0 advertencias. |
| **§8 Arranque y Flyway `V1`–`V15`** | **PASS (`exit 0`)** | **93 s** (incluye pull de Postgres `16.10` y Keycloak `26.0.0`) · `inatrace-postgres`, `inatrace-keycloak` y `inatrace-frontend` `Up (healthy)`; mapeos estrictos en `127.0.0.1` (`5433`, `8081`, `8082`, `8083`); `Started INATraceBackendApplication in 23.389 s`; `schema_version` en `15|15` (`1.231 s`); DBs `inatrace_core` e `inatrace_keycloak` creadas. |
| **§9.1–§9.2 OIDC, `manage-users` y Auto-Sync** | **PASS (`exit 0`)** | Realm (`201`), backend client (`201`), rol `manage-users` (`204`), frontend PKCE `S256` (`201`), JWKS (`200`). `POST /api/user/register` creó automáticamente al admin en Keycloak (`id=ed46741b-85cf-48c9-80ab-7d3f131d1b12`); actualización `PUT` + `reset-password` (`204`/`204`); `GET /api/company/list` (`200`); borrado de `verificacion-cli` (`204`). Segundo usuario (`operador@mi-cooperativa.org`) auto-sincronizado con 0 errores de Keycloak en logs. |
| **§9.3–§10 Semilla Base y Cierre Web** | **PASS (`exit 0`)** | Semilla SQL + `setval` sin errores (`semiproducttranslation` `ES`: `Cacao en Baba`, `EN`: `Wet Cocoa Beans`); `/` (`HTTP 200`), `/assets/env.js` (`HTTP 200` con variables renderizadas por `envsubst`), `certs` (`HTTP 200`). |
| **Módulo 02 Onboarding Empresa + Acopio** | **PASS (`exit 0`)** | `POST /api/company/create` (`id=1`), `ACTIVATE_COMPANY` (`OK`), mezcla JSONB `||` (`6` banderas), `PUT /api/chain/facility` (`id=1`) con `facilityLocation` y traducciones `ES`/`EN`. |
| **Módulo 03 Compra `PESOLIBRA` + QR Público + Rate-Limit** | **PASS (`exit 0`)** | Productor (`id=1`) + Parcela (`20.00 qq`), compra `105 lb - 5 lb = 100.00 lb` (`deliveryReceipt: "0001"`, `status: ACTIVE`). Consulta pública sin login `/api/public/delivery-receipt/1` -> `HTTP 200` (`pricePerUnit` y `cost` ausentes, teléfono/correo del productor omitidos). Prueba de ráfaga en Nginx: 10 respuestas `200` seguidas de bloqueo `HTTP 429`. |
| **Módulo 05 Respaldo Automatizado** | **PASS (`exit 0`)** | Ejecución literal de `backup-inatrace.sh` generó `inatrace_core_*.sql.gz` (`36K`), `inatrace_keycloak_*.sql.gz` (`59K`) e `inatrace_files_*.tar.gz` (`158B`), los 3 validados con `gzip -t`. |

---

## 3. Verificación de Destrucción de Recursos GCP

Tras concluir la prueba se ejecutó la eliminación completa en `ai-lab-sandbox-514619`:

- Instancia `inatrace-clean-test-vm` (con `--delete-disks=all`): eliminada.
- Regla de firewall temporal `inatrace-manual-test-http-https`: eliminada.
- Verificación posterior (`instances list`, `disks list`, `addresses list`, `firewall-rules list`): `0` instancias, `0` discos, `0` direcciones estáticas y únicamente las `4` reglas por defecto originales de VPC.

---

## 4. Segunda Validación en Vivo: Tema Visual Keycloak `inatrace`, Redirección Canónica `redirect_uri` y Renovación TLS (`inatrace-preview-vm`)

Tras detectar en navegador un error `Invalid parameter: redirect_uri` al ingresar por la IP desnuda sin el dominio registrado en Keycloak —junto con la pantalla de inicio de sesión genérica de Keycloak— se ejecutó una segunda instancia limpia (`inatrace-preview-vm`, `us-central1-a`, IP efímera `34.133.96.158`, dominio TLS `34.133.96.158.sslip.io`) para verificar los ajustes definitivos de Nginx y Keycloak 26:

1. **Causa raíz de `Invalid parameter: redirect_uri`:** El frontend Angular calcula `APP_BASE_HREF` usando `/${LanguageCodeHelper.getCurrentLocale()}/` (`/es/` por defecto en `app.module.ts`), enviando a Keycloak `redirect_uri=https://<host-activo>/es/`. Al entrar por `https://34.133.96.158`, ese origen difería de `https://34.133.96.158.sslip.io/*` en el cliente `inatrace-frontend`.
2. **Solución verificada en Nginx:** Se incorporó `if ($host != $server_name) { return 301 https://$server_name$request_uri; }` en el bloque HTTPS de [`nginx-inatrace.verificado.conf`](./manuales/verificado/nginx-inatrace.verificado.conf) y en el Módulo 01 §7.4. Probado en vivo: `http://34.133.96.158/` y `https://34.133.96.158/` respondieron `HTTP 301` hacia `https://34.133.96.158.sslip.io/`.
3. **Plantilla visual oficial y flujo `inatrace-browser-flow`:** Se empaquetó [`verificado/keycloak-theme/inatrace/`](./manuales/verificado/keycloak-theme/inatrace/login/theme.properties) y se montó en solo lectura dentro de `/opt/keycloak/themes/inatrace`. Con `"loginTheme": "inatrace"` y `"browserFlow": "inatrace-browser-flow"` (clonado sin el subflujo *Organization Identity-First* de Keycloak 26), la página de login devolvió `<title>Bienvenido - INATrace</title>` (`HTTP 200`) y cargó `styles.css`, `landing-inatrace-logo.png` y `landing-background.jpg` con `HTTP 200`.
4. **Renovación automática TLS y acceso externo:** `sudo certbot renew --dry-run` finalizó con `Congratulations, all simulated renewals succeeded`. Las rutas externas `https://34.133.96.158.sslip.io/`, `/public/delivery-receipt/1` y `/api/public/delivery-receipt/1` respondieron `HTTP 200`.
5. **Destrucción de `inatrace-preview-vm`:** Eliminada la instancia con `--delete-disks=all` junto con la regla `inatrace-preview-http-https` en `ai-lab-sandbox-514619`; verificación posterior confirmó `0` instancias, `0` discos, `0` direcciones IP estáticas y únicamente las `4` reglas VPC por defecto.
