# Ficha Técnica · Aplicación Móvil INATrace

## 1. Descripción General

La aplicación móvil de INATrace es una app híbrida construida con **React Native** y **Expo** que permite:

- Gestión de productores, parcelas y operaciones en campo.
- Trabajo en modo **offline** con posterior sincronización.
- Captura de datos geoespaciales (parcelas, puntos GPS) con mapas online/offline.

Está pensada para operar en entornos rurales con conectividad limitada y se integra con el backend central de INATrace mediante APIs REST seguras.

---

## 2. Tecnologías y Framework

### 2.1 Stack Principal

- **Framework**: React Native + Expo
- **Lenguaje**: TypeScript
- **Navegación**: Expo Router (file-based routing)
- **Base de Datos Local**: Realm
- **Gestión de Estado Global**: Zustand
- **Estilos**: NativeWind (Tailwind CSS para React Native)
- **Build System**: Expo Application Services (EAS Build)

> Los números de versión concretos pueden variar según la evolución del proyecto. Consultar `package.json` del módulo `mobile/` para versiones exactas.

### 2.2 Dependencias Clave (visión general)

- **UI y Navegación**: Bottom Sheet, listas optimizadas, componentes de iconografía.
- **Mapas y Geolocalización**: SDK de mapas (por ejemplo, Mapbox) + utilidades de geocálculo (por ejemplo, Turf.js).
- **Almacenamiento Local**: Realm + AsyncStorage + Secure Store.
- **Red y API**: Axios + detección de conectividad.
- **Utilidades**: i18n, generación de QR, helpers de formato.

---

## 3. Arquitectura del Proyecto

### 3.1 Estructura de Directorios (vista simplificada)

```text
mobile/
├── app/                           # Expo Router - navegación basada en archivos
│   ├── (app)/                     # Grupo de rutas autenticadas
│   │   ├── (farmers)/             # Gestión de productores
│   │   ├── (plots)/               # Gestión de parcelas
│   │   ├── index.tsx              # Dashboard principal
│   │   ├── data-sync.tsx          # Sincronización de datos
│   │   └── user-settings.tsx      # Configuración de usuario
│   ├── _layout.tsx                # Layout raíz con providers globales
│   └── login.tsx                  # Pantalla de autenticación
├── components/                    # Componentes reutilizables (UI)
├── context/                       # Context API (autenticación, estado app)
├── realm/                         # Esquemas y utilidades de base de datos local
├── state/                         # Store global (Zustand)
├── types/                         # Tipos TypeScript (farmer, plot, user, etc.)
├── locales/                       # Internacionalización (i18n)
├── constants/                     # Constantes de diseño y configuración
├── utils/                         # Helpers y utilidades
└── assets/                        # Recursos estáticos (imágenes, fuentes)
```

### 3.2 Arquitectura de Navegación (Expo Router)

La navegación se basa en la estructura de archivos dentro de `app/`, donde cada ruta define una pantalla o flujo. Ejemplo conceptual:

```text
/login                     -> Pantalla de autenticación
/(app)/                    -> Dashboard principal (requiere sesión)
/(app)/(farmers)/          -> Lista de productores
/(app)/(farmers)/info/[id] -> Detalle de productor
/(app)/data-sync           -> Sincronización de datos
/(app)/user-settings       -> Configuración de usuario
```

El layout raíz (`app/_layout.tsx`) monta los providers globales (sesión, navegación, hojas modales, etc.).

---

## 4. Capacidades Offline

### 4.1 Modelo Offline con Realm

La app utiliza Realm como base de datos local para soportar trabajo offline:

- **Esquemas versionados** para soportar migraciones de datos.
- **Relaciones** entre productores y parcelas.
- **Campos de estado** para marcar registros pendientes de sincronizar (`synced`, `lastModified`, etc.).

Ejemplo conceptual de esquema (simplificado):

```typescript
// Esquema de productor (ejemplo simplificado)
export const FarmerSchema = {
  name: 'Farmer',
  properties: {
    id: 'string',
    userId: 'string',
    companyId: 'string',
    data: 'string',       // JSON serializado del objeto completo
    name: 'string',       // Campos indexados para búsqueda
    surname: 'string',
    synced: 'bool',       // Estado de sincronización
    lastModified: 'date', // Timestamp para resolución de conflictos
  },
  primaryKey: 'id',
};
```

### 4.2 Sincronización de Datos

- Detección de conectividad con una librería de red (por ejemplo, NetInfo).
- Cola de operaciones pendientes (productores, parcelas, etc.).
- Sincronización bidireccional cuando vuelve la conectividad:
  - Lectura de registros `synced == false`.
  - Envío al backend vía API REST.
  - Actualización de flags y timestamps.

---

## 5. Integración con Backend INATrace

La app móvil se integra con el backend mediante una capa de servicio HTTP:

- Cliente HTTP (por ejemplo, Axios) configurado con:
  - URL base de la API (variable de entorno, ver guía CI/CD mobile).
  - Interceptores para autenticación (tokens, refresco de sesión).
  - Manejo estandarizado de errores.

Variables típicas de configuración (ejemplo):

- `EXPO_PUBLIC_API_URI` → URL base de la API principal (por ejemplo, `https://api.example.com/api/`).
- `EXPO_PUBLIC_API_TEST_URI` → URL de pruebas funcionales.
- `EXPO_PUBLIC_API_RW_URI` → URL para operaciones de escritura si se separa tráfico.

> **Nota:** Los nombres exactos de las variables y su uso se documentan en la [Guía CI/CD Mobile](./guia-cicd-mobile.md).

---

## 6. Mapas y Geolocalización

- Integración con SDK de mapas (por ejemplo, Mapbox) para:
  - Visualizar parcelas y capas geográficas.
  - Trabajar con mapas offline descargados previamente.
- Uso de librerías de geocálculo (por ejemplo, Turf.js) para:
  - Cálculo de áreas de parcelas.
  - Distancias y otras métricas geoespaciales.

Las credenciales de mapas (tokens públicos de lectura) se gestionan como **variables de entorno** y **secrets de CI/CD**, no se incluyen en el repositorio.

---

## 7. Internacionalización y Experiencia de Usuario

- Sistema de traducciones centralizado (i18n) con soporte multiidioma.
- Componentes UI reutilizables para formularios, listados y barras de navegación.
- Diseño adaptado a entornos de campo (legibilidad, acciones rápidas, trabajo con una mano).

---

## 8. Seguridad

- Gestión de tokens de autenticación en almacenamiento seguro (por ejemplo, Secure Store).
- Cifrado o aislamiento de datos sensibles en la base de datos local.
- Validación estricta de certificados TLS en las conexiones de red.

---

## 9. Referencias Relacionadas

- **Backend**:
  - [Ficha Técnica Backend](../backend/ficha-tecnica-backend.md)
  - [Modelo de Datos](../base-datos/modelo-datos.md)
- **CI/CD Mobile**:
  - [Guía CI/CD Mobile](./guia-cicd-mobile.md)
