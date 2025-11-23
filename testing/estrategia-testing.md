# Estrategia de Testing · Plataforma INATrace

## 1. Objetivo

Este documento define la **estrategia de testing** para la plataforma INATrace (backend, frontend web y aplicación móvil), con el fin de garantizar un nivel consistente de calidad antes de cada despliegue.

Se centra en:

- Tipos de pruebas y alcance por componente.
- Entornos recomendados para ejecutar las pruebas.
- Integración del testing en los pipelines de CI/CD.

---

## 2. Niveles de Testing

### 2.1 Pruebas Unitarias

- **Backend**
  - Alcance: servicios, componentes de dominio, validadores, mapeadores.
  - Objetivo: validar lógica de negocio aislada de infraestructura.
  - Herramientas típicas: framework de tests de la plataforma (por ejemplo, JUnit) + mocks (por ejemplo, Mockito).

- **Frontend Web**
  - Alcance: componentes, servicios, pipes, helpers.
  - Objetivo: asegurar que la UI y la lógica de presentación se comportan correctamente.
  - Herramientas típicas: framework de tests para Angular (por ejemplo, Jest o el stack por defecto del proyecto).

- **Mobile**
  - Alcance: hooks, servicios, contexto de autenticación, lógica de sincronización, utilidades.
  - Objetivo: verificar la lógica central (sin dependencias de UI nativa).
  - Herramientas típicas: Jest u otro framework de pruebas para React Native.

### 2.2 Pruebas de Integración

- **Backend**
  - Alcance: controladores REST + servicio + base de datos (real o embebida).
  - Objetivo: validar flujos end‑to‑end a nivel de API (crear/consultar/actualizar entidades clave).

- **Frontend / Mobile**
  - Alcance: integración con APIs, manejo de estados, flujos de formularios.
  - Objetivo: garantizar que la aplicación consume correctamente los endpoints publicados.

### 2.3 Pruebas End‑to‑End (E2E)

- Alcance: flujos completos de usuario (ejemplo: login → registrar productor → registrar entrega → verificar reporte).
- Se recomienda realizarlas sobre un entorno aislado de pruebas.
- Herramientas posibles: frameworks E2E del ecosistema web/móvil (ejemplo genérico: Playwright, Cypress o similares).

> La elección concreta de herramientas para E2E dependerá de las decisiones tecnológicas del equipo, pero siempre debe estar alineada con esta estrategia general.

---

## 3. Entornos de Prueba

### 3.1 Desarrollo Local

- Uso para:
  - Ejecución rápida de pruebas unitarias e integración.
  - Verificación manual de cambios pequeños.
- Recomendaciones:
  - Ejecutar pruebas unitarias antes de cada commit significativo.
  - Mantener datos de prueba en bases de datos locales o contenedores desechables.

### 3.2 Entorno de Testing/Staging

- Uso para:
  - Validación de historias de usuario completas.
  - Pruebas de integración entre componentes (backend + frontend + mobile).
  - Ejecución regular de E2E.
- Recomendaciones:
  - Población de datos de prueba controlada.
  - Uso de credenciales y endpoints configurados exclusivamente para testing.

### 3.3 Producción

- No se realizan pruebas destructivas.
- Solo se recomiendan pruebas de **smoke** muy acotadas tras cada despliegue (por ejemplo, login, consulta simple, endpoint de salud).

---

## 4. Testing en CI/CD

La estrategia de testing se integra en los pipelines de CI/CD descritos en:

- [Guía CI/CD Backend](../backend/guia-cicd-backend.md)
- [Guía CI/CD Frontend](../frontend/guia-cicd-frontend.md)
- [Guía CI/CD Mobile](../mobile/guia-cicd-mobile.md)

### 4.1 Backend

- Job de calidad que ejecuta:
  - Compilación.
  - Pruebas unitarias e integración básicas.
  - (Opcional) análisis de dependencias y seguridad.
- Criterios recomendados:
  - Failing build si fallan tests o análisis críticos.

### 4.2 Frontend Web

- Job `quality` que ejecuta:
  - Linting.
  - Pruebas unitarias.
- Criterios recomendados:
  - No desplegar si el job de calidad falla en ramas principales.

### 4.3 Mobile

- Jobs dedicados en el pipeline mobile para:
  - Linting y TypeScript check.
  - Pruebas unitarias.
  - Auditoría de dependencias.
- Los builds (preview/producción) dependen de que estos jobs pasen correctamente.

---

## 5. Datos y Escenarios de Prueba

### 5.1 Datos de Prueba

- Se recomienda mantener **datasets de prueba** separados para:
  - Desarrollo local.
  - Entorno de testing/staging.
- Los datos deben:
  - Ser **ficticios** (nombres genéricos, empresas ficticias).
  - Cubrir los principales casos de uso (productores, parcelas, entregas, pagos, etc.).

### 5.2 Matrices de Casos

- Para funcionalidades críticas (por ejemplo, campos específicos de ciertos productos), se recomienda definir matrices de casos con:
  - Variaciones de roles.
  - Variaciones de tipos de producto/cadena.
  - Estados de los registros (nuevo, editado, sincronizado, etc.).

---

## 6. Criterios de Aceptación de Release

Antes de aprobar un despliegue significativo se recomienda verificar:

1. **Backend**
   - Tests unitarios e integración pasan en CI.
   - Health checks expuestos y verificados en entorno de pruebas.

2. **Frontend**
   - Linting y pruebas unitarias pasan.
   - Flujos críticos (login, navegación principal) verificados manualmente o por E2E.

3. **Mobile**
   - Tests unitarios en CI.
   - Build de prueba verificado en dispositivos o emuladores representativos.

4. **No funcionales (resumen)**
   - Verificación básica de rendimiento (sin bloqueos evidentes).
   - Verificación de operación offline (mobile) y sincronización posterior.

---

## 7. Referencias

- [Requerimientos No Funcionales](../requerimientos/no-funcionales.md)
- [Arquitectura C4 Backend](../arquitectura/c4/03-componentes-backend.md)
- [Arquitectura C4 Frontend](../arquitectura/c4/04-componentes-frontend.md)
- [Ficha Técnica Mobile](../mobile/ficha-tecnica-mobile.md)
