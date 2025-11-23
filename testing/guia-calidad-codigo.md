# Guía de Calidad de Código · INATrace

## 1. Objetivo

Definir principios y prácticas mínimas de **calidad de código** para los componentes de INATrace (backend, frontend web y mobile), alineados con los pipelines de CI/CD existentes.

---

## 2. Principios Generales

1. **Legibilidad primero**
   - Código claro, nombres descriptivos, funciones pequeñas.
   - Comentarios solo cuando aporten contexto que no sea obvio por el propio código.

2. **Consistencia**
   - Seguir los estilos definidos por los linters y formateadores del proyecto.
   - Evitar mezclar estilos en un mismo módulo.

3. **Seguridad**
   - No exponer secretos ni credenciales en el código.
   - Validar entradas de usuario y manejar errores de forma controlada.

4. **Mantenibilidad**
   - Separación de responsabilidades.
   - Reutilización de componentes/servicios cuando tenga sentido.

---

## 3. Backend (Java/Spring Boot)

### 3.1 Estilo y Organización

- Organizar el código por **módulos de dominio** (no solo por capas técnicas).
- Mantener una clara separación entre:
  - Controladores REST.
  - Servicios de dominio.
  - Repositorios de datos.
  - Integraciones externas.

### 3.2 Buenas Prácticas

- Manejar excepciones de forma centralizada cuando sea posible.
- Evitar lógica compleja en controladores; delegar en servicios.
- Usar interfaces y patrones como Repository para facilitar el testing.

### 3.3 Integración con CI/CD

- Asegurar que los módulos compilan sin warnings críticos.
- Mantener y actualizar las pruebas unitarias e integración junto con los cambios.

---

## 4. Frontend Web (Angular)

### 4.1 Arquitectura Modular

- Seguir la arquitectura descrita en la documentación de componentes frontend:
  - Módulos de funcionalidad (feature modules).
  - Módulos compartidos (shared modules).
  - Módulo core (servicios globales).

### 4.2 Buenas Prácticas de Código

- Componentes:
  - Mantener componentes pequeños y enfocados en la presentación.
  - Mover la lógica de negocio a servicios dedicados.
- Servicios:
  - Encapsular acceso a APIs y lógica reutilizable.
- Formularios y validaciones:
  - Centralizar validaciones complejas cuando sea posible.

### 4.3 Testing y Calidad

- Mantener una carpeta de utilidades de testing cuando aplique.
- Escribir tests unitarios para componentes y servicios clave.
- Evitar lógica no probada en secciones críticas de la UI.

---

## 5. Mobile (React Native / Expo)

### 5.1 Organización del Código

- Mantener separadas las capas de:
  - Presentación (screens y componentes).
  - Estado (stores, contextos).
  - Datos (servicios API, almacenamiento local).

### 5.2 Buenas Prácticas

- Hooks y contextos:
  - Encapsular lógica de negocio y estado en hooks/contextos reutilizables.
- Sincronización offline:
  - Manejar explícitamente estados de sincronización y errores.
- Internacionalización:
  - Centralizar textos en un sistema de i18n.

---

## 6. Linters, Formateadores y Checks Automáticos

### 6.1 Backend

- Utilizar reglas de estilo configuradas en el proyecto (por ejemplo, a través de plugins de Maven o Gradle).
- Resolver warnings relevantes en lugar de ignorarlos sistemáticamente.

### 6.2 Frontend y Mobile

- Usar linters (por ejemplo, ESLint) con una configuración común para el monorepo cuando sea posible.
- Integrar el formateador (por ejemplo, Prettier) en el flujo de desarrollo local y en CI.

### 6.3 Integración en CI/CD

- Jobs de `quality` en los workflows deben incluir:
  - Ejecución de linters.
  - Verificación de tipo (TypeScript) en los proyectos que lo utilicen.
  - Ejecución de tests unitarios básicos.

---

## 7. Revisiones de Código (Code Reviews)

### 7.1 Alcance

En cada *pull request* se recomienda revisar, al menos:

- Correcta aplicación de la lógica de negocio.
- Impacto en seguridad (acceso a datos, exposición de información sensible).
- Impacto en rendimiento en partes críticas.
- Cobertura razonable de tests para los cambios.

### 7.2 Buenas Prácticas en Reviews

- Comentarios concretos y accionables.
- Evitar opiniones puramente subjetivas cuando existan reglas de estilo claras.
- Priorizar:
  1. Correctitud y seguridad.
  2. Mantenibilidad.
  3. Estilo.

---

## 8. Métricas de Calidad (Orientativas)

- **Tests**
  - Mantener un conjunto de pruebas unitarias e integración que cubran las rutas y casos de uso más críticos.
- **Bugs en producción**
  - Monitorizar incidencias relacionadas con regresiones tras despliegues.
- **Observabilidad**
  - Revisar logs y métricas (errores 5xx, timeouts, etc.) tras cambios importantes.

---

## 9. Referencias

- [Estrategia de Testing](./estrategia-testing.md)
- [Guía CI/CD Backend](../backend/guia-cicd-backend.md)
- [Guía CI/CD Frontend](../frontend/guia-cicd-frontend.md)
- [Guía CI/CD Mobile](../mobile/guia-cicd-mobile.md)
