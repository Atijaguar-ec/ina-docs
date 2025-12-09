# Plantilla de workflow backend por empresa (staging + prod)

> **Última actualización**: Diciembre 2025

## ⚠️ Nueva Arquitectura (Diciembre 2025)

A partir de diciembre 2025, el backend utiliza **workflows completamente separados por empresa**:

```
backend/.github/workflows/
├── deploy-backend-develop.yml    # 🚀 Development (Cacao + Shrimp)
├── deploy-backend-{empresa1}.yml # 🍫 Empresa 1 - staging + production
├── deploy-backend-{empresa2}.yml # 🦐 Empresa 2 - staging + production
└── (Jenkinsfile)                 # 🏛️ Alternativa Jenkins (si aplica)
```

### Agregar Nueva Empresa

Para agregar una nueva empresa (ej: `NEWCO`):

1. **Copiar** un workflow existente como `deploy-backend-newco.yml`
2. **Reemplazar** en todo el archivo:
   - `{EMPRESA_EXISTENTE}` → `NEWCO`
   - `{empresa_existente}` → `newco`
   - `empresa-existente.com` → `newco.com`
3. **Crear secrets** en GitHub con la convención `TEST_*` y `PROD_*`:
   - **Staging SSH**: `TEST_NEWCO_HOST`, `TEST_NEWCO_USER`, `TEST_NEWCO_PASSWORD`
   - **Staging BD**: `TEST_NEWCO_DB_ROOT_PASSWORD`, `TEST_NEWCO_DATASOURCE_PASSWORD`
   - **Production SSH**: `PROD_NEWCO_HOST`, `PROD_NEWCO_USER`, `PROD_NEWCO_SSH_KEY`
   - **Production BD**: `PROD_NEWCO_DB_ROOT_PASSWORD`, `PROD_NEWCO_DATASOURCE_PASSWORD`
4. **Crear environments** en GitHub: `newco-staging`, `newco-production`

---

## Documentación Legacy

La información a continuación describe el enfoque anterior basado en jobs dentro de un workflow monolítico. Se mantiene como referencia.

---

## Enfoque Legacy (Archivo Monolítico)

> ⚠️ **NOTA**: El código legacy a continuación usa `STAGE_` como prefijo. La convención actual es `TEST_` para staging.
> Si usas este código, reemplaza `STAGE_` por `TEST_` para mantener consistencia.

Esta plantilla está basada en el antiguo `backend/.github/workflows/deploy-backend.yml` y servía para crear **jobs de despliegue por empresa** dentro de un solo archivo.

> **Convención actual de secrets**: `TEST_{COMPANY_CODE}_*` para staging, `PROD_{COMPANY_CODE}_*` para producción.

---

## 1. Placeholders usados en la plantilla

En el snippet YAML de abajo, sustituye:

- `{COMPANY_CODE}` → código interno de la empresa (ej.: `AGROEC`).
- `{company_code}` → el mismo código pero en minúsculas (ej.: `agroec`).
- `{company-domain}` → dominio público de la empresa (ej.: `backend-test.company.com`).

Puedes copiar el bloque YAML, pegarlo en tu workflow backend y luego hacer **buscar/reemplazar** de estos tokens.

---

## 2. Snippet YAML de plantilla por empresa

```yaml
# Jobs de despliegue backend para una empresa específica
# Sustituir {COMPANY_CODE}, {company_code} y {company-domain}

jobs:
  deploy-stage-{company_code}:
    name: Deploy Backend to {COMPANY_CODE} Staging
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/staging'
    environment:
      name: stage-{company_code}
      url: https://backend-stage.{company-domain}

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Contexto de despliegue
        run: |
          echo "Commit: $GITHUB_SHA"
          echo "Branch: $GITHUB_REF"
          echo "Workflow run: $GITHUB_RUN_ID"
          echo "Job: $GITHUB_JOB"

      - name: Preflight - validar secrets requeridos ({COMPANY_CODE} staging)
        run: |
          missing=0
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_HOST }}" ] && echo "Missing secret: STAGE_{COMPANY_CODE}_HOST" && missing=1
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_USER }}" ] && echo "Missing secret: STAGE_{COMPANY_CODE}_USER" && missing=1
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_PASSWORD }}" ] && echo "Missing secret: STAGE_{COMPANY_CODE}_PASSWORD" && missing=1
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_DB_ROOT_PASSWORD }}" ] && echo "Missing secret: STAGE_{COMPANY_CODE}_DB_ROOT_PASSWORD" && missing=1
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_DATASOURCE_PASSWORD }}" ] && echo "Missing secret: STAGE_{COMPANY_CODE}_DATASOURCE_PASSWORD" && missing=1
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_MAIL_PASSWORD }}" ] && echo "Missing secret: STAGE_{COMPANY_CODE}_MAIL_PASSWORD" && missing=1
          # Opcionales: se usan defaults si faltan
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_REQUESTLOG_TOKEN }}" ] && echo "Warning: Missing secret: STAGE_{COMPANY_CODE}_REQUESTLOG_TOKEN (will use default)"
          [ -z "${{ secrets.STAGE_{COMPANY_CODE}_EXCHANGERATE_APIKEY }}" ] && echo "Warning: Missing secret: STAGE_{COMPANY_CODE}_EXCHANGERATE_APIKEY (will use default)"
          if [ "$missing" -ne 0 ]; then exit 1; fi

      - name: Ensure remote directory exists ({COMPANY_CODE} staging)
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.STAGE_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.STAGE_{COMPANY_CODE}_USER }}
          password: ${{ secrets.STAGE_{COMPANY_CODE}_PASSWORD }}
          script: |
            sudo mkdir -p /opt/inatrace/backend/test/{company_code}
            sudo chown -R $USER:$USER /opt/inatrace/backend/test/{company_code}
            sudo chmod -R 755 /opt/inatrace/backend/test/{company_code}

      - name: Upload unified docker-compose.yml ({COMPANY_CODE} staging)
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.STAGE_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.STAGE_{COMPANY_CODE}_USER }}
          password: ${{ secrets.STAGE_{COMPANY_CODE}_PASSWORD }}
          source: "ci/docker-compose.yml"
          target: "/opt/inatrace/backend/test/{company_code}/"
          strip_components: 1

      - name: Prepare .env from template ({COMPANY_CODE} staging)
        run: |
          IMAGE="${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}"
          IMAGE=$(echo "$IMAGE" | tr '[:upper:]' '[:lower:]')
          TAG="${{ needs.build.outputs.image-tag }}"

          DB_USER="${{ secrets.STAGE_{COMPANY_CODE}_DATASOURCE_USERNAME }}"; [ -z "$DB_USER" ] && DB_USER="inatrace_stage_{company_code}"
          REQ_TOKEN="${{ secrets.STAGE_{COMPANY_CODE}_REQUESTLOG_TOKEN }}"; [ -z "$REQ_TOKEN" ] && REQ_TOKEN="placeholder-requestlog-${GITHUB_RUN_ID}"
          EXR_KEY="${{ secrets.STAGE_{COMPANY_CODE}_EXCHANGERATE_APIKEY }}"; [ -z "$EXR_KEY" ] && EXR_KEY="dummy-stage-key"

          FE_URL="${{ secrets.STAGE_{COMPANY_CODE}_FE_URL }}"; [ -z "$FE_URL" ] && FE_URL="https://frontend-stage.{company-domain}"
          FE_CONFIRM_URL="${{ secrets.STAGE_{COMPANY_CODE}_FE_CONFIRM_URL }}"; [ -z "$FE_CONFIRM_URL" ] && FE_CONFIRM_URL="${FE_URL%/}/confirm-email/"
          FE_RESET_URL="${{ secrets.STAGE_{COMPANY_CODE}_FE_RESET_URL }}"; [ -z "$FE_RESET_URL" ] && FE_RESET_URL="${FE_URL%/}/reset-password/"
          SERVER_PORT="${{ secrets.STAGE_{COMPANY_CODE}_SERVER_PORT }}"; [ -z "$SERVER_PORT" ] && SERVER_PORT="8080"

          MAIL_HOST="${{ secrets.STAGE_{COMPANY_CODE}_MAIL_HOST }}"; [ -z "$MAIL_HOST" ] && MAIL_HOST="mail.example.com"
          MAIL_PORT="${{ secrets.STAGE_{COMPANY_CODE}_MAIL_PORT }}"; [ -z "$MAIL_PORT" ] && MAIL_PORT="465"
          MAIL_USERNAME="${{ secrets.STAGE_{COMPANY_CODE}_MAIL_USERNAME }}"; [ -z "$MAIL_USERNAME" ] && MAIL_USERNAME="notificaciones@{company-domain}"
          MAIL_PASSWORD="${{ secrets.STAGE_{COMPANY_CODE}_MAIL_PASSWORD }}"
          MAIL_TEMPLATE_FROM="${{ secrets.STAGE_{COMPANY_CODE}_MAIL_TEMPLATE_FROM }}"; [ -z "$MAIL_TEMPLATE_FROM" ] && MAIL_TEMPLATE_FROM="no-reply@{company-domain}"
          MAIL_REDIRECT="${{ secrets.STAGE_{COMPANY_CODE}_MAIL_REDIRECT }}"; [ -z "$MAIL_REDIRECT" ] && MAIL_REDIRECT="qa@{company-domain}"
          MAIL_SENDING_ENABLED="${{ secrets.STAGE_{COMPANY_CODE}_MAIL_SENDING_ENABLED }}"; [ -z "$MAIL_SENDING_ENABLED" ] && MAIL_SENDING_ENABLED="true"

          cat > .env <<EOF
          IMAGE_NAME=$IMAGE
          TAG=$TAG
          DATABASE_NAME=inatrace_test_{company_code}
          DB_ROOT_PASSWORD=${{ secrets.STAGE_{COMPANY_CODE}_DB_ROOT_PASSWORD }}
          DATASOURCE_USERNAME=$DB_USER
          DATASOURCE_PASSWORD=${{ secrets.STAGE_{COMPANY_CODE}_DATASOURCE_PASSWORD }}
          CONTAINER_NAME_BE=inatrace-be-test-{company_code}
          CONTAINER_NAME_DB=inatrace-mysql-test-{company_code}
          HOST_PORT_BE=$SERVER_PORT
          HOST_PORT_DB=3306

          FILE_STORAGE_ROOT=/opt/inatrace/uploads
          IMPORT_PATH=/opt/inatrace/import
          DOCUMENTS_ROOT=/opt/inatrace/documents
          FILE_STORAGE_ROOT_VOL=/opt/inatrace/uploads
          IMPORT_PATH_VOL=/opt/inatrace/imports
          DOCUMENTS_ROOT_VOL=/opt/inatrace/documents
          DB_VOLUME=/opt/inatrace/mysql

          REQUESTLOG_TOKEN=$REQ_TOKEN
          EXCHANGERATE_APIKEY=$EXR_KEY

          FE_URL=$FE_URL
          FE_CONFIRM_URL=$FE_CONFIRM_URL
          FE_RESET_URL=$FE_RESET_URL

          SPRING_MAIL_HOST=$MAIL_HOST
          SPRING_MAIL_PORT=$MAIL_PORT
          SPRING_MAIL_USERNAME=$MAIL_USERNAME
          SPRING_MAIL_PASSWORD=$MAIL_PASSWORD
          INATRACE_MAIL_TEMPLATE_FROM=$MAIL_TEMPLATE_FROM
          INATRACE_MAIL_REDIRECT=$MAIL_REDIRECT
          INATRACE_MAIL_SENDING_ENABLED=$MAIL_SENDING_ENABLED
          EOF

      - name: Upload .env ({COMPANY_CODE} staging)
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.STAGE_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.STAGE_{COMPANY_CODE}_USER }}
          password: ${{ secrets.STAGE_{COMPANY_CODE}_PASSWORD }}
          source: ".env"
          target: "/opt/inatrace/backend/test/{company_code}/"

      - name: Download backend image artifact ({COMPANY_CODE} staging)
        uses: actions/download-artifact@v4
        with:
          name: be-image
          path: .

      - name: Verify backend image artifact ({COMPANY_CODE} staging)
        run: |
          set -e
          ls -lah .
          [ -f be-image.tar ] || { echo "❌ be-image.tar not found"; exit 1; }

      - name: Upload image tar ({COMPANY_CODE} staging)
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.STAGE_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.STAGE_{COMPANY_CODE}_USER }}
          password: ${{ secrets.STAGE_{COMPANY_CODE}_PASSWORD }}
          source: "be-image.tar"
          target: "/opt/inatrace/backend/test/{company_code}"

      - name: Deploy on server ({COMPANY_CODE} staging)
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.STAGE_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.STAGE_{COMPANY_CODE}_USER }}
          password: ${{ secrets.STAGE_{COMPANY_CODE}_PASSWORD }}
          script: |
            set -e
            cd /opt/inatrace/backend/test/{company_code}

            echo "🔗 Ensuring Docker network exists..."
            docker network inspect inatrace-backend-network >/dev/null 2>&1 || docker network create inatrace-backend-network

            echo "📦 Loading backend image..."
            docker load -i be-image.tar

            echo "🛑 Stopping existing backend container if running"
            docker stop inatrace-be-test-{company_code} >/dev/null 2>&1 || true
            docker rm inatrace-be-test-{company_code} >/dev/null 2>&1 || true

            echo "🚀 Recreating backend service"
            docker-compose up -d --no-deps --force-recreate backend

            echo "⏳ Waiting for backend to be healthy..."
            for i in {1..12}; do
              sleep 10
              if curl -fsS "http://localhost:$SERVER_PORT/actuator/health" >/dev/null; then
                echo "✅ Backend staging deployment healthy ({COMPANY_CODE})"
                exit 0
              fi
              echo "⏳ Health check attempt $i/12..."
            done

            echo "❌ Backend health check failed" && exit 1


  deploy-prod-{company_code}:
    name: Deploy Backend to {COMPANY_CODE} Production
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment:
      name: prod-{company_code}
      url: https://backend.{company-domain}

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Contexto de despliegue
        run: |
          echo "Commit: $GITHUB_SHA"
          echo "Branch: $GITHUB_REF"
          echo "Workflow run: $GITHUB_RUN_ID"
          echo "Job: $GITHUB_JOB"

      - name: Preflight - validar secrets requeridos ({COMPANY_CODE} prod)
        run: |
          missing=0
          [ -z "${{ secrets.PROD_{COMPANY_CODE}_HOST }}" ] && echo "Missing secret: PROD_{COMPANY_CODE}_HOST" && missing=1
          [ -z "${{ secrets.PROD_{COMPANY_CODE}_USER }}" ] && echo "Missing secret: PROD_{COMPANY_CODE}_USER" && missing=1
          [ -z "${{ secrets.PROD_{COMPANY_CODE}_PASSWORD }}" ] && echo "Missing secret: PROD_{COMPANY_CODE}_PASSWORD" && missing=1
          [ -z "${{ secrets.PROD_{COMPANY_CODE}_DB_ROOT_PASSWORD }}" ] && echo "Missing secret: PROD_{COMPANY_CODE}_DB_ROOT_PASSWORD" && missing=1
          [ -z "${{ secrets.PROD_{COMPANY_CODE}_DATASOURCE_PASSWORD }}" ] && echo "Missing secret: PROD_{COMPANY_CODE}_DATASOURCE_PASSWORD" && missing=1
          [ -z "${{ secrets.PROD_{COMPANY_CODE}_MAIL_PASSWORD }}" ] && echo "Missing secret: PROD_{COMPANY_CODE}_MAIL_PASSWORD" && missing=1
          if [ "$missing" -ne 0 ]; then exit 1; fi

      - name: Ensure remote directory exists ({COMPANY_CODE} prod)
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.PROD_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.PROD_{COMPANY_CODE}_USER }}
          password: ${{ secrets.PROD_{COMPANY_CODE}_PASSWORD }}
          script: |
            mkdir -p /opt/inatrace/deploy/backend/prod/{company_code}

      - name: Upload docker-compose.yml ({COMPANY_CODE} prod)
        if: ${{ hashFiles('deploy/backend/prod/{company_code}/docker-compose.yml') != '' }}
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.PROD_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.PROD_{COMPANY_CODE}_USER }}
          password: ${{ secrets.PROD_{COMPANY_CODE}_PASSWORD }}
          source: "deploy/backend/prod/{company_code}/docker-compose.yml"
          target: "/opt/inatrace/deploy/backend/prod/{company_code}"
          debug: true

      - name: Prepare .env ({COMPANY_CODE} prod)
        run: |
          IMAGE="${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}"; IMAGE=$(echo "$IMAGE" | tr '[:upper:]' '[:lower:]')
          DB_USER="${{ secrets.PROD_{COMPANY_CODE}_DATASOURCE_USERNAME }}"; [ -z "$DB_USER" ] && DB_USER="inatrace_prod_{company_code}"
          REQ_TOKEN="${{ secrets.PROD_{COMPANY_CODE}_REQUESTLOG_TOKEN }}"; [ -z "$REQ_TOKEN" ] && REQ_TOKEN="placeholder-requestlog-${GITHUB_RUN_ID}"
          EXR_KEY="${{ secrets.PROD_{COMPANY_CODE}_EXCHANGERATE_APIKEY }}"; [ -z "$EXR_KEY" ] && EXR_KEY="dummy-prod-key"

          ADMIN_EMAIL="${{ secrets.PROD_{COMPANY_CODE}_ADMIN_EMAIL }}"; [ -z "$ADMIN_EMAIL" ] && ADMIN_EMAIL="admin.{company_code}@{company-domain}"
          ADMIN_PASSWORD="${{ secrets.PROD_{COMPANY_CODE}_ADMIN_PASSWORD }}"; [ -z "$ADMIN_PASSWORD" ] && ADMIN_PASSWORD="Admin123!"
          ADMIN_NAME="${{ secrets.PROD_{COMPANY_CODE}_ADMIN_NAME }}"; [ -z "$ADMIN_NAME" ] && ADMIN_NAME="Admin"
          ADMIN_SURNAME="${{ secrets.PROD_{COMPANY_CODE}_ADMIN_SURNAME }}"; [ -z "$ADMIN_SURNAME" ] && ADMIN_SURNAME="{COMPANY_CODE}"
          ADMIN_COMPANY_NAME="${{ secrets.PROD_{COMPANY_CODE}_ADMIN_COMPANY_NAME }}"; [ -z "$ADMIN_COMPANY_NAME" ] && ADMIN_COMPANY_NAME="{COMPANY_CODE}"

          cat > .env <<EOF
          IMAGE_NAME=$IMAGE
          TAG=latest
          DATABASE_NAME=inatrace_prod_{company_code}
          DB_ROOT_PASSWORD=${{ secrets.PROD_{COMPANY_CODE}_DB_ROOT_PASSWORD }}
          DATASOURCE_USERNAME=$DB_USER
          DATASOURCE_PASSWORD=${{ secrets.PROD_{COMPANY_CODE}_DATASOURCE_PASSWORD }}

          FILE_STORAGE_ROOT=/opt/inatrace/uploads
          IMPORT_PATH=/opt/inatrace/import
          DOCUMENTS_ROOT=/opt/inatrace/documents

          REQUESTLOG_TOKEN=$REQ_TOKEN
          EXCHANGERATE_APIKEY=$EXR_KEY

          MAIL_HOST=mail.example.com
          MAIL_PORT=465
          MAIL_USERNAME=notificaciones@{company-domain}
          MAIL_PASSWORD=${{ secrets.PROD_{COMPANY_CODE}_MAIL_PASSWORD }}

          INATRACE_ADMIN_EMAIL=$ADMIN_EMAIL
          INATRACE_ADMIN_PASSWORD=$ADMIN_PASSWORD
          INATRACE_ADMIN_NAME=$ADMIN_NAME
          INATRACE_ADMIN_SURNAME=$ADMIN_SURNAME
          INATRACE_ADMIN_COMPANY_NAME=$ADMIN_COMPANY_NAME
          EOF

      - name: Upload .env ({COMPANY_CODE} prod)
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.PROD_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.PROD_{COMPANY_CODE}_USER }}
          password: ${{ secrets.PROD_{COMPANY_CODE}_PASSWORD }}
          source: ".env"
          target: "/opt/inatrace/deploy/backend/prod/{company_code}"
          debug: true

      - name: Download backend image artifact ({COMPANY_CODE} prod)
        uses: actions/download-artifact@v4
        with:
          name: be-image
          path: .

      - name: Verify backend image artifact ({COMPANY_CODE} prod)
        run: |
          set -e
          ls -lah .
          [ -f be-image.tar ] || { echo "❌ be-image.tar not found"; exit 1; }

      - name: Upload image tar ({COMPANY_CODE} prod)
        uses: appleboy/scp-action@v0.1.7
        with:
          host: ${{ secrets.PROD_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.PROD_{COMPANY_CODE}_USER }}
          password: ${{ secrets.PROD_{COMPANY_CODE}_PASSWORD }}
          source: "be-image.tar"
          target: "/opt/inatrace/deploy/backend/prod/{company_code}"
          debug: true

      - name: Pre-deploy DB backup ({COMPANY_CODE} prod)
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.PROD_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.PROD_{COMPANY_CODE}_USER }}
          password: ${{ secrets.PROD_{COMPANY_CODE}_PASSWORD }}
          script: |
            set -e
            CN=inatrace-mysql-prod-{company_code}
            if docker ps -a --format '{{.Names}}' | grep -q "^$CN$"; then
              echo "Running DB backup inside $CN..."
              docker exec "$CN" sh -lc 'BACKUP_NAME=/backups/backup-$(date +%Y%m%d-%H%M%S).sql.gz; mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" | gzip -9 > "$BACKUP_NAME" && echo "Backup written to $BACKUP_NAME" || echo "Backup failed"'
              docker exec "$CN" sh -lc 'find /backups -name "backup-*.sql.gz" -mtime +14 -delete'
            else
              echo "MySQL container $CN not found; skipping backup"
            fi

      - name: Deploy on server ({COMPANY_CODE} prod)
        uses: appleboy/ssh-action@v1.0.0
        with:
          host: ${{ secrets.PROD_{COMPANY_CODE}_HOST }}
          username: ${{ secrets.PROD_{COMPANY_CODE}_USER }}
          password: ${{ secrets.PROD_{COMPANY_CODE}_PASSWORD }}
          script: |
            set -e
            cd /opt/inatrace/deploy/backend/prod/{company_code}

            docker network inspect inatrace-backend-{company_code}-network >/dev/null 2>&1 || docker network create inatrace-backend-{company_code}-network

            docker load -i be-image.tar
            docker-compose pull || true
            docker-compose up -d --remove-orphans

            for i in {1..12}; do
              sleep 10
              if curl -fsS "https://backend.{company-domain}/api/actuator/health" >/dev/null; then
                echo "✅ Backend production deployment healthy ({COMPANY_CODE})"
                exit 0
              fi
              echo "⏳ Waiting for backend to become healthy ($i/12)"
            done

            echo "❌ Backend health check failed" && exit 1
```

---

## 3. Cómo usar esta plantilla

1. Copia el bloque `jobs:` de arriba.
2. Pégalo en tu `backend/.github/workflows/deploy-backend.yml` (o en un nuevo workflow backend) debajo de los jobs existentes.
3. Haz **buscar/reemplazar**:
   - `{COMPANY_CODE}` → por ejemplo `AGROEC`.
   - `{company_code}` → `agroec`.
   - `{company-domain}` → dominio de backend/empresa, por ejemplo `empresax.example.com`.
4. Crea los **secrets** indicados en la plantilla (`STAGE_{COMPANY_CODE}_*` y `PROD_{COMPANY_CODE}_*`) usando la plantilla de secrets que ya definimos.
5. Haz un push a la rama `staging` o `main` y verifica que se disparan los jobs nuevos de staging/prod para esa empresa.

---

## 4. Ejemplo orientativo con empresa ficticia `AGROEC`

Este ejemplo ilustra, de forma neutral y profesional, cómo aplicar la plantilla anterior para una empresa ficticia denominada **AGROEC**, con dominio público `www.agroec.com`.

### 4.1. Decisiones de nomenclatura

Para AGROEC se recomienda fijar explícitamente:

- `COMPANY_CODE` → `AGROEC`  
- `company_code` → `agroec`  
- `company-domain` → `agroec.com`  

Con estas decisiones, la plantilla generará identificadores consistentes, por ejemplo:

- Jobs: `deploy-stage-agroec`, `deploy-prod-agroec`.  
- Environments de GitHub: `stage-agroec`, `prod-agroec`.  
- Bases de datos: `inatrace_test_agroec`, `inatrace_prod_agroec`.  
- Redes Docker: `inatrace-backend-agroec-network`.  

### 4.2. Aplicación de la plantilla en el workflow backend

Pasos recomendados para el equipo DevOps de la empresa que vaya a operar INATrace:

1. Abrir el fichero de workflow backend existente, por ejemplo `backend/.github/workflows/deploy-backend.yml`.
2. Copiar el bloque `jobs:` de la sección 2 de esta guía y pegarlo **debajo** de los jobs ya definidos.
3. Ejecutar en el editor un **buscar/reemplazar global** en el nuevo bloque:
   - Reemplazar `{COMPANY_CODE}` → `AGROEC`.
   - Reemplazar `{company_code}` → `agroec`.
   - Reemplazar `{company-domain}` → `agroec.com`.
4. Guardar el fichero y revisar que los dos nuevos jobs han quedado definidos como:
   - `deploy-stage-agroec` (para rama `staging`).
   - `deploy-prod-agroec` (para rama `main`).
5. Configurar en GitHub los environments `stage-agroec` y `prod-agroec` con las URLs esperadas y las protecciones de despliegue requeridas (aprobaciones, branch protection, etc.).

### 4.3. Extracto de configuración resultante (ejemplo)

A modo ilustrativo, el encabezado de los jobs para AGROEC quedaría de la siguiente forma dentro del workflow backend (ejemplo simplificado, no exhaustivo):

```yaml
jobs:
  deploy-stage-agroec:
    name: Deploy Backend to AGROEC Staging
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/staging'
    environment:
      name: stage-agroec
      url: https://backend-stage.agroec.com

  deploy-prod-agroec:
    name: Deploy Backend to AGROEC Production
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment:
      name: prod-agroec
      url: https://backend.agroec.com
```

> **Nota:** El contenido completo de los jobs (pasos de SSH, copia de `docker-compose.yml`, generación de `.env`, backup de base de datos, etc.) se mantiene idéntico al de la plantilla genérica; únicamente cambian los identificadores y el dominio.
