# Plantilla Neutral de Secrets GitHub · INATrace

> **Uso:** Copiar esta tabla, rellenar la columna "Valor empresa" y luego crear los secrets con esos nombres en GitHub (`Settings → Secrets and variables → Actions`).
>
> **Convención recomendada:**
> - Backend: `DEV_*`, `STAGE_{COMPANY}_*`, `PROD_{COMPANY}_*`
> - Frontend: `DEV_*` (reutiliza los mismos de backend) y `STAGE_FE_{COMPANY}_*`, `PROD_FE_{COMPANY}_*` para el acceso SSH.

---

## 1. Backend – Entorno DEV (rama `develop`)

| Secret | Descripción | Obligatorio | Valor empresa |
|--------|-------------|------------|---------------|
| `DEV_HOST` | Host/IP servidor dev | ✅ | |
| `DEV_PORT` | Puerto SSH (ej. 22) | ⚠️ | |
| `DEV_USER` | Usuario SSH (ej. `inatrace`) | ✅ | |
| `DEV_SSH_KEY` \| `DEV_PASSWORD` | Clave privada o password SSH | ✅ | |
| `DEV_DB_ROOT_PASSWORD` | Password usuario `root` MySQL | ✅ | |
| `DEV_DATASOURCE_USERNAME` | Usuario BD app (ej. `inatrace`) | ⚠️ | |
| `DEV_DATASOURCE_PASSWORD` | Password usuario BD app | ✅ | |
| `DEV_REQUESTLOG_TOKEN` | Token para logs públicos | ⚠️ | |
| `DEV_EXCHANGERATE_APIKEY` | API key tipo de cambio (si aplica) | ⚠️ | |
| `DEV_AGSTACK_EMAIL` | Usuario/Email AgStack | ⚠️ | |
| `DEV_AGSTACK_PASSWORD` | Password/Token AgStack | ⚠️ | |

**SMTP DEV (correo):**

| Secret | Descripción | Obligatorio | Valor empresa |
|--------|-------------|------------|---------------|
| `DEV_MAIL_HOST` | Host SMTP | ⚠️ | |
| `DEV_MAIL_PORT` | Puerto SMTP | ⚠️ | |
| `DEV_MAIL_USERNAME` | Usuario/Email emisor | ⚠️ | |
| `DEV_MAIL_PASSWORD` | Password SMTP | ✅* | |
| `DEV_MAIL_TEMPLATE_FROM` | Remitente por defecto | ⚠️ | |
| `DEV_MAIL_REDIRECT` | Redirección de correos (QA) | ⚠️ | |
| `DEV_MAIL_SENDING_ENABLED` | `true/false` envío real | ⚠️ | |

**URLs usadas en correos:**

| Secret | Descripción | Obligatorio | Valor empresa |
|--------|-------------|------------|---------------|
| `DEV_FE_URL` | URL base frontend dev | ⚠️ | |
| `DEV_FE_CONFIRM_URL` | URL confirmación email | ⚠️ | |
| `DEV_FE_RESET_URL` | URL reset password | ⚠️ | |

---

## 2. Backend – Entorno STAGING (rama `staging`)

Para cada empresa define un **código corto**, por ejemplo `COMPANY1`, `COMPANY2`. Sustituye `{COMPANY}` por ese código.

### 2.1 Acceso servidor + BD por empresa

| Secret (patrón) | Descripción | Obligatorio | Valor `{COMPANY}` |
|-----------------|-------------|------------|-------------------|
| `STAGE_{COMPANY}_HOST` | Host/IP backend staging | ✅ | |
| `STAGE_{COMPANY}_PORT` | Puerto SSH | ⚠️ | |
| `STAGE_{COMPANY}_USER` | Usuario SSH | ✅ | |
| `STAGE_{COMPANY}_SSH_KEY` \| `STAGE_{COMPANY}_PASSWORD` | Clave o password SSH | ✅ | |
| `STAGE_{COMPANY}_DB_ROOT_PASSWORD` | Password `root` MySQL | ✅ | |
| `STAGE_{COMPANY}_DATASOURCE_USERNAME` | Usuario BD app | ⚠️ | |
| `STAGE_{COMPANY}_DATASOURCE_PASSWORD` | Password usuario BD | ✅ | |
| `STAGE_{COMPANY}_REQUESTLOG_TOKEN` | Token logs | ⚠️ | |
| `STAGE_{COMPANY}_EXCHANGERATE_APIKEY` | API key tipo de cambio | ⚠️ | |
| `STAGE_{COMPANY}_AGSTACK_EMAIL` | Usuario AgStack | ⚠️ | |
| `STAGE_{COMPANY}_AGSTACK_PASSWORD` | Password/Token AgStack | ⚠️ | |
| `STAGE_{COMPANY}_SERVER_PORT` | Puerto HTTP backend (ej. 8080) | ⚠️ | |

### 2.2 SMTP STAGING por empresa

| Secret (patrón) | Descripción | Obligatorio | Valor `{COMPANY}` |
|-----------------|-------------|------------|-------------------|
| `STAGE_{COMPANY}_MAIL_HOST` | Host SMTP | ⚠️ | |
| `STAGE_{COMPANY}_MAIL_PORT` | Puerto SMTP | ⚠️ | |
| `STAGE_{COMPANY}_MAIL_USERNAME` | Usuario/Email emisor | ⚠️ | |
| `STAGE_{COMPANY}_MAIL_PASSWORD` | Password SMTP | ✅* | |
| `STAGE_{COMPANY}_MAIL_TEMPLATE_FROM` | Remitente por defecto | ⚠️ | |
| `STAGE_{COMPANY}_MAIL_REDIRECT` | Redirección general | ⚠️ | |
| `STAGE_{COMPANY}_MAIL_SENDING_ENABLED` | `true/false` envío real | ⚠️ | |

### 2.3 Usuario administrador inicial (opcional)

| Secret (patrón) | Descripción | Obligatorio | Valor `{COMPANY}` |
|-----------------|-------------|------------|-------------------|
| `STAGE_{COMPANY}_ADMIN_EMAIL` | Email admin inicial | ⚠️ | |
| `STAGE_{COMPANY}_ADMIN_PASSWORD` | Password inicial | ⚠️ | |
| `STAGE_{COMPANY}_ADMIN_NAME` | Nombre | ⚠️ | |
| `STAGE_{COMPANY}_ADMIN_SURNAME` | Apellido | ⚠️ | |
| `STAGE_{COMPANY}_ADMIN_COMPANY_NAME` | Nombre visible empresa | ⚠️ | |

---

## 3. Backend – Entorno PROD (rama `main`)

Mismo patrón que STAGING, cambiando el prefijo a `PROD_`.

| Secret (patrón) | Descripción | Obligatorio | Valor `{COMPANY}` |
|-----------------|-------------|------------|-------------------|
| `PROD_{COMPANY}_HOST` | Host/IP backend producción | ✅ | |
| `PROD_{COMPANY}_PORT` | Puerto SSH | ⚠️ | |
| `PROD_{COMPANY}_USER` | Usuario SSH | ✅ | |
| `PROD_{COMPANY}_SSH_KEY` \| `PROD_{COMPANY}_PASSWORD` | Clave o password SSH | ✅ | |
| `PROD_{COMPANY}_DB_ROOT_PASSWORD` | Password `root` MySQL | ✅ | |
| `PROD_{COMPANY}_DATASOURCE_USERNAME` | Usuario BD app | ⚠️ | |
| `PROD_{COMPANY}_DATASOURCE_PASSWORD` | Password usuario BD | ✅ | |
| `PROD_{COMPANY}_REQUESTLOG_TOKEN` | Token logs | ⚠️ | |
| `PROD_{COMPANY}_EXCHANGERATE_APIKEY` | API key tipo de cambio | ⚠️ | |
| `PROD_{COMPANY}_AGSTACK_EMAIL` | Usuario AgStack prod | ⚠️ | |
| `PROD_{COMPANY}_AGSTACK_PASSWORD` | Password/Token AgStack prod | ⚠️ | |

*(SMTP y admin inicial pueden seguir el mismo patrón que en STAGING cambiando `STAGE_` por `PROD_`.)*

---

## 4. Frontend – Secrets por entorno

El frontend reutiliza los mismos secrets SSH que el backend más algunos específicos por empresa.

### 4.1 DEV (cacao y camarón)

Reutiliza:

- `DEV_HOST`, `DEV_USER`, `DEV_SSH_KEY`, `DEV_SSH_FINGERPRINT` (si se usa huella) para acceso al servidor de desarrollo.

### 4.2 STAGING Frontend por empresa

Prefijo recomendado: `STAGE_FE_{COMPANY}_*`.

| Secret (patrón) | Descripción | Obligatorio | Valor `{COMPANY}` |
|-----------------|-------------|------------|-------------------|
| `STAGE_FE_{COMPANY}_HOST` | Host/IP servidor frontend staging | ✅ | |
| `STAGE_FE_{COMPANY}_PORT` | Puerto SSH | ⚠️ | |
| `STAGE_FE_{COMPANY}_USER` | Usuario SSH | ✅ | |
| `STAGE_FE_{COMPANY}_SSH_KEY` \| `STAGE_FE_{COMPANY}_PASSWORD` | Clave o password SSH | ✅ | |

### 4.3 PROD Frontend por empresa

Prefijo recomendado: `PROD_FE_{COMPANY}_*`.

| Secret (patrón) | Descripción | Obligatorio | Valor `{COMPANY}` |
|-----------------|-------------|------------|-------------------|
| `PROD_FE_{COMPANY}_HOST` | Host/IP servidor frontend producción | ✅ | |
| `PROD_FE_{COMPANY}_PORT` | Puerto SSH | ⚠️ | |
| `PROD_FE_{COMPANY}_USER` | Usuario SSH | ✅ | |
| `PROD_FE_{COMPANY}_SSH_KEY` \| `PROD_FE_{COMPANY}_PASSWORD` | Clave o password SSH | ✅ | |

---

## 5. Notas finales

- Usa esta plantilla como **checklist**; adapta nombres de secrets a tus workflows o viceversa.
- Evita guardar valores reales en el repositorio: solo en **GitHub Secrets**.
- Para multi‑empresa, duplica las filas de `{COMPANY}` una por cada cliente (ej. `COMPANY1`, `COMPANY2`).

---

## 6. Ejemplo orientativo con empresa ficticia `AGROEC`

Esta sección muestra, únicamente a modo de ejemplo, cómo se vería la configuración de nombres de secrets para una empresa ficticia **AGROEC** con dominio público `www.agroec.com` (dominio base `agroec.com`).  
No se proporcionan valores reales, solo la convención de nombres recomendada.

### 6.1 Backend – AGROEC

#### 6.1.1 Staging (`STAGE_AGROEC_*`)

| Secret | Descripción resumida |
|--------|----------------------|
| `STAGE_AGROEC_HOST` | Host/IP del servidor backend de staging de AGROEC |
| `STAGE_AGROEC_PORT` | Puerto SSH (por defecto `22`) |
| `STAGE_AGROEC_USER` | Usuario Linux para acceso SSH |
| `STAGE_AGROEC_SSH_KEY` \| `STAGE_AGROEC_PASSWORD` | Clave privada o password SSH |
| `STAGE_AGROEC_DB_ROOT_PASSWORD` | Password del usuario `root` de MySQL |
| `STAGE_AGROEC_DATASOURCE_USERNAME` | Usuario de base de datos de la aplicación |
| `STAGE_AGROEC_DATASOURCE_PASSWORD` | Password del usuario de base de datos |
| `STAGE_AGROEC_REQUESTLOG_TOKEN` | Token para endpoints de logs (opcional) |
| `STAGE_AGROEC_EXCHANGERATE_APIKEY` | API key para servicio de tipo de cambio (opcional) |
| `STAGE_AGROEC_AGSTACK_EMAIL` | Usuario/Email para integración AgStack en staging |
| `STAGE_AGROEC_AGSTACK_PASSWORD` | Password/Token AgStack en staging |
| `STAGE_AGROEC_SERVER_PORT` | Puerto HTTP interno del backend (ej. `8080`) |

**Correo y enlaces frontend (staging):**

| Secret | Descripción resumida |
|--------|----------------------|
| `STAGE_AGROEC_MAIL_HOST` | Host SMTP de AGROEC |
| `STAGE_AGROEC_MAIL_PORT` | Puerto SMTP |
| `STAGE_AGROEC_MAIL_USERNAME` | Usuario/Email emisor |
| `STAGE_AGROEC_MAIL_PASSWORD` | Password o App Password SMTP |
| `STAGE_AGROEC_MAIL_TEMPLATE_FROM` | Remitente por defecto en correos |
| `STAGE_AGROEC_MAIL_REDIRECT` | Email de redirección de correos (QA) |
| `STAGE_AGROEC_MAIL_SENDING_ENABLED` | Habilitar envío real (`true/false`) |
| `STAGE_AGROEC_FE_URL` | URL base del frontend de staging (ej. `https://frontend-test.agroec.com`) |
| `STAGE_AGROEC_FE_CONFIRM_URL` | URL de confirmación de email |
| `STAGE_AGROEC_FE_RESET_URL` | URL de reseteo de contraseña |

**Usuario administrador inicial (staging):**

| Secret | Descripción resumida |
|--------|----------------------|
| `STAGE_AGROEC_ADMIN_EMAIL` | Email del usuario administrador inicial |
| `STAGE_AGROEC_ADMIN_PASSWORD` | Password inicial del administrador |
| `STAGE_AGROEC_ADMIN_NAME` | Nombre del administrador |
| `STAGE_AGROEC_ADMIN_SURNAME` | Apellido del administrador |
| `STAGE_AGROEC_ADMIN_COMPANY_NAME` | Nombre visible de la empresa en la interfaz |

#### 6.1.2 Producción (`PROD_AGROEC_*`)

| Secret | Descripción resumida |
|--------|----------------------|
| `PROD_AGROEC_HOST` | Host/IP del servidor backend de producción de AGROEC |
| `PROD_AGROEC_PORT` | Puerto SSH |
| `PROD_AGROEC_USER` | Usuario Linux para acceso SSH |
| `PROD_AGROEC_SSH_KEY` \| `PROD_AGROEC_PASSWORD` | Clave privada o password SSH |
| `PROD_AGROEC_DB_ROOT_PASSWORD` | Password del usuario `root` de MySQL |
| `PROD_AGROEC_DATASOURCE_USERNAME` | Usuario de base de datos de la aplicación |
| `PROD_AGROEC_DATASOURCE_PASSWORD` | Password del usuario de base de datos |
| `PROD_AGROEC_REQUESTLOG_TOKEN` | Token de logs en producción (opcional) |
| `PROD_AGROEC_EXCHANGERATE_APIKEY` | API key de tipo de cambio en producción (opcional) |
| `PROD_AGROEC_AGSTACK_EMAIL` | Usuario AgStack en producción |
| `PROD_AGROEC_AGSTACK_PASSWORD` | Password/Token AgStack en producción |

**Correo y usuario administrador (producción):**

| Secret | Descripción resumida |
|--------|----------------------|
| `PROD_AGROEC_MAIL_PASSWORD` | Password o App Password SMTP usado en producción |
| `PROD_AGROEC_ADMIN_EMAIL` | Email del administrador principal en producción |
| `PROD_AGROEC_ADMIN_PASSWORD` | Password del administrador en producción |
| `PROD_AGROEC_ADMIN_NAME` | Nombre del administrador |
| `PROD_AGROEC_ADMIN_SURNAME` | Apellido del administrador |
| `PROD_AGROEC_ADMIN_COMPANY_NAME` | Nombre comercial de la empresa para producción |

### 6.2 Frontend – AGROEC

#### 6.2.1 Staging (`STAGE_FE_AGROEC_*`)

| Secret | Descripción resumida |
|--------|----------------------|
| `STAGE_FE_AGROEC_HOST` | Host/IP del servidor frontend de staging |
| `STAGE_FE_AGROEC_PORT` | Puerto SSH |
| `STAGE_FE_AGROEC_USER` | Usuario SSH para despliegue frontend |
| `STAGE_FE_AGROEC_SSH_KEY` \| `STAGE_FE_AGROEC_PASSWORD` | Clave o password SSH para frontend |

El `.env` generado por el workflow podría incluir, entre otros:

- `DOMAIN=frontend-test.agroec.com`  
- `COMPANY_NAME=AGROEC`  
- `COMPANY_THEME=cacao` (u otro tema que se defina)  

#### 6.2.2 Producción (`PROD_FE_AGROEC_*`)

| Secret | Descripción resumida |
|--------|----------------------|
| `PROD_FE_AGROEC_HOST` | Host/IP del servidor frontend de producción |
| `PROD_FE_AGROEC_PORT` | Puerto SSH |
| `PROD_FE_AGROEC_USER` | Usuario SSH para despliegue frontend |
| `PROD_FE_AGROEC_SSH_KEY` \| `PROD_FE_AGROEC_PASSWORD` | Clave o password SSH para frontend |

En producción, el `.env` de ejemplo suele utilizar un dominio de negocio, por ejemplo:

- `DOMAIN=frontend.agroec.com`  
- `API_BASE_URL=http://inatrace-be-agroec:8080`

> Este ejemplo no debe copiarse literalmente con valores reales, sino adaptarse a la realidad de cada organización manteniendo la misma estructura de nombres.

