# INATrace - Documentación Técnica Oficial

**INATrace** es una plataforma integral de trazabilidad para cadenas de valor agrícola que permite el seguimiento completo de productos desde la producción hasta el consumidor final, garantizando transparencia, calidad y sostenibilidad en toda la cadena de suministro.

> **Audiencia**: Desarrolladores, Arquitectos, DevOps, Analistas de Negocio  
> **Versión**: 2.0  
> **Última actualización**: Noviembre 2025

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
git clone https://github.com/your-org/inatrace-backend.git
git clone https://github.com/your-org/inatrace-frontend.git

# 2. Configurar variables de entorno (ver guías CI/CD)

# 3. Levantar con Docker Compose
cd inatrace-backend
docker-compose up -d

cd inatrace-frontend
docker-compose up -d
```

**Siguiente paso**: [Guía de Instalación Completa](./despliegue/instalacion.md)

### Para Arquitectos

1. Leer [Arquitectura General](./arquitectura/arquitectura-general.md)
2. Revisar [Diagramas C4](./arquitectura/c4/)
3. Consultar [Decisiones de Arquitectura](./arquitectura/decisiones-arquitectura.md)

### Para DevOps

1. Leer [Guía CI/CD Backend](./backend/guia-cicd-backend.md)
2. Leer [Guía CI/CD Frontend](./frontend/guia-cicd-frontend.md)
3. Consultar [Despliegue en Producción](./despliegue/produccion.md)

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
**Última actualización**: Noviembre 2025
