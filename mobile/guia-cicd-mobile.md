# Guía CI/CD Mobile INATrace

Esta guía describe el pipeline de integración y despliegue continuo (**CI/CD**) para la aplicación móvil de INATrace, utilizando:

- **GitHub Actions** para tests, auditorías y orquestación.
- **Expo Application Services (EAS)** para builds nativos (Android/iOS), distribución y actualizaciones OTA.

---

## 1. Arquitectura General del Pipeline

### 1.1 Flujo de alto nivel

1. `push` o `pull_request` en GitHub.
2. **Jobs de calidad**:
   - Linting, TypeScript check, tests unitarios.
   - Auditoría de dependencias y seguridad.
3. **Builds**:
   - Builds de **preview** para revisión (pull requests).
   - Builds de **producción** para Android/iOS (rama principal).
4. **Distribución**:
   - Publicación en tiendas (Play Store / App Store).
   - Actualizaciones OTA (Over-the-Air) cuando aplique.

### 1.2 Componentes Clave

- **GitHub Actions**: workflows YAML en `.github/workflows/`.
- **EAS Build**: servicio de builds en la nube.
- **EAS Submit**: envío automatizado a tiendas.
- **EAS Update**: actualizaciones OTA opcionales.

---

## 2. Configuración de GitHub Actions

### 2.1 Variables de entorno globales

Ejemplo conceptual para `mobile-ci-cd.yml`:

```yaml
env:
  NODE_VERSION: '18'
  EXPO_CLI_VERSION: 'latest'
```

### 2.2 Secrets requeridos en GitHub

Configurar en `Settings → Secrets and variables → Actions` del repositorio:

- `EXPO_TOKEN` → Token de acceso para EAS (cuenta de Expo).
- `EXPO_PUBLIC_API_URI` → URL base de la API (por ejemplo, `https://api.example.com/api/`).
- `EXPO_PUBLIC_API_TEST_URI` → URL de pruebas.
- `EXPO_PUBLIC_API_RW_URI` → URL de lecturas/escrituras si se separa tráfico.
- `EXPO_PUBLIC_DOCUMENTATION_URI` → URL de documentación (si se usa en la app).
- `EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN` → Token público de lectura de mapas (`pk...`).
- `RN_MAPBOX_MAPS_DOWNLOAD_TOKEN` → Token para descargas de mapas offline (`pk...`).
- Credenciales para distribución en tiendas (según plataforma):
  - `EXPO_APPLE_ID`, `EXPO_APPLE_APP_SPECIFIC_PASSWORD`.
  - Clave de servicio Google para Android (`EXPO_GOOGLE_SERVICE_ACCOUNT_KEY_PATH` u otra variable equivalente según configuración).

> **Importante:** No almacenar tokens reales en el repositorio. Solo en secrets de GitHub y/o variables de entorno de EAS.

---

## 3. Estructura típica del Workflow

### 3.1 Jobs principales (visión simplificada)

```yaml
name: Mobile CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

env:
  NODE_VERSION: '18'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      - run: npm ci
      - run: npx tsc --noEmit
      - run: npm run lint
      - run: npm test -- --watchAll=false

  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      - run: npm ci
      - run: npm audit --audit-level=high

  build-preview:
    needs: [test, security-scan]
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      - uses: expo/expo-github-action@v8
        with:
          expo-version: latest
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: npm ci
      - run: eas build --platform all --profile preview --non-interactive --no-wait

  build-production:
    needs: [test, security-scan]
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    strategy:
      matrix:
        platform: [android, ios]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      - uses: expo/expo-github-action@v8
        with:
          expo-version: latest
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      - run: npm ci
      - run: eas build --platform ${{ matrix.platform }} --profile production --non-interactive
        env:
          EXPO_PUBLIC_API_URI: ${{ secrets.EXPO_PUBLIC_API_URI }}
          EXPO_PUBLIC_API_TEST_URI: ${{ secrets.EXPO_PUBLIC_API_TEST_URI }}
          EXPO_PUBLIC_API_RW_URI: ${{ secrets.EXPO_PUBLIC_API_RW_URI }}
          EXPO_PUBLIC_DOCUMENTATION_URI: ${{ secrets.EXPO_PUBLIC_DOCUMENTATION_URI }}
          EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN: ${{ secrets.EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN }}
          RN_MAPBOX_MAPS_DOWNLOAD_TOKEN: ${{ secrets.RN_MAPBOX_MAPS_DOWNLOAD_TOKEN }}
```

> Este ejemplo es orientativo y debe adaptarse al workflow real del repositorio `mobile/`.

---

## 4. Variables de Entorno y `.env`

### 4.1 Desarrollo local

Para desarrollo local, se recomienda utilizar un fichero `.env` (o configuración equivalente) con, al menos:

- `EXPO_PUBLIC_API_URI=https://api.example.com/api/`
- `EXPO_PUBLIC_API_TEST_URI=https://api-test.example.com/api/`
- `EXPO_PUBLIC_API_RW_URI=https://api-rw.example.com/api/`
- `EXPO_PUBLIC_DOCUMENTATION_URI=https://docs.example.com`
- `EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN=pk.xxxxxxxx`
- `RN_MAPBOX_MAPS_DOWNLOAD_TOKEN=pk.xxxxxxxx`

### 4.2 Variables en Expo/EAS

En el panel de EAS o mediante CLI se deben definir las mismas variables para builds en la nube. Ejemplo CLI (conceptual):

```bash
eas env:create --name EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN --value pk.xxxxxxxx
eas env:create --name RN_MAPBOX_MAPS_DOWNLOAD_TOKEN --value pk.xxxxxxxx
```

> **Recomendación:** Usar un **único token público** con los permisos necesarios (lectura de estilos, tiles y descargas) para ambas variables, cuando sea posible.

---

## 5. Estrategia de Branching y Entornos

Una estrategia típica puede ser:

- `develop` → builds de desarrollo y OTA de pruebas.
- `main` → builds de producción y envío a tiendas.

Ejemplo conceptual para OTA:

```yaml
ota-update:
  needs: [test, security-scan]
  if: github.ref == 'refs/heads/develop'
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'
    - uses: expo/expo-github-action@v8
      with:
        expo-version: latest
        eas-version: latest
        token: ${{ secrets.EXPO_TOKEN }}
    - run: npm ci
    - run: eas update --branch development --message "OTA Update: ${{ github.sha }}"
      env:
        EXPO_PUBLIC_API_URI: ${{ secrets.EXPO_PUBLIC_API_URI }}
        EXPO_PUBLIC_API_TEST_URI: ${{ secrets.EXPO_PUBLIC_API_TEST_URI }}
        EXPO_PUBLIC_API_RW_URI: ${{ secrets.EXPO_PUBLIC_API_RW_URI }}
        EXPO_PUBLIC_DOCUMENTATION_URI: ${{ secrets.EXPO_PUBLIC_DOCUMENTATION_URI }}
        EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN: ${{ secrets.EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN }}
```

---

## 6. Troubleshooting CI/CD Mobile

### 6.1 Fallos de build por falta de variables

**Síntoma:** El build en EAS falla con errores de variables no definidas.

**Acciones:**
- Verificar que todas las variables listadas en la sección 2.2 están definidas en GitHub y/o EAS.
- Revisar los logs de build en el panel de EAS para identificar el nombre exacto de la variable faltante.

### 6.2 Errores 401/403 con proveedor de mapas

**Síntoma:** El build falla o la app no carga mapas por errores de autenticación.

**Acciones:**
- Confirmar que el token usado en `EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN` y `RN_MAPBOX_MAPS_DOWNLOAD_TOKEN` es un **token público** (`pk...`) con permisos de lectura de estilos, tiles y descargas.
- Evitar restricciones de IP/URL que puedan bloquear los servidores de EAS.

### 6.3 Conflictos de identificador en tiendas

**Síntoma:** Al publicar en tiendas se reportan conflictos de `bundleIdentifier` / `package` ya existentes.

**Acciones:**
- Configurar un identificador único de app en la configuración de Expo (por ejemplo, `com.example.inatrace.app`).
- Mantener el mismo identificador para builds sucesivos para no perder continuidad en tiendas.

---

## 7. Referencias Cruzadas

- [Ficha Técnica Mobile](./ficha-tecnica-mobile.md)
- [Guía CI/CD Backend](../backend/guia-cicd-backend.md)
- [Lineamientos de Documentación](../lineamientos-documentacion.md)
