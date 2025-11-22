# Lineamientos de Documentación INATrace

Estándares para mantener la documentación del proyecto INATrace de manera consistente, profesional y reutilizable a nivel mundial.

> **Versión**: 2.0  
> **Última actualización**: Noviembre 2025

---

## 🎯 Principios Fundamentales

### 1. Neutralidad Organizacional

**Hacer**:
- Usar términos genéricos: "la organización", "el operador", "la cooperativa"
- Marcar configuraciones concretas como "**Ejemplo:**"

**No hacer**:
- Mencionar nombres de empresas específicas
- Incluir datos sensibles (IPs privadas, credenciales)

### 2. Ejemplos Basados en Casos Reales

Se usan implementaciones de **cacao** y **camarón** como referencia, siempre marcados explícitamente como ejemplos adaptables.

**Formato estándar**:

````markdown
**Ejemplo: Configuración para cadena de cacao**
```bash
PRIMARY_PRODUCT_TYPE=COCOA
DOMAIN=cacao.example.com
```
````

### 3. Separación por Componentes

- **Backend** (Java, Spring Boot, MySQL)
- **Frontend** (Angular, TypeScript)
- **Mobile** (React Native, Expo)
- **Blockchain** (Hyperledger Fabric)

### 4. Modelos de Referencia

- **arc42**: Estructura de arquitectura
- **C4**: Diagramas (Context, Container, Component)
- **Diátaxis**: Organización de contenido

---

## 🌐 Idioma

- **Principal**: Español (100%)
- **Nombres de archivos**: minúsculas, sin acentos ni ñ, guiones
- **Excepciones**: Términos técnicos (Docker, API, REST, Git, CI/CD)

### Ejemplos de Nombres

```
✅ ficha-tecnica-backend.md
✅ guia-cicd-frontend.md
✅ arquitectura-multi-cadena.md

❌ Ficha-Tecnica-Backend.md (mayúsculas)
❌ guía_cicd_frontend.md (acentos, guión bajo)
```

---

## 📁 Estructura de Archivos

```
ina-docs/
├── README.md
├── lineamientos-documentacion.md
├── arquitectura/              # arc42 + C4
├── base-datos/                # Modelo, ERD, migraciones
├── backend/                   # Java + Spring Boot
├── frontend/                  # Angular + TypeScript
├── mobile/                    # React Native
├── blockchain/                # Hyperledger Fabric
├── formularios/               # Campos de negocio
├── despliegue/                # Docker, producción, Nginx
├── testing/                   # QA y estrategias
├── operacion/                 # Procedimientos operativos
└── roadmap/                   # Mejoras planificadas
```

---

## 📝 Formato Markdown

### Estructura Estándar

```markdown
# Título Principal

> **Audiencia**: Desarrolladores Backend  
> **Componente**: Backend  
> **Última actualización**: Noviembre 2025

Descripción breve (1-3 párrafos).

## Tabla de Contenidos (opcional)

## Sección Principal

### Subsección

Contenido...

**Ejemplo: Configuración específica**
```bash
# Código de ejemplo
```

## Recursos Adicionales

- [Enlace interno](./otro.md)
- [Documentación externa](https://example.com)

---

**Última actualización**: Noviembre 2025
```

### Jerarquía

- **H1**: Título principal (uno por documento)
- **H2**: Secciones principales
- **H3**: Subsecciones
- **H4**: Detalles (con moderación)

### Enlaces

```markdown
<!-- Internos (rutas relativas) -->
[Arquitectura](./arquitectura/arquitectura-general.md)

<!-- Externos -->
[Spring Boot](https://spring.io/projects/spring-boot)
```

### Código

````markdown
<!-- Inline -->
El comando `docker-compose up` inicia servicios.

<!-- Bloques (siempre especificar lenguaje) -->
```bash
docker build -t inatrace-backend:latest .
docker push registry.example.com/inatrace-backend:latest
```
````

Lenguajes: `bash`, `java`, `typescript`, `json`, `yaml`, `sql`, `properties`, `xml`, `dockerfile`, `nginx`

### Tablas

```markdown
| Variable | Tipo | Descripción | Default |
|----------|------|-------------|---------|
| `DB_HOST` | String | Host MySQL | `localhost` |
| `DB_PORT` | Integer | Puerto | `3306` |
```

### Callouts

```markdown
> ⚠️ **Advertencia**: Solo para desarrollo.
> ✅ **Buena práctica**: Usar variables de entorno.
> 💡 **Consejo**: Mejorar con pool de conexiones.
> 🔐 **Seguridad**: No commitear credenciales.
```

### Emojis

| Emoji | Uso |
|-------|-----|
| 🏗️ | Arquitectura |
| 🔧 | Técnico/Configuración |
| 📝 | Documentación |
| 🚀 | Despliegue/Mejoras |
| ⚠️ | Advertencias |
| ✅ | Correcto/Completado |
| ❌ | Incorrecto/Error |
| 🔐 | Seguridad |
| 🗄️ | Base de datos |
| 🎨 | Frontend/UI |
| 📱 | Mobile |
| ⛓️ | Blockchain |
| 🧪 | Testing |
| 💡 | Consejo |

---

## 📋 Plantillas

### Ficha Técnica

**Archivo**: `ficha-tecnica-[componente].md`

```markdown
# Ficha Técnica: [Componente]

> **Audiencia**: Desarrolladores  
> **Componente**: Backend  
> **Última actualización**: Noviembre 2025

## Descripción General
## Tecnologías Principales
## Dependencias
## Estructura del Proyecto
## Configuración
## Requisitos del Sistema
## Instalación Local
## Despliegue
## APIs/Interfaces
## Seguridad
## Troubleshooting
## Recursos Adicionales
```

### Guía CI/CD

**Archivo**: `guia-cicd-[componente].md`

```markdown
# Guía CI/CD: [Componente]

> **Audiencia**: DevOps, Desarrolladores  
> **Componente**: Backend  
> **Última actualización**: Noviembre 2025

## Descripción General
## Flujo del Pipeline
## Requisitos Previos
## Configuración GitHub Actions
## Variables y Secrets
## Proceso de Despliegue
## Ejemplos de Configuración
## Rollback
## Troubleshooting
## Mejores Prácticas
```

### Troubleshooting

**Archivo**: `troubleshooting-[componente].md`

```markdown
# Troubleshooting: [Componente]

> **Audiencia**: Desarrolladores, Operadores  
> **Componente**: Backend  
> **Última actualización**: Noviembre 2025

## Problema 1: [Título]

### Síntoma
### Causa
### Solución
### Prevención

---

## Problema 2: [Título]
...
```

---

## ✏️ Mejores Prácticas

### Claridad
- Oraciones cortas (máx. 20-25 palabras)
- Definir acrónimos la primera vez
- Voz activa
- Un concepto por párrafo

### Estructura
- Empezar con lo más importante
- Usar listas para secuencias
- Tabla de contenidos si >5 secciones

### Ejemplos
- Proporcionar ejemplos prácticos
- Comandos completos y ejecutables
- Añadir comentarios explicativos
- Marcar claramente como "Ejemplo:"

### Mantenimiento
- Actualizar fecha en cada cambio
- Registro de cambios en docs evolutivos
- Revisar enlaces cuando se reorganice

---

## ✅ Lista de Verificación

### Contenido
- [ ] Documento 100% en español (salvo términos técnicos)
- [ ] Metadatos al inicio (audiencia, componente, fecha)
- [ ] Descripción clara del propósito
- [ ] Principio de neutralidad aplicado
- [ ] Ejemplos marcados como "Ejemplo:"

### Formato
- [ ] Nombre de archivo: minúsculas, guiones, sin acentos
- [ ] Estructura sigue plantilla correspondiente
- [ ] Encabezados jerarquizados correctamente
- [ ] Bloques de código especifican lenguaje
- [ ] Tablas correctamente formateadas

### Enlaces
- [ ] Enlaces internos usan rutas relativas
- [ ] Todos los enlaces funcionan
- [ ] Imágenes tienen texto alternativo
- [ ] Referencias a docs relacionados

### Metadata
- [ ] Fecha de última actualización
- [ ] Audiencia especificada
- [ ] Componente identificado
- [ ] Historial de cambios (si aplica)

---

## 🔄 Proceso de Actualización

1. **Crear/Editar**: Seguir lineamientos y plantillas
2. **Revisar**: Verificar formato y enlaces
3. **Actualizar**: Fecha y historial de cambios
4. **Commit**: Mensaje descriptivo
5. **PR/Review**: Si aplica proceso de revisión

---

**Última actualización**: Noviembre 2025
