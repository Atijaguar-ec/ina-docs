# Manual de Operación y Mantenimiento · Plataforma INATrace

> **Audiencia**: Operación, Soporte Técnico, DevOps  
> **Componentes**: Backend, Frontend, Mobile  
> **Última actualización**: Noviembre 2025

Este manual resume las tareas clave de **operación diaria**, **mantenimiento planificado** y **gestión de incidencias** de la plataforma INATrace, de forma complementaria a las guías de CI/CD y troubleshooting.

---

## 1. Roles y Responsabilidades

- **Operación / Soporte de Primer Nivel**
  - Monitorear disponibilidad básica de servicios.
  - Atender incidencias reportadas por usuarios finales.
  - Escalar a segundo nivel cuando se requiera análisis técnico.

- **Soporte Técnico / DevOps**
  - Gestionar despliegues siguiendo las guías CI/CD.
  - Ejecutar ventanas de mantenimiento planificado.
  - Supervisar backups y restauraciones de prueba.

- **Equipo de Desarrollo**
  - Analizar errores complejos y bugs.
  - Proponer y ejecutar mejoras técnicas según el roadmap.

---

## 2. Operación Diaria

### 2.1 Verificación de Salud de Servicios

- Comprobar periódicamente (o mediante herramientas de monitoreo) que:
  - Backend responde en su endpoint de salud (ejemplo genérico):
    - `https://backend.example.com/api/health`
  - Frontend es accesible y rinde el dashboard principal.
  - Mobile puede sincronizar con la API sin errores recurrentes.

- Ante un problema detectado, consultar primero:
  - [Troubleshooting Backend](../backend/troubleshooting-backend.md)
  - (En el futuro) Troubleshooting Frontend / Mobile.

### 2.2 Revisión de Logs y Alertas

- Revisar logs de errores (nivel ERROR) en:
  - Contenedores backend.
  - Frontend (error tracking) si está configurado.
  - Servicios de infraestructura relevantes (base de datos, balanceadores, etc.).

- Asegurarse de que:
  - Logs se rotan adecuadamente.
  - No crecen sin control en disco.

---

## 3. Mantenimiento Planificado

### 3.1 Ventanas de Mantenimiento

- Toda intervención que pueda afectar disponibilidad debe:
  - Planificarse con anticipación.
  - Documentarse utilizando el [Formato de Ventana de Mantenimiento](./formato-ventana-mantenimiento.md).
  - Comunicarse a los usuarios según el plan de comunicación definido.

### 3.2 Actividades Típicas en Una Ventana

- Actualización de versión de backend/frontend/mobile.
- Aplicación de migraciones de base de datos.
- Cambios en configuración de infraestructura (por ejemplo, Nginx o certificados).
- Tareas de mantenimiento de base de datos (índices, particionamiento, limpieza).

### 3.3 Criterios de Éxito

- Todos los endpoints de salud en verde.
- Pruebas de humo aprobadas:
  - Login y flujo mínimo de negocio por módulo.
- Sin errores críticos nuevos en logs tras la ventana.

---

## 4. Backups y Restauración

### 4.1 Política General

- Se recomienda mantener:
  - Backups automáticos de base de datos con frecuencia diaria (o mayor según política de la organización).
  - Pruebas periódicas de restauración en un entorno de pruebas.

### 4.2 Procedimiento General de Backup

1. Verificar espacio en disco en el destino de backups.
2. Generar backup completo de las bases de datos de la plataforma.
3. Verificar que el backup se completa sin errores.
4. Registrar fecha, hora y responsable.

### 4.3 Pruebas de Restauración

1. Elegir un backup reciente.
2. Restaurar en un entorno aislado de pruebas.
3. Verificar que:
   - Estructuras de tablas son correctas.
   - Datos críticos son accesibles.
4. Documentar resultados y problemas encontrados.

---

## 5. Gestión de Incidencias

### 5.1 Clasificación Básica

- **Incidencia crítica**: servicio no disponible o datos incorrectos a gran escala.
- **Incidencia mayor**: parte relevante de la funcionalidad afectada.
- **Incidencia menor**: errores puntuales que tienen workaround.

### 5.2 Flujo de Atención

1. Recepción de la incidencia (usuario, monitoreo, QA).
2. Registro con información mínima:
   - Fecha y hora.
   - Usuario y área afectada.
   - Descripción y pasos para reproducir.
3. Verificar si el problema está ya documentado en las guías de troubleshooting.
4. Escalar a desarrollo/DevOps si:
   - Requiere análisis de logs avanzado.
   - Implica cambios en configuración o código.

### 5.3 Información Útil para Escalamiento

- Entorno afectado (dev, testing, producción).
- Logs relevantes (extracto, no volcados completos sin contexto).
- Capturas de pantalla y trazas de error.
- Pasos ya realizados (incluyendo referencias a esta guía).

---

## 6. Relación con CI/CD y Testing

- Cualquier cambio que pase por ventana de mantenimiento debe:
  - Seguir los procedimientos descritos en las guías de CI/CD:
    - [Backend](../backend/guia-cicd-backend.md)
    - [Frontend](../frontend/guia-cicd-frontend.md)
    - [Mobile](../mobile/guia-cicd-mobile.md)
  - Contar con pruebas apropiadas según la [Estrategia de Testing](../testing/estrategia-testing.md).

---

## 7. Próximos Pasos Recomendados

- Completar y adaptar el [Formato de Ventana de Mantenimiento](./formato-ventana-mantenimiento.md) para las prácticas de la organización.
- Definir un calendario de mantenimientos preventivos (infraestructura, base de datos, actualizaciones de seguridad).
- Integrar esta guía en los procesos internos de operación y soporte.
