# Configuración del Backend

> **Audiencia**: DevOps, Desarrolladores Backend, SysAdmins  
> **Componente**: Backend  
> **Última actualización**: Noviembre 2025

Este documento detalla todas las variables de entorno y configuraciones necesarias para ejecutar el backend de INATrace en diferentes entornos (Desarrollo, Testing, Producción).

---

## 1. Variables de Entorno (Formato `.env`)

El sistema utiliza un archivo `.env` o variables del sistema operativo para configurar la conexión a base de datos, servicios de correo, seguridad y servicios externos.

### Base de Datos (MySQL)

| Variable | Requerido | Descripción | Ejemplo |
|----------|-----------|-------------|---------|
| `INATrace_DB_HOST` | ✅ | Hostname o IP del servidor MySQL | `localhost` o `mysql` |
| `INATrace_DB_PORT` | ✅ | Puerto de conexión | `3306` |
| `INATrace_DB_NAME` | ✅ | Nombre de la base de datos | `inatrace` |
| `INATrace_DB_USERNAME` | ✅ | Usuario de aplicación | `inatrace_user` |
| `INATrace_DB_PASSWORD` | ✅ | Contraseña del usuario | `(secreto)` |
| `INATrace_DB_ROOT_PASSWORD`| ⚠️ | Password root (solo para init) | `(secreto)` |

### Seguridad y JWT

| Variable | Requerido | Descripción | Ejemplo |
|----------|-----------|-------------|---------|
| `INATrace_JWT_SECRET` | ✅ | Clave secreta para firmar tokens | `long-random-string-256bit` |
| `INATrace_REQUEST_LOG_TOKEN` | ❌ | Token para proteger log requests | `internal-token` |

### Servidor de Correo (SMTP)

Configuración necesaria para registro de usuarios y notificaciones.

| Variable | Requerido | Descripción | Ejemplo Gmail |
|----------|-----------|-------------|---------------|
| `INATrace_SMTP_HOST` | ✅ | Servidor SMTP | `smtp.gmail.com` |
| `INATrace_SMTP_PORT` | ✅ | Puerto SMTP | `587` |
| `INATrace_SMTP_USERNAME` | ✅ | Usuario/Email de envío | `notificaciones@example.com` |
| `INATrace_SMTP_PASSWORD` | ✅ | Contraseña o App Password | `(secreto)` |
| `INATrace_SMTP_AUTH` | ❌ | Habilitar autenticación | `true` |
| `INATrace_SMTP_STARTTLS` | ❌ | Habilitar StartTLS | `true` |

### Integraciones Externas

| Variable | Requerido | Descripción |
|----------|-----------|-------------|
| `INATrace_EXCHANGE_RATE_API_KEY` | ❌ | Key de [exchangeratesapi.io](https://exchangeratesapi.io/) para monedas |
| `INATrace_MAPBOX_TOKEN` | ❌ | Token para servicios de mapas (si aplica) |

---

## 2. Perfiles de Spring (Profiles)

Spring Boot permite cargar configuraciones específicas según el entorno activo.

**Activar perfil**:
```bash
java -jar -Dspring.profiles.active=prod backend.jar
```

| Perfil | Uso Recomendado | Características |
|--------|-----------------|-----------------|
| `dev` | Desarrollo local | Logs DEBUG, H2 console habilitada, cors laxo |
| `test` | Pruebas automáticas | Base de datos en memoria, mocks de email |
| `prod` | Producción | Logs INFO/ERROR, caché activada, seguridad estricta |

---

## 3. Configuración `application.yml`

El archivo `src/main/resources/application.yml` contiene la configuración base. Se recomienda no modificarlo directamente, sino sobreescribir valores usando variables de entorno.

**Estructura base**:

```yaml
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: INATrace Backend
  
  datasource:
    url: jdbc:mysql://${INATrace_DB_HOST}:${INATrace_DB_PORT}/${INATrace_DB_NAME}?useSSL=false&allowPublicKeyRetrieval=true
    username: ${INATrace_DB_USERNAME}
    password: ${INATrace_DB_PASSWORD}

  jpa:
    open-in-view: false
    hibernate:
      ddl-auto: validate # Flyway gestiona el esquema

  flyway:
    enabled: true
    baseline-on-migrate: true

inatrace:
  security:
    jwt-secret: ${INATrace_JWT_SECRET}
    token-expiration: 3600 # 1 hora
```

---

## 4. Configuración Docker Compose

Ejemplo de servicio backend en `docker-compose.yml`:

```yaml
version: '3.8'

services:
  backend:
    image: ghcr.io/org/backend:latest
    container_name: inatrace-backend
    restart: always
    ports:
      - "8080:8080"
    environment:
      - SPRING_PROFILES_ACTIVE=prod
      - INATrace_DB_HOST=mysql
      - INATrace_DB_PORT=3306
      - INATrace_DB_NAME=inatrace
      - INATrace_DB_USERNAME=inatrace
      - INATrace_DB_PASSWORD=${DB_PASSWORD}
      - INATrace_JWT_SECRET=${JWT_SECRET}
    depends_on:
      - mysql
    networks:
      - inatrace-network
```

---

## 5. Secretos en Producción

> 🔐 **Seguridad Crítica**: Nunca almacenar contraseñas en texto plano en el repositorio.

**Recomendaciones**:
1. Usar **GitHub Secrets** para inyectar valores durante el CI/CD.
2. Usar **Docker Secrets** o variables de entorno en el servidor.
3. Rotar las claves JWT y contraseñas de base de datos periódicamente.

---

**Última actualización**: Noviembre 2025
