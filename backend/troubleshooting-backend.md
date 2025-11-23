# Troubleshooting Backend INATrace

Esta guía recoge los problemas más frecuentes en el backend de INATrace y cómo diagnosticarlos de forma sistemática.

Para el flujo completo de despliegue consulta también:

- [Guía CI/CD Backend](./guia-cicd-backend.md)
- [Ficha Técnica Backend](./ficha-tecnica-backend.md)
- [Modelo de Datos](../base-datos/modelo-datos.md)

---

## 1. Metodología general de diagnóstico

1. **Revisar el estado del servicio**
   - Probar el endpoint de salud (ajustar dominio según entorno):
     - `https://backend.example.com/api/health`
   - Si no responde o devuelve error, continuar con pasos siguientes.

2. **Inspeccionar logs de aplicación**
   - En el servidor, obtener los últimos logs del contenedor:
     - `docker logs inatrace-be --tail 200`
   - Buscar excepciones de base de datos, credenciales o configuración.

3. **Verificar variables de entorno**
   - Confirmar que el contenedor se arranca con el `.env` esperado.
   - Revisar especialmente:
     - Credenciales de BD (`DATASOURCE_*`, `*_DB_ROOT_PASSWORD`).
     - Variables de correo (`*_MAIL_*`).
     - URLs de frontend (`*_FE_URL`, `*_FE_CONFIRM_URL`, `*_FE_RESET_URL`).

4. **Validar conectividad a base de datos**
   - Desde el contenedor o servidor:
     - `mysql -h <host> -u <user> -p` (según configuración).
   - Comprobar que la base de datos de la empresa existe y es accesible.

---

## 2. Problemas en despliegues con GitHub Actions

Esta sección complementa el apartado de troubleshooting de la [Guía CI/CD Backend](./guia-cicd-backend.md).

### 2.1 El workflow no se dispara

**Síntomas**

- No aparece ningún pipeline nuevo tras hacer `push`.

**Posibles causas y acciones**

- La rama no coincide con las configuradas en el workflow (`develop`, `staging`, `main`).
  - Verificar sección `on.push.branches` en `backend/.github/workflows/deploy-backend.yml`.
- Los cambios no afectan a las rutas observadas.
  - Confirmar que hubo cambios en `backend/**` o en el propio workflow.

### 2.2 Fallos en el job de build/test

**Síntomas**

- El job de calidad o build falla antes de desplegar.

**Posibles causas y acciones**

- Tests de integración fallan por falta de datos o configuración.
  - Revisar logs de Maven (tests) y ajustar datos de prueba o configuración.
- Dependencias no resueltas o vulnerabilidades críticas.
  - Revisar gestión de dependencias y excepciones en el log.

### 2.3 Error "Health check failed" tras despliegue

**Síntomas**

- El job de despliegue termina con mensaje de health check fallido.

**Posibles causas y acciones**

- La aplicación tarda más de lo esperado en arrancar.
  - Revisar logs para ver si hay migraciones lentas o timeouts.
- Problemas de conexión a base de datos.
  - Confirmar que las credenciales `STAGE_{COMPANY}_*` o `PROD_{COMPANY}_*` son correctas.
- Configuración incorrecta de puertos.
  - Verificar `*_SERVER_PORT` y que el `docker-compose.yml` mapea correctamente el puerto interno.

---

## 3. Problemas en despliegues con Jenkins

En entornos on-premise donde se utiliza Jenkins, la lógica de despliegue es análoga a GitHub Actions pero orquestada desde un `Jenkinsfile`.

### 3.1 Fallo en etapas iniciales (checkout, build)

**Síntomas**

- El pipeline se detiene en las primeras etapas.

**Posibles causas y acciones**

- Credenciales de Git inválidas o expiradas.
  - Revisar credenciales configuradas en Jenkins para acceso al repositorio.
- Falta de herramientas en el agente (Java, Maven, Docker).
  - Verificar instalación en el nodo Jenkins siguiendo la guía interna de instalación.

### 3.2 Fallos relacionados con `.env` o credenciales

**Síntomas**

- La aplicación arranca pero falla rápidamente por variables faltantes.

**Posibles causas y acciones**

- Fichero `.env` incompleto o credenciales desactualizadas.
  - Revisar las credenciales tipo "secret file" asociadas al proyecto en Jenkins.
  - Asegurar que el `.env` contiene al menos las variables críticas documentadas en `../despliegue/variables-secrets-template.md`.

### 3.3 Problemas en el backup de base de datos

**Síntomas**

- La etapa de backup falla y bloquea el despliegue a producción.

**Posibles causas y acciones**

- Usuario de backup sin permisos suficientes.
  - Revisar permisos del usuario configurado para dumps.
- Espacio insuficiente en disco.
  - Comprobar espacio disponible en la ruta configurada para backups.

---

## 4. Base de datos, migraciones y modelo de datos

### 4.1 Migraciones que fallan al arrancar la aplicación

**Síntomas**

- La aplicación no arranca y los logs muestran errores de migración (por ejemplo, en tablas como `product_type` u otras).

**Acciones recomendadas**

1. Revisar el historial de migraciones aplicadas en la base de datos.
2. Comparar con las migraciones definidas en el código fuente.
3. Consultar la [Guía de Migraciones](../base-datos/migraciones.md) para la política recomendada (por ejemplo, uso de `INSERT IGNORE`).

### 4.2 Inconsistencias de datos

**Síntomas**

- Errores 500 al consultar entidades concretas o reportes.

**Acciones recomendadas**

1. Validar integridad referencial (FK) en las tablas clave.
2. Revisar índices y constraints siguiendo el modelo descrito en el [Modelo de Datos](../base-datos/modelo-datos.md).

---

## 5. Rendimiento y tiempos de respuesta

### 5.1 Consultas lentas o timeouts

**Síntomas**

- Paneles de trazabilidad o listados tardan varios segundos en cargar.

**Acciones recomendadas**

1. Identificar las consultas más lentas (por ejemplo, revisando logs de slow queries en MySQL).
2. Comprobar que existen los índices propuestos en la documentación técnica de base de datos.
3. Revisar configuración de particionamiento e índices según la guía de rendimiento.

---

## 6. Cuándo escalar al equipo de desarrollo

Escala el incidente al equipo de desarrollo cuando:

- Tras seguir esta guía, el problema persiste y no se identifica claramente la causa raíz.
- Existen errores lógicos en la aplicación (por ejemplo, cálculos incorrectos o reglas de negocio mal aplicadas).
- Se requieren cambios en el modelo de datos o en las migraciones para resolver el problema.

Al escalar, es recomendable incluir:

- Descripción breve del problema y entorno afectado (dev, staging, prod).
- Últimos logs relevantes del backend.
- Capturas de pantalla o ejemplos de peticiones fallidas.
- Pasos ya realizados siguiendo esta guía.
