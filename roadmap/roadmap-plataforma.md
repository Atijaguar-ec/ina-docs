# Roadmap Técnico · Plataforma INATrace

> **Audiencia**: Gerencia técnica, Arquitectura, Equipo de Desarrollo  
> **Ámbito**: Backend, Frontend Web, Mobile, Observabilidad y CI/CD  
> **Última actualización**: Noviembre 2025

Este documento resume, a alto nivel, las principales **líneas de evolución técnica** de la plataforma INATrace.  
No es un compromiso contractual, sino una guía orientativa para priorizar mejoras.

---

## 1. Ejes de Mejora

1. **Robustez y Seguridad del Backend**
2. **Modernización del Frontend Web**
3. **Consolidación de la App Móvil**
4. **Observabilidad, Testing y Calidad**
5. **Operación y Multitenencia**

---

## 2. Backend · Hoja de Ruta Resumida

Inspirado en el roadmap backend técnico existente, adaptado de forma neutral.

### 2.1 Fase 0 – Cimientos

- Unificación de especificaciones de API (OpenAPI) y documentación.
- Ajustes de configuración para entornos productivos (por ejemplo, evitar cambios de esquema automáticos en producción).
- Revisión y endurecimiento básico de seguridad.

### 2.2 Fase 1 – Identidad y Acceso

- Integración con proveedor de identidad (por ejemplo, Keycloak u otro) y validación de tokens en el backend.
- Configuración de gateway / proxy de autenticación para servicios expuestos.
- Definición clara de roles y permisos a nivel de API.

### 2.3 Fase 2 – Modularización

- Evolución hacia un **monolito modular** con límites de dominio claros.
- Separación de módulos sensibles para facilitar futuras extensiones (reporting, documentos, etc.).

### 2.4 Fase 3+ – Extensiones

- Extracción progresiva de módulos específicos (reportes, documentos, integraciones externas) cuando tenga sentido.
- Evaluación de mecanismos de eventos asíncronos para flujos de negocio que lo requieran.

---

## 3. Frontend Web · Backlog Resumido

Basado en el backlog técnico existente del frontend, presentado aquí de forma neutral.

### 3.1 Alta Prioridad

- Actualización del **toolchain** a versiones soportadas (Node, Angular, librerías clave).
- Migración progresiva de herramientas de testing y linting hacia estándares modernos.
- Refuerzo de la reproducibilidad de CI/CD (builds consistentes entre release y deploy).
- Gobernanza de import maps o mecanismos equivalentes en caso de arquitecturas de microfrontends.

### 3.2 Media Prioridad

- Endurecimiento de configuración de servidor web (por ejemplo, Nginx) con cabeceras de seguridad.
- Mejora de observabilidad del frontend (error tracking, RUM, SLOs básicos).
- Optimización de performance (lazy loading, prefetch/preload, optimización de assets).

### 3.3 Baja Prioridad

- Documentación adicional (guías de migración de framework, estándares de i18n, procesos para nuevas cadenas de valor).
- Revisión de tooling de paquetes según necesidades del equipo.

---

## 4. Mobile · Evolución

- Consolidar la integración de la app móvil con el backend y el modelo de datos.
- Fortalecer la estrategia offline (sincronización, resolución de conflictos, rendimiento).
- Mejorar experiencia de usuario en entornos de red limitada.
- Alinear la configuración de CI/CD mobile con las mejores prácticas descritas en la [Guía CI/CD Mobile](../mobile/guia-cicd-mobile.md).

---

## 5. Observabilidad, Testing y Calidad

- Implementar de forma sistemática la [Estrategia de Testing](../testing/estrategia-testing.md).
- Ampliar cobertura de logs, métricas y, cuando aplique, trazas distribuidas.
- Establecer SLOs básicos (disponibilidad, tiempos de respuesta) por componente.
- Revisar periódicamente la calidad de código según la [Guía de Calidad de Código](../testing/guia-calidad-codigo.md).

---

## 6. Operación y Multitenencia

- Formalizar procedimientos de operación y mantenimiento según el [Manual de Operación y Mantenimiento](../operacion/manual-operacion-mantenimiento.md).
- Definir políticas de backup y restauración alineadas con los requerimientos no funcionales.
- Para despliegues multi‑organización, establecer criterios claros de aislamiento lógico (por empresa/cadena), aunque la implementación concreta (single-tenant vs multi-tenant) pueda variar.

---

## 7. Gobernanza del Roadmap

- Revisar este documento de forma periódica (por ejemplo, trimestralmente) con las partes interesadas.
- Registrar decisiones importantes en documentos de arquitectura (ADR) o notas técnicas.
- Asegurar que las prioridades técnicas se coordinan con las necesidades de negocio y operación.

---

## 8. Referencias

- [Índice de Mejoras Técnicas (docs/mejoras)](../../docs/mejoras/00-index-resumen-ejecutivo.md) *(uso interno de referencia, no para redistribución)*
- [Ficha Técnica Backend](../backend/ficha-tecnica-backend.md)
- [Ficha Técnica Frontend](../frontend/ficha-tecnica-frontend.md)
- [Ficha Técnica Mobile](../mobile/ficha-tecnica-mobile.md)
