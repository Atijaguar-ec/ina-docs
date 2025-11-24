# Análisis Técnico del Código Fuente · Aplicación Móvil INATrace

> **Audiencia**: Equipo de desarrollo mobile, arquitectura, QA  
> **Componente**: Mobile (React Native + Expo)  
> **Última actualización**: Noviembre 2025

Este documento resume el análisis técnico de la aplicación móvil de INATrace, centrado en su arquitectura, dependencias clave, capacidades offline, integración con backend y áreas de mejora.

---

## 1. Stack Tecnológico

- **Framework**: React Native + Expo (SDK 50.x)
- **Lenguaje**: TypeScript
- **Navegación**: Expo Router (file-based routing)
- **Base de Datos Local**: Realm
- **Estado Global**: Zustand
- **Estilos**: NativeWind (Tailwind CSS para React Native)
- **Mapas**: SDK de mapas (por ejemplo, Mapbox)
- **HTTP Client**: Axios

### 1.1 Dependencias Clave (visión general)

- **UI y Navegación**: Bottom Sheet, Flash List, iconos vectoriales.
- **Mapas y Geolocalización**: `@rnmapbox/maps`, `@turf/turf`, `expo-location`.
- **Almacenamiento y Seguridad**: Realm, AsyncStorage, Secure Store.
- **Red y API**: Axios, NetInfo, utilidades para descargas.
- **Utilidades**: i18n-js, lodash, generación de códigos QR, utilidades de IDs.

---

## 2. Arquitectura del Proyecto

### 2.1 Organización de Directorios (resumen)

```text
mobile/
├── app/               # Rutas (Expo Router)
├── components/        # Componentes reutilizables (UI)
├── context/           # Contextos (auth, conectividad, etc.)
├── realm/             # Esquemas y utilidades de base de datos local
├── state/             # Estado global con Zustand
├── types/             # Definiciones TypeScript (Farmer, Plot, User, etc.)
├── locales/           # Internacionalización (i18n)
├── constants/         # Constantes de la aplicación
├── utils/             # Helpers y utilidades
└── assets/            # Recursos estáticos
```

### 2.2 Navegación con Expo Router

- Rutas principales típicas:
  - `/login` → autenticación.
  - `/(app)/` → dashboard principal.
  - `/(app)/(farmers)/` → gestión de productores.
  - `/(app)/data-sync` → sincronización de datos.
  - `/(app)/map-download` → gestión de mapas offline.
  - `/(app)/user-settings` → configuración de usuario.

El layout raíz (`app/_layout.tsx`) monta los providers globales (sesión, navegación, bottom sheets, etc.).

---

## 3. Capacidades Offline y Persistencia

### 3.1 Gestión de Conectividad y Sincronización

- Uso de una librería de red (por ejemplo, NetInfo) para detectar cambios de conectividad.
- Cola de operaciones pendientes (productores, parcelas, etc.) que se sincronizan cuando vuelve la conexión.
- Estrategia **offline-first**:
  - Datos críticos se guardan en Realm.
  - Operaciones CRUD se pueden realizar sin conexión.
  - Sincronización automática y granular al recuperar conectividad.

### 3.2 Esquemas de Realm (ejemplo conceptual)

```typescript
export const FarmerSchema = {
  name: 'Farmer',
  properties: {
    id: 'string',
    userId: 'string',
    companyId: 'string',
    data: 'string',       // JSON serializado
    name: 'string',
    surname: 'string',
    synced: 'bool',       // Estado de sincronización
  },
  primaryKey: 'id',
};

export const PlotSchema = {
  name: 'Plot',
  properties: {
    id: 'string',
    farmerId: 'string',
    userId: 'string',
    data: 'string',       // Geometría GeoJSON
    synced: 'bool',
  },
  primaryKey: 'id',
};
```

**Puntos fuertes de diseño:**

- Esquemas tipados para productores y parcelas.
- Relación entre productores y parcelas.
- Campo `synced` para controlar sincronización.

---

## 4. Mapas y Geometría

- Integración con un SDK de mapas (por ejemplo, Mapbox) para:
  - Visualización de mapas online/offline.
  - Delimitación de parcelas mediante GPS.
- Uso de GeoJSON para representar geometrías de parcelas.
- Cálculos de área y operaciones geoespaciales con una librería de utilidades (por ejemplo, Turf.js).

**Características clave:**

- Renderizado eficiente de polígonos.
- Soporte para mapas offline en zonas rurales.
- Compatibilidad con formatos estándar (GeoJSON).

---

## 5. Autenticación y Estado Global

### 5.1 Autenticación

- Contexto de autenticación centralizado que gestiona:
  - Login/logout.
  - Modo invitado para demostraciones.
  - Cambio de empresa (multi‑organización) cuando aplique.
  - Tokens de acceso (por ejemplo, JWT) almacenados de forma segura.

- Validación básica de expiración de tokens (decodificación del payload y comparación de fechas).

### 5.2 Estado Global con Zustand

- Uso de stores ligeros para:
  - Selección de productor actual.
  - Estado de sincronización.
  - Preferencias de usuario.

Esta combinación (Context API + Zustand + Realm) permite separar:

- Estado de autenticación y sesión.
- Estado de UI y selección actual.
- Datos persistidos offline.

---

## 6. Funcionalidades Principales

### 6.1 Gestión de Productores

- Perfiles completos con datos personales, ubicación, datos bancarios y agrícolas.
- Información agrícola por tipo de producto (cultivos, áreas, plantas).
- Soporte para certificaciones y asociaciones/cooperativas.

### 6.2 Mapeo de Parcelas

- Delimitación de parcelas con GPS.
- Cálculo de áreas y visualización en mapas.
- Asociación de parcelas a productores específicos.

### 6.3 Sincronización de Datos

- Detección automática de conectividad.
- Cola de sincronización para operaciones pendientes.
- Sincronización bidireccional con el backend.
- Reintentos automáticos y manejo de conflictos.

### 6.4 Internacionalización

- Soporte multi‑idioma con i18n.
- Posibilidad de cambio dinámico de idioma y localización de formatos de fecha/número.

---

## 7. Configuración de la Aplicación

### 7.1 Variables de Entorno (ejemplo conceptual)

La app se configura mediante variables de entorno (por ejemplo, en `app.config.js`):

- `EXPO_PUBLIC_API_URI` → URL base de la API principal.
- `EXPO_PUBLIC_API_TEST_URI` → URL de pruebas.
- `EXPO_PUBLIC_API_RW_URI` → URL de lectura/escritura si se separa tráfico.
- `EXPO_PUBLIC_DOCUMENTATION_URI` → URL de documentación.
- `EXPO_PUBLIC_MAPBOX_ACCESS_TOKEN` → Token público de lectura de mapas.
- `RN_MAPBOX_MAPS_DOWNLOAD_TOKEN` → Token para descargas de mapas offline.

> **Nota:** En la documentación de producción se deben usar dominios y tokens ficticios o genéricos (`https://api.example.com/api/`, `pk.xxxxxxxx`).

### 7.2 Configuración de Plataformas (ejemplo neutralizado)

- **iOS**: `bundleIdentifier` genérico (ejemplo: `com.example.inatrace.mobile`).
- **Android**: `package` genérico (ejemplo: `com.example.inatrace.mobile`).

Los identificadores concretos deben definirse por organización/proyecto, nunca hardcodearse en documentación pública.

### 7.3 Configuración EAS Build

- Perfiles típicos:
  - `development` → builds internos de desarrollo.
  - `preview` → builds de prueba interna.
  - `production` → builds para tiendas.

---

## 8. Integración con Backend

- Cliente HTTP basado en Axios que:
  - Añade el token de autenticación en los headers.
  - Construye URLs a partir de una instancia base configurada por entorno.
  - Aplica lógica de reintento y manejo de errores.

- Endpoints típicos consumidos (ejemplos):
  - Autenticación: `/user/login`, `/user/logout`.
  - Datos maestros: `/company/list`, `/product/types`, `/codebook/countries`.
  - Productores: `/company/{companyId}/farmers`, etc.
  - Parcelas: `/farmer/{farmerId}/plots`, etc.

---

## 9. Fortalezas Técnicas

1. **Arquitectura offline-first**
   - Diseñada para conectividad limitada.
   - Sincronización robusta y almacenamiento completo local.

2. **Stack moderno**
   - React Native + Expo + TypeScript.
   - Navegación con Expo Router.

3. **Funcionalidad geográfica avanzada**
   - Mapas interactivos, GeoJSON, cálculos con Turf.

4. **Experiencia de usuario optimizada**
   - Componentes nativos optimizados (Bottom Sheet, Flash List).
   - UI consistente y preparada para uso intensivo en campo.

5. **Gestión de estado eficiente**
   - Estado global ligero con Zustand.
   - Contextos claros para autenticación.

---

## 10. Áreas de Mejora (Resumen)

- **Testing**
  - Reforzar cobertura con Jest y herramientas de testing para React Native.
- **Manejo de errores**
  - Mejorar estrategias de reintento y capturas de errores en UI.
- **Performance de sincronización**
  - Avanzar hacia sincronización incremental/delta en lugar de sincronización completa.
- **Validación de datos**
  - Introducir validación basada en esquemas (por ejemplo, Zod/Yup) para formularios clave.
- **Monitoreo**
  - Integrar herramientas de error tracking y analytics, según la política de la organización.

---

## 11. Conclusiones

La aplicación móvil de INATrace presenta una **arquitectura sólida, moderna y alineada con un uso intensivo en campo**:

- Preparada para trabajo offline y sincronización posterior.
- Integración avanzada de mapas y geolocalización.
- Base tecnológica actual y mantenible.

Las áreas de mejora identificadas son mayoritariamente **evolutivas** (testing, observabilidad, performance), y no invalidan la idoneidad de la app para operar en escenarios productivos, siempre que se apliquen las recomendaciones de forma progresiva.

---

**Relacionado:**

- [Ficha Técnica Mobile](./ficha-tecnica-mobile.md)
- [Guía CI/CD Mobile](./guia-cicd-mobile.md)
- [Estrategia de Testing](../testing/estrategia-testing.md)
