# Artefactos Verificados en Producción Limpia (`docs/manuales/verificado/`)

Este directorio contiene las plantillas de infraestructura, base de datos y marca institucional **validadas empíricamente** en instancias limpias de Ubuntu 24.04 LTS desde la rama `main` de INATrace (véase [`informe-prueba-gcp-vm-limpia-2026-11-16.md`](../../informe-prueba-gcp-vm-limpia-2026-11-16.md)).

## Contenido del Paquete

| Artefacto | Propósito Operativo | Cómo se Usa en el Manual |
|---|---|---|
| [`docker-compose.verificado.yml`](./docker-compose.verificado.yml) | Orquestación de los 4 servicios (`inatrace-postgres`, `inatrace-keycloak`, `inatrace-backend`, `inatrace-frontend`) en `127.0.0.1`, con carga de archivos `50MB`, `?type=`, rutas `/es/` de correo, `INATRACE_KEYCLOAK_ADMIN_CLIENT_SECRET` y montaje del tema `keycloak-theme/inatrace`. | Base de referencia para `/opt/inatrace/docker-compose.yml` ([Módulo 01 §6.2](../01-manual-instalacion-despliegue.md)). |
| [`nginx-inatrace.verificado.conf`](./nginx-inatrace.verificado.conf) | Proxy inverso TLS con redirección canónica `301` (`$host != $server_name` hacia `$server_name`, evitando errores `Invalid parameter: redirect_uri`), soporte de `limit_req` y enrutamiento SPA/API/Auth. | Copiar a `/etc/nginx/sites-available/inatrace` reemplazando `trazabilidad.mi-cooperativa.org` ([Módulo 01 §7.4](../01-manual-instalacion-despliegue.md)). |
| [`nginx-http-limit_req_zone.conf`](./nginx-http-limit_req_zone.conf) | Define la zona `limit_req_zone $binary_remote_addr zone=inatrace_public:10m rate=20r/m;` exigida por `nginx-inatrace.verificado.conf`. | Instalar en `/etc/nginx/conf.d/inatrace-ratelimit.conf` antes de recargar Nginx ([Módulo 01 §7.3](../01-manual-instalacion-despliegue.md)). |
| [`primer-admin.sql`](./primer-admin.sql) | Script SQL idempotente para promover al usuario `admin@mi-cooperativa.org` a `ACTIVE` y `SYSTEM_ADMIN` en la tabla `"User"` cuando aún no existe otro administrador o SMTP activo. | Ejecutar sobre `inatrace_core` tras registrar el usuario en Keycloak/API ([Módulo 01 §9.2](../01-manual-instalacion-despliegue.md)). |
| [`keycloak-theme/inatrace/`](./keycloak-theme/inatrace/login/theme.properties) | Plantilla visual oficial INATrace para Keycloak 26 (`theme.properties`, `login.ftl`, `login-reset-password.ftl`, `login-update-password.ftl`, `styles.css`, `landing-inatrace-logo.png`, `landing-background.jpg`). | Copiar a `/opt/inatrace/keycloak-theme/inatrace` y seleccionar `loginTheme: inatrace` en el realm ([Módulo 01 §5.2](../01-manual-instalacion-despliegue.md) y §9.1). |

## Comprobación Rápida Antes de Desplegar

```bash
cd /opt/inatrace
docker compose config -q && echo "COMPOSE_OK"
sudo nginx -t
```
