# Ficha Técnica: Backend INATrace

> **Audiencia**: Desarrolladores Backend, Arquitectos, DevOps  
> **Componente**: Backend  
> **Última actualización**: Noviembre 2025

## Descripción General

El backend de INATrace es una aplicación empresarial desarrollada en Java 17 con Spring Boot 3.3.3 que proporciona una API REST completa para el sistema de trazabilidad agrícola. Implementa una arquitectura robusta con patrones empresariales modernos, seguridad JWT, soporte multi-tenant nativo e integración con servicios externos.

**Características principales**:
- API REST completa con documentación OpenAPI 3.0
- Autenticación JWT con refresh tokens
- Multi-tenancy con aislamiento de datos por organización
- Auditoría automática de cambios
- Migraciones de BD controladas con Flyway
- Generación de QR codes únicos
- Procesamiento de archivos (Excel, PDF)

---

## Tabla de Contenidos

- [Tecnologías Principales](#tecnologias-principales)
- [Arquitectura del Proyecto](#arquitectura-del-proyecto)
- [Componentes Principales](#componentes-principales)
- [Características Técnicas](#caracteristicas-tecnicas)
- [Configuración](#configuracion)
- [Instalación Local](#instalacion-local)
- [Despliegue](#despliegue)
- [APIs REST](#apis-rest)
- [Seguridad](#seguridad)
- [Troubleshooting](#troubleshooting)
- [Recursos Adicionales](#recursos-adicionales)

---

## Tecnologías Principales

### Stack

| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Java** | 17 (LTS) | Lenguaje principal |
| **Spring Boot** | 3.3.3 | Framework empresarial |
| **Maven** | 3.8.5+ | Gestión de dependencias y build |
| **MySQL** | 8.0+ | Base de datos relacional |
| **Flyway** | 9.x | Migraciones de BD |
| **Hibernate** | 6.x | ORM (incluido en Spring Data JPA) |

### Dependencias Clave

#### Core Framework
```xml
<!-- Spring Boot Starters -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>
```

#### Base de Datos
```xml
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
</dependency>
<dependency>
    <groupId>org.flywaydb</groupId>
    <artifactId>flyway-mysql</artifactId>
</dependency>
```

#### Seguridad
```xml
<dependency>
    <groupId>com.auth0</groupId>
    <artifactId>java-jwt</artifactId>
    <version>4.4.0</version>
</dependency>
```

#### Documentación API
```xml
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.6.0</version>
</dependency>
```

### Dependencias Especializadas

| Librería | Versión | Uso |
|----------|---------|-----|
| **Spring Data Envers** | Incluido | Auditoría automática de entidades |
| **Apache POI** | 5.3.0 | Procesamiento de archivos Excel |
| **Apache PDFBox** | 3.0.3 | Generación y manipulación de PDFs |
| **Google ZXing** | 3.5.3 | Generación de códigos QR |
| **Apache Tika** | 2.9.2 | Detección de tipos MIME |
| **ImgScalr** | 4.2 | Escalado de imágenes |
| **Guava** | 33.3.0-jre | Utilidades de Java |
| **Mapbox SDK Turf** | 5.8.0 | Geolocalización |

---

## Arquitectura del Proyecto

### Estructura de Paquetes

```
com.abelium.inatrace/
├── INATraceBackendApplication.java    # Aplicación principal Spring Boot
│
├── api/                               # DTOs y respuestas API
│   ├── ApiResponse.java              # Wrapper estándar de respuestas
│   ├── ApiPaginatedResponse.java     # Respuestas paginadas
│   ├── errors/                       # Manejo centralizado de errores
│   └── types/                        # Tipos de datos API
│
├── components/                        # Módulos de negocio (DDD)
│   ├── user/                         # Usuarios y autenticación
│   ├── company/                      # Gestión empresarial multi-tenant
│   ├── product/                      # Productos y trazabilidad
│   ├── value_chain/                  # Cadenas de valor configurables
│   ├── facility/                     # Instalaciones de procesamiento
│   ├── payment/                      # Pagos y transacciones
│   ├── processingaction/             # Acciones de transformación
│   ├── stockorder/                   # Órdenes de stock (entregas/recepciones)
│   ├── mail/                         # Servicio de notificaciones
│   └── [otros componentes]/          # Módulos adicionales
│
├── configuration/                     # Configuraciones Spring
│   ├── ApplicationConfiguration.java
│   ├── WebConfig.java
│   └── AsyncConfiguration.java
│
├── db/                               # Capa de persistencia
│   ├── entities/                     # Entidades JPA con auditoría
│   ├── repositories/                 # Repositorios Spring Data
│   ├── migrations/                   # Migraciones Flyway
│   └── enums/                        # Enumeraciones de BD
│
├── security/                         # Seguridad
│   ├── configuration/                # Spring Security Config
│   ├── service/                      # Servicios de autenticación
│   └── utils/                        # Utilidades de seguridad (JWT, etc.)
│
└── types/                            # Enums y tipos del dominio
```

### Patrón de Organización por Componente

Cada componente en `components/` sigue estructura estándar:

```
components/[componente]/
├── api/                              # DTOs del componente
│   ├── Api[Entidad].java
│   └── Api[Entidad]Request.java
├── mappers/                          # Mapeo Entity ↔ DTO
│   └── [Entidad]Mapper.java
├── [Entidad]Controller.java          # REST Controller
├── [Entidad]Service.java             # Lógica de negocio
└── [Entidad]QueryRequest.java        # Filtros y paginación
```

---

## Componentes Principales

### 1. User Component - Gestión de Usuarios

**Responsabilidad**: Autenticación, autorización y gestión de usuarios.

**Archivos principales**:
- `UserController.java` - 15+ endpoints REST
- `UserService.java` - Lógica de negocio
- `NotificationService.java` - Emails y notificaciones

**Funcionalidades**:
- Registro con confirmación por email
- Login/Logout con JWT + Refresh Tokens
- Gestión de roles: `SYSTEM_ADMIN`, `REGIONAL_ADMIN`, `COMPANY_ADMIN`, `MANAGER`, `USER`
- Reset de contraseñas con tokens seguros
- Multi-empresa: Un usuario puede pertenecer a múltiples organizaciones
- Listado con filtros y paginación

### 2. Company Component - Multi-Tenancy

**Responsabilidad**: Gestión de organizaciones con aislamiento de datos.

**Funcionalidades**:
- CRUD completo de organizaciones
- Dashboard con métricas
- Gestión de usuarios por organización con roles granulares
- Importación masiva de productores desde Excel
- Configuración de cadenas de valor por organización
- Estado de onboarding

### 3. Product Component - Trazabilidad

**Responsabilidad**: Núcleo de trazabilidad de productos.

**Funcionalidades**:
- CRUD de productos con validaciones
- Gestión de etiquetas públicas (ProductLabel)
- Generación automática de QR codes únicos
- Trazabilidad completa de lotes (batches)
- Configuración de información pública para consumidores
- Múltiples idiomas por etiqueta
- Estadísticas de uso y feedback

### 4. StockOrder Component - Órdenes de Stock

**Responsabilidad**: Gestión de entregas, recepciones y procesamiento.

**Funcionalidades**:
- Órdenes de compra y recepción
- Tracking de cantidad y calidad (humedad, peso neto, tara, daños)
- Campos específicos por tipo de producto (ej: gavetas, bines para camarón)
- Documentos adjuntos (certificados, análisis de laboratorio)
- Cálculos automáticos de peso neto aplicando deducciones

### 5. Facility Component - Instalaciones

**Responsabilidad**: Gestión de ubicaciones físicas.

**Funcionalidades**:
- CRUD de instalaciones
- Coordenadas GPS con integración Mapbox
- Tipos configurables (bodega, laboratorio, centro de acopio, etc.)
- Certificaciones y documentos adjuntos

### 6. Payment Component - Sistema Financiero

**Responsabilidad**: Gestión de pagos a productores.

**Funcionalidades**:
- Órdenes de compra y venta
- Múltiples monedas con conversión
- Pagos a productores con tracking
- Comisiones y tarifas configurables
- Reportes financieros

---

## Características Técnicas

### 1. Seguridad JWT

**Configuración**:
```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(securedEnabled = true, jsr250Enabled = true)
public class SpringSecurityConfig {
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .sessionManagement(smc -> 
                smc.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests(matcherRegistry -> {
                matcherRegistry.requestMatchers("/api/public/**", "/api/user/login")
                    .permitAll();
                matcherRegistry.anyRequest().authenticated();
            })
            .addFilterBefore(tokenAuthenticationFilter(), 
                UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}
```

**Características**:
- **Tokens JWT**: Access (1h) + Refresh (5min) con rotación automática
- **Cookies HTTP-Only**: Almacenamiento seguro
- **Autorización granular**: Por método con `@PreAuthorize`
- **Contexto empresarial**: Verificación de permisos por organización
- **Endpoints públicos**: Trazabilidad sin autenticación

### 2. Multi-Tenancy Nativo

**Implementación**:
- **Aislamiento por organización**: Datos segregados automáticamente
- **Roles por contexto**: Permisos diferentes según organización activa
- **Cambio de contexto**: Sin re-autenticación
- **Herencia de permisos**: Roles globales + roles por organización

**Ejemplo de entidad**:
```java
@Entity
@Audited
public class User extends TimestampEntity {
    
    @Enumerated(EnumType.STRING)
    private UserRole role = UserRole.USER;
    
    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private Set<CompanyUser> userCompanies;  // Relación N:M con organizaciones
}
```

### 3. Auditoría Automática

**Hibernate Envers integrado**:
```java
@Entity
@Audited  // Tracking automático de cambios
@Table(indexes = {@Index(columnList = "status")})
public class Product extends TimestampEntity {
    
    @Version
    private long entityVersion;  // Control de concurrencia optimista
    
    // Todos los cambios se registran en tablas *_AUD
}
```

**Características**:
- Tracking automático de cambios
- Versionado con control de concurrencia
- Timestamps automáticos
- Usuario auditor registrado
- API para consultar historial

### 4. Migraciones Flyway

**Nomenclatura**:
```
V[YYYY]_[MM]_[DD]_[HH]_[MM]__[Descripcion].sql
```

**Ejemplo**:
```sql
-- V2025_10_30_02_00__Add_moisture_percentage_fields.sql
ALTER TABLE StockOrder 
  ADD COLUMN moisturePercentage DECIMAL(5,2),
  ADD COLUMN moistureWeightDeduction DECIMAL(38,2);
```

**Configuración**:
```properties
spring.flyway.baseline-on-migrate=true
spring.flyway.out-of-order=true
spring.flyway.validate-on-migrate=false
spring.flyway.locations=classpath:/db/migrations
```

### 5. Documentación API Automática

**OpenAPI 3.0 / Swagger UI**:

```java
@RestController
@RequestMapping("/api/product")
public class ProductController {
    
    @PostMapping("/create")
    @Operation(summary = "Create a new product")
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "Product created"),
        @ApiResponse(responseCode = "400", description = "Invalid input"),
        @ApiResponse(responseCode = "403", description = "Insufficient permissions")
    })
    public ApiResponse<ApiProduct> createProduct(@RequestBody ApiProductRequest request) {
        // ...
    }
}
```

**Acceso**: `http://[servidor]/swagger-ui.html`

---

## Configuración

### Variables de Entorno

| Variable | Descripción | Ejemplo | Requerido |
|----------|-------------|---------|-----------|
| `INATrace_DB_HOST` | Host de MySQL | `localhost` | ✅ |
| `INATrace_DB_PORT` | Puerto de MySQL | `3306` | ✅ |
| `INATrace_DB_NAME` | Nombre de BD | `inatrace` | ✅ |
| `INATrace_DB_USERNAME` | Usuario MySQL | `inatrace_user` | ✅ |
| `INATrace_DB_PASSWORD` | Password MySQL | `(secreto)` | ✅ |
| `INATrace_JWT_SECRET` | Secret para JWT | `(secreto largo)` | ✅ |
| `INATrace_SMTP_HOST` | Host SMTP | `smtp.gmail.com` | No |
| `INATrace_SMTP_PORT` | Puerto SMTP | `587` | No |
| `INATrace_SMTP_USERNAME` | Usuario email | `noreply@example.com` | No |
| `INATrace_SMTP_PASSWORD` | Password email | `(secreto)` | No |

### Profiles de Spring

| Profile | Descripción | Uso |
|---------|-------------|-----|
| `dev` | Desarrollo local | Logs verbose, H2 console |
| `test` | Testing automatizado | BD en memoria |
| `prod` | Producción | Logs ERROR, configuración optimizada |

**Activar profile**:
```bash
export SPRING_PROFILES_ACTIVE=prod
```

### Archivo `application.yml`

```yaml
spring:
  application:
    name: INATrace Backend
  datasource:
    url: jdbc:mysql://${INATrace_DB_HOST}:${INATrace_DB_PORT}/${INATrace_DB_NAME}
    username: ${INATrace_DB_USERNAME}
    password: ${INATrace_DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: validate  # Flyway maneja DDL
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
  flyway:
    baseline-on-migrate: true
    out-of-order: true

server:
  port: 8080
  
logging:
  level:
    root: INFO
    com.abelium.inatrace: DEBUG
```

---

## Instalación Local

### Requisitos del Sistema

- **Java**: 17 o superior (LTS recomendado)
- **Maven**: 3.8.5+
- **MySQL**: 8.0+
- **Git**: Para clonar repositorio
- **(Opcional) Docker**: 20.10+ para MySQL containerizado

### Pasos de Instalación

#### 1. Clonar Repositorio

```bash
git clone https://github.com/Atijaguar-ec/backend.git
cd backend
```

#### 2. Configurar Base de Datos

**Opción A: MySQL local**

```bash
mysql -u root -p
```

```sql
CREATE DATABASE inatrace CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'inatrace_user'@'localhost' IDENTIFIED BY 'password_seguro';
GRANT ALL PRIVILEGES ON inatrace.* TO 'inatrace_user'@'localhost';
FLUSH PRIVILEGES;
```

**Opción B: MySQL con Docker**

```bash
docker run --name mysql-inatrace \
  -e MYSQL_ROOT_PASSWORD=root_password \
  -e MYSQL_DATABASE=inatrace \
  -e MYSQL_USER=inatrace_user \
  -e MYSQL_PASSWORD=password_seguro \
  -p 3306:3306 \
  -d mysql:8.0
```

#### 3. Configurar Variables de Entorno

Crear archivo `.env` en la raíz:

```bash
# Base de datos
export INATrace_DB_HOST=localhost
export INATrace_DB_PORT=3306
export INATrace_DB_NAME=inatrace
export INATrace_DB_USERNAME=inatrace_user
export INATrace_DB_PASSWORD=password_seguro

# JWT
export INATrace_JWT_SECRET="un-secret-muy-largo-y-seguro-minimo-256-bits"

# Email (opcional para desarrollo)
export INATrace_SMTP_HOST=smtp.gmail.com
export INATrace_SMTP_PORT=587
export INATrace_SMTP_USERNAME=tu_email@gmail.com
export INATrace_SMTP_PASSWORD=tu_password_app
```

Cargar variables:
```bash
source .env
```

#### 4. Compilar y Ejecutar

```bash
# Compilar (incluye tests)
mvn clean package

# Ejecutar
java -jar target/INATrace-Backend-*.jar

# O directamente con Maven
mvn spring-boot:run
```

#### 5. Verificar Instalación

```bash
# Health check
curl http://localhost:8080/actuator/health

# Swagger UI
open http://localhost:8080/swagger-ui.html
```

---

## Despliegue

Ver [Guía CI/CD Backend](./guia-cicd-backend.md) para:
- Despliegue con Docker y Docker Compose
- Integración con GitHub Actions
- Configuración de secrets
- Despliegue en servidores cloud
- Estrategias de rollback

### Despliegue Rápido con Docker

```bash
# Build
docker build -t inatrace-backend:latest .

# Run
docker run -d \
  --name inatrace-backend \
  -p 8080:8080 \
  -e INATrace_DB_HOST=mysql \
  -e INATrace_DB_PORT=3306 \
  -e INATrace_DB_NAME=inatrace \
  -e INATrace_DB_USERNAME=inatrace_user \
  -e INATrace_DB_PASSWORD=password_seguro \
  -e INATrace_JWT_SECRET="secret-largo-y-seguro" \
  inatrace-backend:latest
```

---

## APIs REST

### Estructura de Respuestas

Todas las respuestas siguen formato estándar:

```json
{
  "status": "OK",
  "data": { ... },
  "errorMessage": null
}
```

### Endpoints Principales

| Endpoint | Método | Descripción | Auth |
|----------|--------|-------------|------|
| `/api/user/login` | POST | Autenticación | No |
| `/api/user/register` | POST | Registro de usuario | No |
| `/api/company/list` | GET | Listar organizaciones | Sí |
| `/api/product/list` | GET | Listar productos | Sí |
| `/api/stock-order/create` | POST | Crear entrega/recepción | Sí |
| `/api/public/product/{uuid}` | GET | Info pública de producto | No |

### Autenticación

**Login**:
```bash
curl -X POST http://localhost:8080/api/user/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin@example.com","password":"password"}'
```

**Respuesta**:
```json
{
  "status": "OK",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "...",
    "user": {
      "id": 1,
      "email": "admin@example.com",
      "role": "COMPANY_ADMIN"
    }
  }
}
```

**Usar token**:
```bash
curl -H "Authorization: Bearer eyJhbGciOiJIUzI..." \
  http://localhost:8080/api/product/list
```

### Documentación Completa

Ver [APIs REST](./apis-rest.md) para documentación completa de endpoints.

**Swagger UI**: `http://[servidor]/swagger-ui.html`

---

## Seguridad

### Mejores Prácticas Implementadas

- ✅ **Autenticación JWT** con tokens de corta duración
- ✅ **HTTPS obligatorio** en producción
- ✅ **Cookies HTTP-Only** para almacenar tokens
- ✅ **CORS configurado** para dominios permitidos
- ✅ **Rate limiting** en endpoints públicos
- ✅ **Sanitización de inputs** contra SQL injection
- ✅ **Validación de permisos** por organización
- ✅ **Auditoría** de acciones críticas

### Configuración de Producción

```yaml
# application-prod.yml
server:
  ssl:
    enabled: true
    key-store: classpath:keystore.p12
    key-store-password: ${SSL_KEYSTORE_PASSWORD}
    key-store-type: PKCS12
  
spring:
  jpa:
    show-sql: false
  
logging:
  level:
    root: ERROR
    com.abelium.inatrace: INFO
```

### Secrets Management

> 🔐 **Seguridad**: Nunca commitear credenciales en el repositorio.

Usar:
- Variables de entorno
- GitHub Secrets para CI/CD
- Vault o servicios de gestión de secrets en producción

---

## Troubleshooting

Ver [Troubleshooting Backend](./troubleshooting-backend.md) para guía detallada.

### Problemas Comunes

#### Error: Connection Refused

**Síntoma**:
```
com.mysql.cj.jdbc.exceptions.CommunicationsException: 
Communications link failure
```

**Solución**:
```bash
# Verificar que MySQL esté corriendo
docker ps | grep mysql

# Verificar conectividad
telnet localhost 3306
```

#### Error: Flyway Migration Failed

**Síntoma**:
```
FlywayException: Validate failed: 
Migration checksum mismatch
```

**Solución**:
```bash
# En desarrollo, limpiar y recrear BD
mvn flyway:clean
mvn flyway:migrate

# O manualmente
mysql -u root -p -e "DROP DATABASE inatrace; CREATE DATABASE inatrace;"
```

#### Performance Lento

**Verificar**:
- Índices en tablas grandes
- Tamaño de pool de conexiones
- Queries N+1 (usar `@Fetch` o JOIN FETCH)
- Logs de Hibernate en DEBUG

---

## Recursos Adicionales

### Documentación Oficial

- [Spring Boot](https://spring.io/projects/spring-boot)
- [Spring Security](https://spring.io/projects/spring-security)
- [Spring Data JPA](https://spring.io/projects/spring-data-jpa)
- [Flyway](https://flywaydb.org/documentation/)
- [MySQL 8.0](https://dev.mysql.com/doc/refman/8.0/en/)

### Documentación INATrace

- [Arquitectura General](../arquitectura/arquitectura-general.md)
- [Guía CI/CD Backend](./guia-cicd-backend.md)
- [Modelo de Datos](../base-datos/modelo-datos.md)
- [Troubleshooting Backend](./troubleshooting-backend.md)

### Código Fuente

- Repositorio: `https://github.com/Atijaguar-ec/backend`
- Issues: `https://github.com/Atijaguar-ec/backend/issues`

---

**Última actualización**: Noviembre 2025
