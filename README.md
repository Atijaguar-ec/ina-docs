# INATrace - Documentación Técnica

**INATrace** es una plataforma integral de trazabilidad para cadenas de valor agrícola que permite el seguimiento completo de productos desde la producción hasta el consumidor final, garantizando transparencia, calidad y sostenibilidad en toda la cadena de suministro.

> **Audiencia**: Desarrolladores, Arquitectos, DevOps, Analistas de Negocio  
> **Versión**: 2.3  
> **Última actualización**: Noviembre 2026

---

## 🎯 ¿Qué es INATrace?

INATrace es un sistema modular que integra:

- **Trazabilidad completa**: Desde la producción primaria hasta el consumidor final
- **Multi-producto**: Soporte para múltiples cadenas (cacao, camarón, café, etc.)
- **Multi-tenant**: Instancias independientes por organización
- **Blockchain opcional**: Garantía de inmutabilidad de datos críticos
- **APIs REST**: Integración con sistemas externos
- **Aplicación móvil**: Captura de datos en campo
- **Portal web**: Gestión completa y reportes

---

## 🌟 Suite Oficial de Manuales de Instalación, Operación y Serie Audiovisual

Documentación verificada empíricamente en instancia limpia Ubuntu 24.04 LTS desde la rama `main` (`Atijaguar-ec/backend` y `Atijaguar-ec/fe`):

### 📚 Manuales Técnicos Paso a Paso
- [**Índice Maestro de Manuales Técnicos**](./manuales/README.md) - Mapa de navegación por rol, glosario internacional y convenciones.
- [**Módulo 00: Dictamen UX/UI, Design Thinking y Guía Editorial**](./manuales/00-aprobacion-ux-ui-design-thinking-handoff-disenador.md) - Paleta HEX/CMYK WCAG AA/AAA (incluido tema Keycloak `inatrace`), retícula A4 y catálogo de 13 láminas vectoriales (`IL-01` a `IL-13`).
- [**Módulo 01: Instalación y Despliegue de Infraestructura**](./manuales/01-manual-instalacion-despliegue.md) - OS/Docker/UFW, compilación desde `main`, Docker Compose, PostgreSQL 16, Keycloak 26 (tema visual `inatrace`, `inatrace-browser-flow` y `manage-users`), Spring Boot 3.3, Angular 19, Nginx TLS/redirección canónica y *bootstrap* inicial.
- [**Módulo 02: Configuración Multi-Tenant y Multi-Cadena**](./manuales/02-manual-configuracion-multitenant-multicadena.md) - Aislamiento ADR-007, Cacao en Baba/Seco, Café, alcance ADR-016 para Camarón, catálogos DPA INEC/ISO y control de cupos.
- [**Módulo 03: Operación Funcional y Trazabilidad de Campo a Puerto**](./manuales/03-manual-operacion-trazabilidad.md) - Pesaje en báscula y API, tickets térmicos POS (72 mm), balance de masas, comprobante QR público y EUDR / TRACES-NT.
- [**Módulo 04: Seguridad, Identidad y Gobernanza de Datos**](./manuales/04-manual-seguridad-identidad-cumplimiento.md) - Keycloak OIDC PKCE, RBAC, cuentas técnicas ERP, privacidad B2C y *hardening*.
- [**Módulo 05: Mantenimiento, Migraciones y Resolución de Problemas**](./manuales/05-manual-mantenimiento-migraciones-troubleshooting.md) - Backups automatizados con `cron`, *Disaster Recovery*, ciclo Flyway y matriz de 12 incidentes reales.
- [**Artefactos Verificados (`verificado/`)**](./manuales/verificado/README.md) - `docker-compose.verificado.yml`, `nginx-inatrace.verificado.conf`, `nginx-http-limit_req_zone.conf`, `primer-admin.sql` y plantilla oficial `keycloak-theme/inatrace/`.
- [**Informe Empírico de Despliegue en VM Limpia GCP (`main`)**](./informe-prueba-gcp-vm-limpia-2026-11-16.md) - Evidencia de tiempos reales, Flyway `V1`–`V15`, tema `inatrace`, redirección `redirect_uri` y pruebas de punta a punta.

### 🎬 Serie Audiovisual (Cápsulas 01 a 05)
- [**Plan Maestro de Producción Audiovisual**](./audiovisual/README.md) y guiones técnicos: [**Cápsula 01**](./audiovisual/01-guion-video-arquitectura-repositorios-licencias.md) · [**Cápsula 02**](./audiovisual/02-guion-video-infraestructura-costos-sizing.md) · [**Cápsula 03**](./audiovisual/03-guion-video-despliegue-docker-keycloak.md) · [**Cápsula 04**](./audiovisual/04-guion-video-configuracion-multicadena-qr.md) · [**Cápsula 05**](./audiovisual/05-guion-video-traces-eudr-mantenimiento-buenas-practicas.md).

---

## 📋 Tabla de Contenidos

### 🏗️ Arquitectura

- [**Arquitectura del Sistema**](./arquitectura/arquitectura-general.md) - Visión completa usando arc42
- [**Diagramas C4**](./arquitectura/c4/) - Visualización por niveles (Context, Container, Component)
- [**Decisiones de Arquitectura**](./arquitectura/decisiones-arquitectura.md) - ADRs y justificaciones técnicas
- [**Arquitectura Multi-Cadena**](./arquitectura/multi-cadena.md) - Soporte para múltiples productos

### 🗄️ Base de Datos

- [**Modelo de Datos**](./base-datos/modelo-datos.md) - Entidades principales y relaciones
- [**Diccionario de Datos**](./base-datos/diccionario-datos.md) - Campos y tipos detallados
- [**Guía de Migraciones**](./base-datos/migraciones.md) - Proceso de actualización de esquemas
- [**Diagrama ERD**](./base-datos/diagrama-erd.md) - Representación visual de la base de datos

### 🔧 Backend (Java + Spring Boot)

- [**Ficha Técnica Backend**](./backend/ficha-tecnica-backend.md) - Tecnologías, dependencias, estructura
- [**Guía CI/CD Backend**](./backend/guia-cicd-backend.md) - Despliegue continuo con Docker y GitHub Actions
- [**APIs REST**](./backend/apis-rest.md) - Endpoints principales y autenticación
- [**Configuración**](./backend/configuracion.md) - Variables de entorno y profiles
- [**Troubleshooting Backend**](./backend/troubleshooting-backend.md) - Problemas comunes y soluciones

### 🎨 Frontend (Angular + TypeScript)

- [**Ficha Técnica Frontend**](./frontend/ficha-tecnica-frontend.md) - Tecnologías, estructura, componentes
- [**Guía CI/CD Frontend**](./frontend/guia-cicd-frontend.md) - Despliegue con Docker y Nginx
- [**Sistema de Traducción Multi-Cadena**](./frontend/traducciones-multi-cadena.md) - Internacionalización por producto
- [**Configuración de Temas**](./frontend/configuracion-temas.md) - Personalización visual por cadena
- [**Troubleshooting Frontend**](./frontend/troubleshooting-frontend.md) - Problemas comunes y soluciones

### 📱 Mobile (React Native + Expo)

- [**Ficha Técnica Mobile**](./mobile/ficha-tecnica-mobile.md) - Tecnologías y estructura
- [**Guía CI/CD Mobile**](./mobile/guia-cicd-mobile.md) - Builds y distribución
- [**Configuración**](./mobile/configuracion.md) - Variables y entornos

### ⛓️ Blockchain (Hyperledger Fabric)

- [**Ficha Técnica Blockchain**](./blockchain/ficha-tecnica-blockchain.md) - Red y chaincode
- [**Guía CI/CD Blockchain**](./blockchain/guia-cicd-blockchain.md) - Despliegue de la red

### 📝 Formularios y Campos de Negocio

- [**Campos de Empresa**](./formularios/campos-empresa.md) - Metadatos de organizaciones
- [**Campos de Entregas**](./formularios/campos-entregas.md) - Stock orders y recepciones
- [**Campos de Procesamiento**](./formularios/campos-procesamiento.md) - Transformaciones y laboratorio
- [**Campos Específicos de Camarón**](./formularios/campos-camaron.md) - Gavetas, bines, piscinas, etc.

### 🚀 Despliegue e Infraestructura

- [**Guía de Instalación**](./despliegue/instalacion.md) - Requisitos y preparación
- [**Despliegue con Docker Compose**](./despliegue/docker-compose.md) - Ambiente local y desarrollo
- [**Despliegue en Producción**](./despliegue/produccion.md) - Servidores cloud (ejemplos con Hetzner)
- [**Configuración Nginx**](./despliegue/nginx.md) - Proxy reverso y SSL
- [**Monitoreo y Logs**](./despliegue/monitoreo.md) - Observabilidad del sistema

### 🧪 Testing y Calidad

- [**Estrategia de Testing**](./testing/estrategia-testing.md) - Niveles y cobertura
- [**Tests Backend**](./testing/tests-backend.md) - JUnit, Mockito, integración
- [**Tests Frontend**](./testing/tests-frontend.md) - Jasmine, Karma, E2E

### 📊 Operación y Mantenimiento

- [**Manual de Operación**](./operacion/manual-operacion.md) - Procedimientos operativos
- [**Ventanas de Mantenimiento**](./operacion/ventana-mantenimiento.md) - Formato estándar
- [**Respaldos y Recuperación**](./operacion/respaldos.md) - Backup y restore

### 🔄 Roadmap y Mejoras

- [**Backlog Frontend**](./roadmap/backlog-frontend.md) - Mejoras planificadas
- [**Propuestas de Arquitectura**](./roadmap/propuestas-arquitectura.md) - Microfrontends, modernización
- [**Plan de Escalabilidad**](./roadmap/escalabilidad.md) - Crecimiento y performance

---

## 🚀 Inicio Rápido

### Para Desarrolladores

```bash
# 1. Clonar repositorios
git clone https://github.com/Atijaguar-ec/backend.git
git clone https://github.com/Atijaguar-ec/fe.git

# 2. Configurar variables de entorno (ver guías CI/CD)

# 3. Levantar con Docker Compose
cd backend
docker-compose up -d

cd fe
docker-compose up -d
```

**Siguiente paso**: [Guía de Instalación Completa](./despliegue/instalacion.md)

### Para Arquitectos

1. Leer [Arquitectura General](./arquitectura/arquitectura-general.md)
2. Revisar [Diagramas C4](./arquitectura/c4/)
3. Consultar [Decisiones de Arquitectura](./arquitectura/decisiones-arquitectura.md)

### Para DevOps

1. Leer [Guía CI/CD Backend](./backend/guia-cicd-backend.md)
2. Leer [Guía CI/CD Frontend](./frontend/guia-cicd-frontend.md) - **Nuevo**: Workflows separados por empresa
3. Consultar [Plantilla Workflows Frontend](./despliegue/plantilla-workflow-frontend-empresa.md)
4. Consultar [Despliegue en Producción](./despliegue/produccion.md)

---

## 🌍 Multi-Cadena y Multi-Tenant

INATrace soporta múltiples cadenas de valor con configuraciones independientes:

- **Cacao**: Trazabilidad de grano, fermentación, secado
- **Camarón**: Trazabilidad de larva, cultivo, procesamiento
- **Café**: Trazabilidad con blockchain Hyperledger Fabric

Cada cadena puede tener:
- Base de datos independiente
- Temas visuales personalizados
- Traducciones específicas
- Campos de negocio adaptados

**Más información**: [Arquitectura Multi-Cadena](./arquitectura/multi-cadena.md)

---

## 🤝 Contribuir

### Lineamientos de Documentación

Toda la documentación sigue estándares profesionales:

- **arc42** para estructura de arquitectura
- **C4** para diagramas visuales
- **Markdown** con formato consistente
- **Español** como idioma principal
- **Neutralidad** (sin referencias a empresas específicas)

**Leer**: [Lineamientos de Documentación](./lineamientos-documentacion.md)

### Proceso de Actualización

1. Crear o editar documentación siguiendo los [lineamientos](./lineamientos-documentacion.md)
2. Verificar enlaces internos y formato
3. Actualizar fecha de "Última actualización"
4. Hacer commit con mensaje descriptivo

---

## 📞 Soporte y Comunidad

- **Documentación**: Este repositorio
- **Issues**: Reportar problemas o sugerencias en GitHub Issues
- **Discusiones**: GitHub Discussions para preguntas técnicas

---

## 📄 Licencia

Ver archivo [LICENSE](./LICENSE) para más detalles.

---

**Mantenido por la comunidad INATrace**  
**Última actualización**: Noviembre 2026

---

## 📋 Changelog Reciente

### Diciembre 2025
- **CI/CD Frontend**: Arquitectura de workflows separados por empresa (pipelines independientes)
- **Mejoras DevOps**: Soporte para Jenkins como alternativa a GitHub Actions
