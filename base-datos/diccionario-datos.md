# Diccionario de Datos INATrace

> **Audiencia**: Analistas, Desarrolladores, QA  
> **Componente**: Base de Datos  
> **Última actualización**: Noviembre 2025

Este documento sirve como referencia para los códigos, enumeraciones y valores estándar utilizados en la base de datos de INATrace.

---

## 1. Estados de Entidades

### Stock Order Status (`StockOrderStatus`)
Define el ciclo de vida de una orden de movimiento o proceso.

| Código | Descripción | Transiciones Permitidas |
|--------|-------------|-------------------------|
| `DRAFT` | Borrador. Editable, no afecta inventario oficial. | -> `COMPLETED`, `CANCELLED` |
| `COMPLETED` | Finalizada. Afecta inventario. Inmutable (salvo admin). | Ninguna (estado final) |
| `CANCELLED` | Anulada. No afecta inventario. | Ninguna (estado final) |

### User Status (`UserStatus`)
Ciclo de vida de una cuenta de usuario.

| Código | Descripción |
|--------|-------------|
| `PENDING` | Registrado, email no confirmado. |
| `ACTIVE` | Email confirmado y activado por admin. Puede hacer login. |
| `DISABLED` | Desactivado administrativamente. Login bloqueado. |
| `DELETED` | Borrado lógico (GDPR/Privacidad). |

---

## 2. Roles y Permisos

### Roles de Sistema (`UserRole`)
Nivel de acceso global a la plataforma.

| Rol | Alcance | Descripción |
|-----|---------|-------------|
| `SYSTEM_ADMIN` | Global | Acceso total a configuración de sistema, tenants y logs. |
| `REGIONAL_ADMIN`| Múltiple | Administra un grupo de empresas/tenants. |
| `USER` | Tenant | Usuario estándar. Sus permisos dependen de su rol en la empresa. |

### Roles de Empresa (`CompanyUserRole`)
Nivel de acceso dentro de una organización específica.

| Rol | Descripción |
|-----|-------------|
| `ADMIN` | Gestión total de la empresa (usuarios, configuración, productos). |
| `MANAGER` | Operación completa (crear órdenes, ver reportes). |
| `OFFICER` | Operación limitada (solo registro de datos, sin ver precios). |
| `VIEWER` | Solo lectura (auditoría, visualización). |

---

## 3. Tipos de Producto (`ProductType`)

Categorización de los bienes en la cadena de valor.

| Código | Descripción | Ejemplo Cacao | Ejemplo Camarón |
|--------|-------------|---------------|-----------------|
| `RAW` | Materia prima directa del campo. | Cacao en baba | Larva / Camarón vivo |
| `SEMI` | Producto en proceso o intermedio. | Cacao seco | Camarón descabezado |
| `FINAL` | Producto terminado para venta/consumo. | Barra de chocolate | Caja congelada 2kg |

---

## 4. Unidades de Medida (`MeasuringUnit`)

Códigos estándar para cantidades. El sistema maneja conversiones base.

| Código | Nombre | Categoría | Conversión Base (kg) |
|--------|--------|-----------|---------------------|
| `KG` | Kilogramo | Peso | 1.0 |
| `LB` | Libra | Peso | 0.453592 |
| `QQ` | Quintal | Peso | 46.0 (Variable según config) |
| `MT` | Tonelada Métrica | Peso | 1000.0 |
| `L` | Litro | Volumen | N/A |
| `UNIT` | Unidad | Conteo | N/A |

---

## 5. Tipos de Instalación (`FacilityType`)

Define qué operaciones pueden realizarse en una ubicación.

| Código | Descripción | Operaciones Típicas |
|--------|-------------|---------------------|
| `FARM` | Finca / Granja | Origen, Cosecha. |
| `COLLECTION_CENTER` | Centro de Acopio | Recepción, Pesaje, Control Calidad inicial. |
| `PROCESSING_PLANT` | Planta de Proceso | Transformación, Empacado, Etiquetado. |
| `WAREHOUSE` | Bodega | Almacenamiento, Despacho. |
| `LABORATORY` | Laboratorio | Análisis de calidad, Certificación. |
| `OFFICE` | Oficina | Administrativo. |

---

## 6. Campos Específicos por Cadena

Aunque el esquema es genérico, ciertos campos se usan diferente según la cadena.

### Cacao (`COCOA`)
- `moisturePercentage`: Crítico para cálculo de precio (seco vs húmedo).
- `fermentationGrade`: Porcentaje de fermentación.

### Camarón (`SHRIMP`)
- `binCode`: Identificador del contenedor plástico de transporte.
- `poolNumber`: Número de piscina de origen.
- `glazingPercentage`: Porcentaje de glaseado (hielo) en producto final.

---

**Última actualización**: Noviembre 2025
