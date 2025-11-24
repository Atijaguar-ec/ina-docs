# Formato de Ventana de Mantenimiento · INATrace

Plantilla oficial para planificar, comunicar y ejecutar una ventana de mantenimiento de INATrace.  
Este formato es genérico y puede adaptarse a las políticas de cada organización.

---

## 1. Identificación
- Título: 
- ID Cambio/Mantenimiento: 
- Solicitante: 
- Responsable (Change Owner): 
- Aprobadores: 
- Fecha de solicitud: 

## 2. Objetivo
- Describir el propósito del mantenimiento y el beneficio esperado.

## 3. Alcance
- Componentes involucrados (backend, frontend, mobile, infraestructura): 
- Entornos: Producción / Staging / QA / Dev
- Actividades incluidas: 
- Actividades excluidas: 

## 4. Impacto al Servicio
- Ventana de indisponibilidad (sí/no): 
- Duración estimada de indisponibilidad: 
- Degradación esperada (si no hay indisponibilidad total): 
- Usuarios/áreas afectadas: 

## 5. Cronograma de la Ventana
- Fecha: 
- Hora de inicio (zona horaria local): 
- Hora de fin (zona horaria local): 
- Duración total estimada: 

## 6. Plan de Trabajo (Paso a Paso)
1. Preparación previa (backups, verificación de accesos, congelamiento de cambios, etc.)
2. Acciones durante la ventana (por orden):
   - 
3. Verificación post-ejecución (health checks, pruebas de humo, validaciones funcionales clave)

## 7. Plan de Contingencia y Rollback
- Criterios de activación de rollback: 
- Pasos de rollback con responsables: 
- ETA de restauración de servicio: 

## 8. Requerimientos y Dependencias
- Accesos (SSH/credenciales), llaves y permisos verificados
- Disponibilidad de personal clave (DevOps, Backend, Frontend, QA)
- Ventanas previas/solapadas con otros sistemas
- Disponibilidad de copias de seguridad/restauración

## 9. Comunicación
- Público objetivo: usuarios finales / técnicos / stakeholders
- Canales: correo, mensajería, banner en la aplicación, página de estado
- Mensaje previo (al menos 48h antes):
  - Asunto: [Aviso] Mantenimiento programado INATrace – {fecha} {hora inicio}-{hora fin}
  - Cuerpo (resumen de objetivo, impacto, cronograma y contacto soporte)
- Mensaje de inicio (inicio de ventana)
- Mensaje de fin (mantenimiento completado y estado del servicio)
- Contacto de soporte durante ventana: {nombre, teléfono, email}

## 10. Criterios de Aceptación de la Ventana
- Todos los checks de salud en verde
- Pruebas de humo funcionales aprobadas (login, operación mínima por módulo)
- Sin incidentes críticos abiertos
- Documentación actualizada (cambios y evidencias)

## 11. Evidencias
- Logs relevantes
- Capturas de pantalla de validaciones
- Referencias a issues/tickets

## 12. Aprobaciones
- Responsable de ejecución: Firma/Fecha
- Aprobador de negocio/operaciones: Firma/Fecha
- Aprobador técnico: Firma/Fecha

---

## Anexo A. Checklist Rápido
- [ ] Backups verificados
- [ ] Accesos y llaves probados
- [ ] Ventana comunicada (T-48h y T-1h)
- [ ] Freeze de despliegues no relacionados
- [ ] Procedimiento de rollback listo
- [ ] Pruebas de humo definidas
- [ ] Monitoreo y logs listos

## Anexo B. Matriz RACI (opcional)
- R (Responsible): ejecución técnica
- A (Accountable): aprobación final
- C (Consulted): QA/Soporte/Negocio
- I (Informed): Usuarios y stakeholders
