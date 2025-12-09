# Plantilla de workflow frontend por empresa (staging/test + prod)

> **Última actualización**: Diciembre 2025

## ⚠️ Nuevo Enfoque: Workflows Separados por Empresa

A partir de **diciembre 2025**, se adoptó una arquitectura de **workflows independientes por empresa**, en lugar de un workflow monolítico con múltiples jobs.

### Estructura Actual

```
fe/.github/workflows/
├── deploy-frontend-develop.yml      # 🚀 Development (todos los productos)
├── deploy-frontend-{empresa1}.yml   # 🍫 Empresa 1 - staging + production
├── deploy-frontend-{empresa2}.yml   # 🦐 Empresa 2 - staging + production
└── (Jenkinsfile)                    # 🏛️ Alternativa Jenkins (si aplica)
```

### Beneficios del Nuevo Enfoque

| Antes (Monolítico) | Ahora (Separado) |
|-------------------|------------------|
| 1 workflow ~950 líneas | N workflows ~300 líneas c/u |
| Fallo en Empresa A afecta Empresa B | Pipelines 100% independientes |
| Logs mezclados | Historial claro por empresa |
| Difícil escalar | Nuevo workflow por empresa |

### Agregar Nueva Empresa

Para agregar una nueva empresa (ej: `NEWCO`):

1. **Copiar** un workflow existente como `deploy-frontend-newco.yml`
2. **Reemplazar** en todo el archivo:
   - `{EMPRESA_EXISTENTE}` → `NEWCO`
   - `{empresa_existente}` → `newco`
   - `empresa-existente.com` → `newco.com`
   - `{PRODUCT_TYPE}` → tipo de producto correspondiente (`COCOA`, `SHRIMP`, `COFFEE`)
3. **Crear secrets** en GitHub con la convención `TEST_*` y `PROD_*`:
   - Staging: `TEST_NEWCO_HOST`, `TEST_NEWCO_USER`, `TEST_NEWCO_PASSWORD`, `TEST_NEWCO_PORT`
   - Production: `PROD_NEWCO_HOST`, `PROD_NEWCO_USER`, `PROD_NEWCO_SSH_KEY`, `PROD_NEWCO_PORT`
4. **Crear environments** en GitHub: `newco-staging`, `newco-production`

---

## Documentación Legacy

La información a continuación describe el enfoque anterior basado en plantillas de jobs. Se mantiene como referencia para migraciones o casos especiales.

---

## Enfoque Legacy: Plantilla de Jobs por Empresa

Esta plantilla está basada en `fe/.github/workflows/deploy-frontend.yml` y en el archivo de ejemplo `fe/.github/workflows/deploy-frontend-company-template.yml`. 
Su objetivo es proporcionar un modelo **neutral y reutilizable** para definir jobs de despliegue de frontend **por empresa**, en los entornos **staging/test** y **producción**.

La idea general es:

- Mantener un workflow principal de frontend con los jobs de:
  - `quality` (linting y tests).
  - `build` (build y push de la imagen Docker del frontend).
- Añadir, por cada empresa, dos jobs de despliegue:
  - `deploy-test-<empresa>` (staging/test).
  - `deploy-prod-<empresa>` (producción).
- Cada job utiliza secrets específicos de esa empresa en GitHub (`STAGE_FE_{COMPANY}_*` y `PROD_FE_{COMPANY}_*`).

> **Convención recomendada para el código de empresa:** `COMPANY_CODE` en mayúsculas y sin espacios (ej.: `AGROEC`, `COFFEECO`, `CLIENTE1`).

---

## 1. Placeholders usados en la plantilla

En el template de workflow frontend por empresa se emplean los siguientes placeholders:

- `{COMPANY_CODE}` → código interno de la empresa en mayúsculas (ej.: `AGROEC`).
- `{company_code}` → el mismo código en minúsculas (ej.: `agroec`).
- `{company-domain}` → dominio público principal de la empresa (ej.: `agroec.com`).

La recomendación es copiar el bloque de jobs desde `deploy-frontend-company-template.yml`, pegarlo en el workflow real (`deploy-frontend.yml` o uno nuevo) y luego aplicar un **buscar/reemplazar** sobre estos tres placeholders.

---

## 2. Estructura general de la plantilla de jobs

La plantilla define, de forma genérica, dos jobs por empresa:

- `deploy-test-{company_code}`: despliegue del frontend a entorno de **staging/test** cuando la rama es `staging`.
- `deploy-prod-{company_code}`: despliegue del frontend a entorno de **producción** cuando la rama es `main`.

Ambos jobs asumen que:

- El job `build` ya ha construido y publicado la imagen Docker del frontend.
- Existe un artefacto de imagen (`fe-image` o `image.tar`) si el despliegue lo requiere.
- Se utilizan secrets SSH específicos por empresa por entorno:
  - Staging/test: `STAGE_FE_{COMPANY_CODE}_HOST`, `STAGE_FE_{COMPANY_CODE}_USER`, `STAGE_FE_{COMPANY_CODE}_SSH_KEY`, etc.
  - Producción: `PROD_FE_{COMPANY_CODE}_HOST`, `PROD_FE_{COMPANY_CODE}_USER`, `PROD_FE_{COMPANY_CODE}_SSH_KEY`, etc.

### 2.1. Job `deploy-test-{company_code}` (staging/test)

A alto nivel, este job realiza las siguientes tareas:

- Conecta por SSH al servidor de frontend de staging/test.
- Crea (si es necesario) el directorio remoto `/opt/inatrace/frontend/test/{company_code}`.
- Copia el archivo `ci/docker-compose.yml` y la configuración `nginx.conf` al servidor.
- Genera un fichero `.env` de entorno de test (variables como `DOMAIN`, `COMPANY_NAME`, `PRIMARY_PRODUCT_TYPE`, etc.).
- Sube el `.env` al servidor y ejecuta `docker compose` para reconstruir y levantar el servicio.
- Realiza una comprobación de salud (`/health`) para verificar que el despliegue se ha completado correctamente.

### 2.2. Job `deploy-prod-{company_code}` (producción)

De forma similar, este job:

- Conecta al servidor de producción de frontend.
- Verifica y sube el `docker-compose.yml` específico de la empresa (`deploy/frontend/prod/{company_code}/docker-compose.yml`).
- Descarga y sube la imagen del frontend (tar) al servidor.
- Genera un `.env` de producción con información mínima (por ejemplo, `DOMAIN` y `API_BASE_URL`).
- Ejecuta `docker compose` en el servidor remoto y valida que el endpoint de salud responde correctamente.

---

## 3. Cómo usar la plantilla de workflow frontend por empresa

1. Abrir el fichero `fe/.github/workflows/deploy-frontend-company-template.yml` en el repositorio.
2. Copiar los jobs `deploy-test-{company_code}` y `deploy-prod-{company_code}`.
3. Pegar dichos jobs en el workflow real (`fe/.github/workflows/deploy-frontend.yml`) o en un nuevo workflow de frontend.
4. Ejecutar un **buscar/reemplazar** en el nuevo bloque de jobs para sustituir:
   - `{COMPANY_CODE}` → código de la empresa en mayúsculas (p. ej., `AGROEC`).
   - `{company_code}` → el mismo código en minúsculas (`agroec`).
   - `{company-domain}` → dominio principal de la empresa (`agroec.com`).
5. Crear en GitHub los **secrets** indicados en la plantilla de secrets (`STAGE_FE_{COMPANY}_*` y `PROD_FE_{COMPANY}_*`) siguiendo la guía `ina-docs/despliegue/variables-secrets-template.md`.
6. Configurar los **environments** de GitHub correspondientes (ej.: `test-agroec`, `prod-agroec`) con las URLs y reglas de protección deseadas.
7. Hacer push a las ramas `staging` y `main` y verificar que los nuevos jobs aparecen y se ejecutan correctamente para la empresa configurada.

---

## 4. Ejemplo orientativo con empresa ficticia `AGROEC`

Este ejemplo muestra cómo aplicar la plantilla para una empresa ficticia **AGROEC**, con dominio público `www.agroec.com` (dominio base `agroec.com`).

### 4.1. Decisiones de nomenclatura para AGROEC

- `COMPANY_CODE` → `AGROEC`  
- `company_code` → `agroec`  
- `company-domain` → `agroec.com`  

Con estas decisiones, los identificadores típicos en el workflow de frontend serían:

- Jobs: `deploy-test-agroec`, `deploy-prod-agroec`.  
- Environments: `test-agroec`, `prod-agroec`.  
- Redes Docker: `inatrace-frontend-agroec-network`, `inatrace-backend-agroec-network`.  
- Dominios de ejemplo: `frontend-test.agroec.com` (staging) y `frontend.agroec.com` (producción).

### 4.2. Integración en el workflow `deploy-frontend.yml`

Pasos recomendados para el equipo que despliegue el frontend de AGROEC:

1. Abrir `fe/.github/workflows/deploy-frontend.yml`.
2. Copiar del archivo `deploy-frontend-company-template.yml` los jobs `deploy-test-{company_code}` y `deploy-prod-{company_code}`.
3. Pegarlos al final de la sección `jobs:` del workflow.
4. Ejecutar un buscar/reemplazar en el bloque recién pegado:
   - `{COMPANY_CODE}` → `AGROEC`.
   - `{company_code}` → `agroec`.
   - `{company-domain}` → `agroec.com`.
5. Crear los secrets de staging y producción específicos del frontend de AGROEC (`STAGE_FE_AGROEC_*` y `PROD_FE_AGROEC_*`) según las tablas de la plantilla de secrets.
6. Verificar que, tras hacer push a `staging` y `main`, aparecen los jobs:
   - `deploy-test-agroec` para la rama `staging`.
   - `deploy-prod-agroec` para la rama `main`.

### 4.3. Encabezado de los jobs de ejemplo (AGROEC)

A modo ilustrativo, el encabezado de los jobs instanciados para AGROEC podría tener esta forma dentro de `deploy-frontend.yml`:

```yaml
jobs:
  deploy-test-agroec:
    name: "🧪 Deploy to AGROEC Test"
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/staging'
    environment:
      name: test-agroec
      url: https://frontend-test.agroec.com

  deploy-prod-agroec:
    name: "🏭 Deploy to AGROEC Production"
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment:
      name: prod-agroec
      url: https://frontend.agroec.com
```

> **Nota:** El detalle interno de los pasos (SSH, copia de ficheros, generación de `.env`, ejecución de `docker compose`, chequeos de salud, etc.) permanece igual que en `deploy-frontend-company-template.yml`; únicamente cambian los identificadores y dominios específicos de la empresa.
