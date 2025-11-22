# Ficha Técnica: Frontend INATrace

> **Audiencia**: Desarrolladores Frontend, DevOps, UX/UI Designers  
> **Componente**: Frontend  
> **Última actualización**: Noviembre 2025

## Descripción General

El frontend de INATrace es una **Single Page Application (SPA)** desarrollada en **Angular 10** con **TypeScript**, diseñada para ofrecer una experiencia de usuario fluida, responsiva y multi-idioma. Implementa una arquitectura modular que soporta múltiples cadenas de valor (cacao, camarón, café) con personalización visual dinámica y gestión de roles granular.

**Características principales**:
- Arquitectura modular basada en componentes
- Soporte **Multi-Cadena** (configuración dinámica de UI por producto)
- Sistema de traducción **i18n** extensible
- Gestión de estados y formularios reactivos
- Integración con mapas (Mapbox) y escaneo de QR
- Diseño responsivo adaptado para uso en campo y escritorio

---

## Tabla de Contenidos

- [Tecnologías Principales](#tecnologias-principales)
- [Arquitectura del Proyecto](#arquitectura-del-proyecto)
- [Funcionalidades Clave](#funcionalidades-clave)
- [Configuración Multi-Cadena](#configuracion-multi-cadena)
- [Requisitos del Sistema](#requisitos-del-sistema)
- [Instalación Local](#instalacion-local)
- [Despliegue](#despliegue)
- [Troubleshooting](#troubleshooting)

---

## Tecnologías Principales

### Stack Base

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Angular** | 10.x | Framework SPA principal |
| **TypeScript** | 4.0+ | Lenguaje de desarrollo |
| **Node.js** | 14.x (LTS) | Entorno de ejecución y build |
| **NPM** | 6.x | Gestión de paquetes |
| **RxJS** | 6.x | Programación reactiva |
| **Nginx** | 1.21+ | Servidor web y proxy reverso (Prod) |

### Dependencias Clave

- **Angular Material**: Componentes UI base
- **Bootstrap 4**: Grid system y utilidades CSS
- **Ngx-Translate**: Internacionalización (i18n)
- **Mapbox GL JS**: Visualización de mapas y geolocalización
- **ZXing**: Escaneo de códigos QR en navegador
- **Chart.js / Ng2-Charts**: Visualización de datos y dashboards
- **Compodoc**: Generación de documentación técnica

---

## Arquitectura del Proyecto

### Estructura de Directorios

```
fe/
├── src/
│   ├── app/
│   │   ├── core/                 # Servicios singleton, guardias, interceptors
│   │   ├── shared/               # Componentes reutilizables, pipes, directivas
│   │   ├── layout/               # Estructura base (header, sidebar, footer)
│   │   ├── modules/              # Módulos funcionales (lazy loaded)
│   │   │   ├── auth/             # Login, registro, recuperación
│   │   │   ├── dashboard/        # Gráficos y métricas
│   │   │   ├── company/          # Gestión de empresa y usuarios
│   │   │   ├── product/          # Gestión de productos y lotes
│   │   │   └── ...
│   │   └── app.component.ts      # Componente raíz
│   ├── assets/
│   │   ├── i18n/                 # Archivos de traducción JSON
│   │   ├── images/               # Recursos estáticos
│   │   └── env.js                # Variables de entorno runtime
│   ├── environments/             # Configuración build-time
│   └── styles/                   # Estilos globales SCSS
├── angular.json                  # Configuración del CLI
├── package.json                  # Dependencias y scripts
├── Dockerfile                    # Definición de imagen Docker
└── nginx-custom.conf             # Configuración del servidor web
```

### Módulos Principales

1. **Core Module**: Servicios transversales (AuthService, ApiService, ErrorHandling). Se importa una sola vez en `AppModule`.
2. **Shared Module**: Componentes UI (botones, inputs, tablas), Pipes y Directivas. Se importa en cada módulo que lo necesite.
3. **Feature Modules**: Módulos de negocio cargados bajo demanda (Lazy Loading) para optimizar el rendimiento inicial.

---

## Funcionalidades Clave

### 1. Sistema Multi-Cadena (Mejora Importante)

INATrace 2 introduce soporte nativo para múltiples cadenas de valor. El frontend se adapta dinámicamente según la configuración:

- **Personalización Visual**: Colores, logos y fuentes configurables por cadena.
- **Terminología Adaptable**: "Agricultor" (Cacao) vs "Productor" (Café) vs "Proveedor" (Camarón).
- **Campos Dinámicos**: Formularios que muestran/ocultan campos según el tipo de producto (ej: ocultar "secado" en camarón).

### 2. Internacionalización (i18n)

Soporte completo para múltiples idiomas mediante archivos JSON en `assets/i18n/`:
- `es.json`: Español (Default)
- `en.json`: Inglés

**Mejora implementada**: Sistema de sobreescritura de traducciones por cadena (ej: `assets/i18n/shrimp/es.json` sobreescribe términos base).

### 3. Gestión de Roles y Permisos

Control de acceso granular basado en roles JWT recibidos del backend:
- **System Admin**: Configuración global.
- **Company Admin**: Gestión total de la organización.
- **Manager/User**: Operación diaria limitada.

El frontend utiliza `AuthGuard` y directivas estructurales (`*hasRole`) para mostrar u ocultar elementos de la UI.

### 4. Dashboards Interactivos

Visualización de datos en tiempo real:
- Volúmenes de entrega por periodo.
- Rendimiento de procesamiento.
- Trazabilidad geográfica en mapas.

---

## Configuración Multi-Cadena

Para configurar una nueva cadena o entorno, utilizamos variables en `assets/env.js` (Runtime) o `environment.ts` (Build time).

**Ejemplo: Configuración para Cacao (Desarrollo)**

```javascript
// assets/env.js
(function(window) {
  window["env"] = window["env"] || {};
  window["env"]["apiUrl"] = "https://inatrace.atijaguar.com/api";
  window["env"]["companyTheme"] = "COCOA"; // Activa estilos y lógica de Cacao
  window["env"]["primaryColor"] = "#5D4037"; // Marrón Cacao
})(this);
```

**Ejemplo: Configuración para Camarón (Desarrollo)**

```javascript
// assets/env.js
(function(window) {
  window["env"] = window["env"] || {};
  window["env"]["apiUrl"] = "https://camaron.atijaguar.com/api";
  window["env"]["companyTheme"] = "SHRIMP"; // Activa estilos y lógica de Camarón
  window["env"]["primaryColor"] = "#0277BD"; // Azul Camarón
})(this);
```

---

## Requisitos del Sistema

Para desarrollo local:
- **Node.js**: Versión 14.x obligatoria (versiones más recientes pueden causar conflictos con node-sass).
- **NPM**: Versión 6.x.
- **Docker**: Opcional, para ejecutar en contenedor.
- **Git**: Para control de versiones.

---

## Instalación Local

### Paso 1: Clonar Repositorio

```bash
git clone https://github.com/INATrace/fe.git
cd fe
```

### Paso 2: Instalar Dependencias

```bash
npm install
```

> ⚠️ **Nota**: Si encuentras errores con `node-sass`, intenta: `npm rebuild node-sass` o usa Node 14 estrictamente.

### Paso 3: Configurar Entorno

Copia `src/environments/environment.ts` a `src/environments/environment.dev.ts` y ajusta:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api', // Backend local
  companyTheme: 'COCOA'
};
```

### Paso 4: Generar Cliente API (Opcional)

Si el backend ha cambiado, regenera los servicios de Angular:

```bash
npm run generate-api
```

### Paso 5: Ejecutar

```bash
npm run dev
# Accede a http://localhost:4200
```

---

## Despliegue

El despliegue en producción se realiza mediante **Docker** y **Nginx**.

### Dockerfile Optimizado

Nuestro `Dockerfile` utiliza *Multi-stage builds*:
1. **Stage 1 (Build)**: Usa imagen Node para compilar el proyecto Angular.
2. **Stage 2 (Run)**: Usa imagen Nginx Alpine ligera para servir los estáticos.

**Comando de construcción**:

```bash
docker build -t inatrace-frontend:latest .
```

**Ejecutar contenedor**:

```bash
docker run -d -p 80:80 inatrace-frontend:latest
```

Ver [Guía CI/CD Frontend](./guia-cicd-frontend.md) para detalles del pipeline automático.

---

## Troubleshooting

### Error: `node-sass` binding not found
**Causa**: Diferencia entre la versión de Node.js local y la que compiló `node-sass`.
**Solución**:
```bash
npm rebuild node-sass
# O
npm uninstall node-sass && npm install node-sass
```

### Error: API Connection Refused
**Causa**: El frontend no alcanza al backend.
**Solución**: Verificar `assets/env.js` o `environment.ts`. Asegurar que la URL del backend sea accesible desde el navegador del cliente, no desde el contenedor Docker.

### Problema: Cambios no visibles en Producción
**Causa**: Caché del navegador o Nginx.
**Solución**:
- Forzar recarga (Ctrl+F5).
- Verificar configuración de caché en `nginx.conf`.
- Asegurar que el build de producción use *output hashing* (default en Angular prod build).

---

## Recursos Adicionales

- [Documentación Oficial Angular](https://angular.io/docs)
- [Guía de Estilos Angular](https://angular.io/guide/styleguide)
- [Repositorio Oficial Frontend](https://github.com/INATrace/fe)

---

**Última actualización**: Noviembre 2025
