# Guía de Migraciones de Base de Datos

> **Audiencia**: Desarrolladores Backend, DBAs  
> **Herramienta**: Flyway 9.x  
> **Última actualización**: Noviembre 2025

## Descripción General

INATrace utiliza **Flyway** para gestionar el versionado y evolución del esquema de base de datos. Esto asegura que todos los entornos (Desarrollo, Test, Producción) tengan la misma estructura de datos de manera reproducible y auditable.

---

## Flujo de Trabajo

1. **Desarrollo**: El desarrollador crea un script SQL localmente.
2. **Ejecución**: Al iniciar la aplicación (`mvn spring-boot:run`), Flyway detecta el nuevo archivo y lo aplica.
3. **Commit**: El archivo SQL se sube al repositorio Git.
4. **CI/CD**: El pipeline ejecuta las migraciones automáticamente en los entornos destino antes de desplegar la nueva versión del código.

---

## Estándar de Nombramiento

Los archivos de migración deben seguir estrictamente este formato para garantizar el orden correcto de ejecución:

`V<YYYY>_<MM>_<DD>_<HH>_<mm>__<Descripcion_Descriptiva>.sql`

- **Prefijo**: `V` (mayúscula).
- **Timestamp**: Año, Mes, Día, Hora, Minuto (orden cronológico).
- **Separador**: Doble guión bajo `__`.
- **Descripción**: Snake_case, descriptiva, en inglés (estándar de código).
- **Extensión**: `.sql`.

**Ejemplos Correctos**:
- `V2025_11_21_10_30__Create_product_table.sql`
- `V2025_11_21_14_00__Add_moisture_column_to_stock.sql`

**Ejemplos Incorrectos**:
- `v1.0__create_tables.sql` (Falta timestamp)
- `V2025-11-21__Fix.sql` (Formato de fecha incorrecto)

---

## Ubicación de Archivos

```
backend/
├── src/
│   ├── main/
│   │   ├── resources/
│   │   │   └── db/
│   │   │       └── migrations/  <-- AQUÍ van los scripts .sql
```

---

## Buenas Prácticas SQL

### 1. Idempotencia (Safe Guards)
Aunque Flyway garantiza ejecución única, es buena práctica escribir DDL robusto.

```sql
-- Preferible
CREATE TABLE IF NOT EXISTS my_table ...;
ALTER TABLE my_table ADD COLUMN IF NOT EXISTS new_col ...; -- (MySQL 8.0+)
```

### 2. Nomenclatura de Base de Datos
- **Tablas**: `PascalCase`, singular, alineadas con las entidades JPA (ej: `StockOrder`, `CompanyUser`).
- **Columnas**: `camelCase` para campos de negocio y sufijo `_id` para claves foráneas (ej: `creationTimestamp`, `company_id`, `quality_document_id`).
- **FKs**: `fk_<TablaOrigen>_<TablaDestino>` (Flyway/Hibernate suelen generar nombres automáticos, pero si se hace manual, seguir esto).

### 3. Datos Maestros
Si la migración inserta datos fijos (ej: tipos de producto iniciales), usar `INSERT IGNORE` o verificar existencia.

```sql
INSERT IGNORE INTO product_type (code, name) VALUES ('RAW', 'Materia Prima');
```

---

## Troubleshooting Común

### Error: `Migration Checksum Mismatch`

**Causa**: Un archivo de migración que ya fue ejecutado (y registrado en `flyway_schema_history`) ha sido modificado físicamente. Flyway detecta que el hash del archivo cambió.

**Solución (Desarrollo)**:
1. `mvn flyway:repair` (Actualiza el checksum en la BD si el cambio es legítimo y seguro).
2. O borrar el registro fallido en `flyway_schema_history`.
3. O, si es dev local, borrar la BD y recrearla (`mvn flyway:clean flyway:migrate`).

**Solución (Producción)**:
❌ **NUNCA** modificar un script ya desplegado en producción.
✅ Crear un **NUEVO** script de migración con los cambios correctivos (`V...__Fix_previous_error.sql`).

### Error: `Migration failed`

**Causa**: Error de sintaxis SQL o violación de constraints.

**Acción**:
1. Corregir el script SQL.
2. Eliminar la fila "FAILED" de la tabla `flyway_schema_history`.
3. Reiniciar la aplicación.

---

## Comandos Útiles (Maven)

```bash
# Limpiar esquema (BORRA TODOS LOS DATOS - Cuidado!)
mvn flyway:clean -Dflyway.url=...

# Ejecutar migraciones pendientes
mvn flyway:migrate

# Validar integridad
mvn flyway:validate

# Reparar metadata (checksums)
mvn flyway:repair
```

---

**Última actualización**: Noviembre 2025
