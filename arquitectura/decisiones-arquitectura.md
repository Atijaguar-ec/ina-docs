# Decisiones de Arquitectura (ADRs)

> **Audiencia**: Arquitectos, Desarrolladores Senior, DevOps  
> **Basado en**: arc42 + C4  
> **Última actualización**: Noviembre 2025

Este documento resume las **decisiones de arquitectura clave** tomadas para INATrace. No reemplaza los detalles técnicos del código, pero sirve como referencia rápida de “por qué” se eligieron ciertas soluciones.

---

## ADR-001: Monolito Modular en lugar de Microservicios

- **Contexto**: INATrace se despliega en cooperativas y organizaciones con equipos de TI pequeños y recursos limitados.
- **Decisión**: Backend implementado como **monolito modular** (módulos por dominio en `components/*`) en vez de una arquitectura de microservicios.
- **Motivaciones**:
  - Menor complejidad operativa (un solo artefacto / contenedor).
  - Despliegues más sencillos en servidores VPS (ej. Hetzner).
  - Menos puntos de fallo de red internos.
- **Consecuencias**:
  - + Más simple de mantener para equipos pequeños.
  - + Performance adecuada para los volúmenes previstos.
  - − Menos flexibilidad para escalar componentes de forma independiente.

---

## ADR-002: SPA Angular 10 para el Frontend Web

- **Contexto**: Se requieren formularios complejos, flujos tipo wizard y una UI rica para operación diaria.
- **Decisión**: Usar **Angular 10** como framework SPA principal.
- **Motivaciones**:
  - Ecosistema maduro para formularios y validaciones.
  - Experiencia de usuario fluida en red inestable (carga inicial y luego API).
  - Código existente del proyecto original reutilizable.
- **Consecuencias**:
  - + Productividad alta para formularios y pantallas administrativas.
  - − Curva de aprendizaje mayor para nuevos desarrolladores.

---

## ADR-003: Multi-Tenant Lógico por `CompanyID`

- **Contexto**: Una misma instancia de INATrace debe servir a varias organizaciones (cooperativas) sin mezclar datos.
- **Decisión**: Implementar **multi-tenancy lógico** en la base de datos, filtrando por `CompanyID` y contexto de seguridad.
- **Motivaciones**:
  - Reutilizar una sola base de código y despliegue.
  - Reducir costos de infraestructura para proyectos pequeños.
- **Consecuencias**:
  - + Aislamiento suficiente para la mayoría de casos (nivel aplicación/BD).
  - − Para aislamientos extremos se recomienda instancias separadas.

---

## ADR-004: Blockchain Híbrido (Opcional)

- **Contexto**: Algunos proyectos requieren notarización fuerte (ej. EUDR, certificaciones), otros no.
- **Decisión**: Mantener **MySQL** como fuente de verdad operativa y usar **Hyperledger Fabric** solo como capa de notariado opcional.
- **Motivaciones**:
  - Evitar complejidad de operar blockchain donde no es necesaria.
  - Permitir proyectos “solo BD” y proyectos “BD + blockchain” con el mismo código base.
- **Consecuencias**:
  - + Flexibilidad por proyecto/cliente.
  - − Mayor complejidad de despliegue cuando se activa la capa blockchain.

---

## ADR-005: Soporte Multi-Cadena (Cacao, Camarón, Café)

- **Contexto**: INATrace se usa en diferentes cadenas de valor con procesos y terminología específicos.
- **Decisión**: Implementar un modelo **multi-cadena** configurable:
  - Frontend: `companyTheme`, traducciones por cadena, campos dinámicos.
  - Backend: entidades y campos parametrizables por tipo de producto.
- **Consecuencias**:
  - + Reutilización de la plataforma para varios productos.
  - − Lógica más compleja en formularios y validaciones.

---

## ADR-006: Integración con Servicios Externos vía APIs REST

- **Contexto**: Necesidad de correo, mapas, tasas de cambio y plataformas de trading.
- **Decisión**: Integrar con servicios externos mediante APIs REST desacopladas (Email SMTP, Mapbox, exchangerate.host, Beyco, etc.).
- **Consecuencias**:
  - + Flexibilidad para cambiar de proveedor.
  - − Dependencias externas que requieren manejo de fallos y timeouts.

---

## Próximos ADRs

Este documento es incremental. Nuevas decisiones relevantes (ej. migración a Angular moderno, refactor a servicios independientes, cambios de proveedor de mapas o tasas de cambio) deben documentarse aquí siguiendo el mismo formato (**Contexto → Decisión → Motivaciones → Consecuencias**).
