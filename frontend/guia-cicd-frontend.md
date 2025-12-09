# Guía CI/CD: Frontend INATrace

> **Audiencia**: DevOps, Desarrolladores Frontend  
> **Componente**: Frontend  
> **Última actualización**: Diciembre 2025

## Descripción General

El pipeline de CI/CD del frontend de INATrace automatiza la construcción, prueba y despliegue de la aplicación Angular. Utiliza **GitHub Actions** como orquestador principal, generando imágenes Docker optimizadas con Nginx para servir la aplicación de manera eficiente.

**Características principales**:
- **Construcción Docker Multi-Stage**: Imagen final ligera basada en Alpine Linux.
- **Entornos Dinámicos**: Soporte para Preproducción (Staging) y Producción.
- **Configuración Runtime**: Inyección de variables de entorno (API URL, Tema) al iniciar el contenedor, sin recompilar.
- **Verificación de Calidad**: Linting y Pruebas Unitarias (Headless Chrome).
- **Despliegue Sin Caída**: Uso de `docker-compose` con recreación orquestada.
- **Workflows Separados por Producto**: Pipelines independientes para cada empresa/organización.

---

## Flujo del Pipeline

```mermaid
graph TD
    Start[Push] --> Preflight[🔐 Check Credentials]
    Preflight --> Quality[🧪 Lint & Test]
    Quality --> Build[🏗️ Build Docker Image]
    Build --> Push[📤 Push to GHCR]
    Push --> Deploy[🚀 Deploy Remote]
    
    subgraph "Build Stage"
        Node[Node 14 Build]
        Nginx[Nginx Alpine Image]
    end
    
    subgraph "Deploy Stage"
        SCP[Copy Configs]
        SSH[Remote Commands]
        Health[Health Check Loop]
    end
```

---

## Requisitos Previos

### Entorno de Construcción
- Node.js 14 (definido en `env.NODE_VERSION`).
- Docker Buildx habilitado.

### Entorno de Despliegue (Servidor)
- Docker Engine y Docker Compose.
- Puerto HTTP expuesto (típicamente 80 o mapeado vía proxy reverso).
- Acceso SSH para el usuario de despliegue.

---

## Arquitectura de Workflows Separados (Diciembre 2025)

A partir de diciembre 2025, el frontend utiliza **workflows independientes por producto/empresa**, siguiendo mejores prácticas de DevOps para aislamiento de fallos y ciclos de release independientes.

### Estructura de Workflows

```
fe/.github/workflows/
├── deploy-frontend-develop.yml      # 🚀 Development (todos los productos)
├── deploy-frontend-{empresa1}.yml   # 🍫 Empresa 1 - staging + production
├── deploy-frontend-{empresa2}.yml   # 🦐 Empresa 2 - staging + production
└── (Jenkinsfile)                    # 🏛️ Alternativa Jenkins (si aplica)
```

### Flujo de Despliegue por Branch

| Branch | Workflow | Empresa | Ambiente |
|--------|----------|---------|----------|
| `develop` | `deploy-frontend-develop.yml` | (Desarrollo) | Dev todos los productos |
| `staging` | `deploy-frontend-{empresa}.yml` | Empresa X | Staging |
| `main` | `deploy-frontend-{empresa}.yml` | Empresa X | Production |

> **Nota**: Algunas organizaciones pueden usar Jenkins u otro CI/CD en lugar de GitHub Actions.

### Beneficios de la Separación

| Aspecto | Beneficio |
|---------|-----------|
| **Aislamiento** | Un fallo en Empresa A no afecta a Empresa B |
| **Releases independientes** | Cada empresa tiene su propio calendario |
| **Trazabilidad** | Historial y logs separados por producto |
| **Escalabilidad** | Agregar empresa = crear nuevo workflow |

---

## Configuración del Workflow

Cada workflow sigue la misma estructura: `quality` → `build` → `deploy-staging` → `deploy-production`.

### Variables de Entorno Clave

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `NODE_VERSION` | Versión de Node para build | `14` |
| `REGISTRY` | Registro de imágenes | `ghcr.io` |
| `HEALTH_MAX_RETRIES` | Intentos de healthcheck | `12` |

### Entornos Definidos

1. **Producción (`main`)**
   - Rama: `main`
   - URL API: Producción (`https://inatrace.example.com/api`)
   - Tag Docker: `latest`

2. **Preproducción (`staging`)**
   - Rama: `staging`
   - URL API: Test (`https://test-api.example.com/api`)
   - Tag Docker: `test-[commit-hash]`

---

## Proceso de Construcción (Docker)

El `Dockerfile` utiliza un enfoque de múltiples etapas para minimizar el tamaño de la imagen:

### Etapa 1: Build (Node.js)
1. Instala dependencias (`npm install`).
2. Ejecuta el build de Angular en modo producción (`npm run build:prod`).
3. Genera los artefactos estáticos en `dist/`.

### Etapa 2: Runtime (Nginx)
1. Parte de `nginx:alpine`.
2. Copia los artefactos desde la Etapa 1.
3. Copia la configuración personalizada de Nginx (`nginx.conf`).
4. Exponé el puerto 80.

---

## Configuración en Tiempo de Ejecución (Runtime)

A diferencia de las apps Angular tradicionales que "queman" la configuración en el build, INATrace utiliza un archivo `assets/env.js` que se genera o reemplaza al iniciar el contenedor.

Esto permite usar **la misma imagen Docker** para diferentes entornos (Dev, Test, Prod) o diferentes cadenas (Cacao, Camarón).

**Script de entrada (`remote-deploy.sh`)**:
```bash
# El pipeline inyecta estas variables en el archivo .env del servidor
echo "window.env = {" > assets/env.js
echo "  apiUrl: '${API_URL}'," >> assets/env.js
echo "  companyTheme: '${COMPANY_THEME}'," >> assets/env.js
echo "};" >> assets/env.js
```

---

## Estrategia de Despliegue Remoto

El pipeline ejecuta los siguientes pasos en el servidor destino:

1. **Transferencia de Archivos**:
   - `docker-compose.yml`: Definición del servicio.
   - `nginx.conf`: Configuración del servidor web.
   - `.env`: Variables específicas del despliegue actual.
   - `remote-deploy.sh`: Script orquestador.

2. **Ejecución Remota**:
   - Crea redes Docker si no existen (`inatrace-frontend-network`).
   - Descarga la imagen actualizada (`docker compose pull`).
   - Recrea el contenedor (`docker compose up -d --force-recreate`).

3. **Verificación (Healthcheck)**:
   - Realiza peticiones `curl` internas o externas al endpoint de salud.
   - Si falla tras N intentos, el pipeline marca error y muestra logs.

---

## Plantillas estándar para secrets y despliegue multi‑empresa

La configuración de secretos y despliegue por empresa en el frontend está alineada con las plantillas generales utilizadas en el backend:

- La **lista neutralizada de secrets** para todos los entornos se documenta en `../despliegue/variables-secrets-template.md`. La convención actual es:
  - Staging: `TEST_{COMPANY}_HOST`, `TEST_{COMPANY}_USER`, `TEST_{COMPANY}_PASSWORD`, `TEST_{COMPANY}_PORT`
  - Production: `PROD_{COMPANY}_HOST`, `PROD_{COMPANY}_USER`, `PROD_{COMPANY}_SSH_KEY`, `PROD_{COMPANY}_PORT`
- La estructura de **workflows separados por empresa** (ej: `deploy-frontend-{empresa}.yml`) se describe en `../despliegue/plantilla-workflow-frontend-empresa.md`.

De este modo, la documentación de frontend mantiene la misma línea que la del backend: una sola matriz de variables sensibles y un conjunto de plantillas estándar que pueden adaptarse a cualquier organización que opere INATrace.

---

## Troubleshooting

### Error: `node-sass` en Build
**Síntoma**: Fallo en `npm install` relacionado con bindings.
**Causa**: Incompatibilidad de versión Node.
**Solución**: El pipeline fuerza el uso de `node:14-alpine`. Asegurarse de no actualizar Node sin probar compatibilidad de `node-sass`.

### Error: Healthcheck Timeout
**Síntoma**: El despliegue finaliza con error tras esperar.
**Causa**: Nginx no arranca o configuración SSL inválida.
**Acción**:
1. Revisar logs: `docker logs inatrace-fe-prod --tail 50`.
2. Verificar sintaxis de `nginx.conf`.

### Error: Pantalla Blanca (Runtime Error)
**Síntoma**: La app carga pero se queda en blanco.
**Causa**: Error en `env.js` (sintaxis) o fallo de conexión API.
**Acción**: Abrir consola del navegador (F12) y verificar si `window.env` está definido correctamente.

---

## Recursos Adicionales

- [Ficha Técnica Frontend](./ficha-tecnica-frontend.md)
- [Configuración de Temas](./configuracion-temas.md)
- [Repositorio Frontend](https://github.com/Atijaguar-ec/fe)

---

## Recursos Adicionales sobre CI/CD

- [Cambios CI/CD Diciembre 2025](../../docs/cambios/2025-12-08-cicd-workflows-separados-por-producto.md) - Detalle completo de la reestructuración
- [Análisis CI/CD](../../docs/tecnico/analisis-despliegue-ci-cd.md) - Documentación técnica completa

---

**Última actualización**: Diciembre 2025
