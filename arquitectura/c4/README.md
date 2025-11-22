# Diagramas C4 de Arquitectura INATrace

> **Audiencia**: Arquitectos, Desarrolladores Senior, Stakeholders Técnicos  
> **Modelo**: C4 (Context, Container, Component)  
> **Última actualización**: Noviembre 2025

Este directorio reúne los **diagramas C4** que describen la arquitectura de INATrace en distintos niveles de detalle.

---

## 📌 Niveles C4 Disponibles

- **Nivel 1 – Contexto del Sistema**  
  Archivo: [`01-contexto.md`](./01-contexto.md)  
  Muestra a **INATrace como sistema** y sus interacciones con:
  - Usuarios internos y externos (productores, administradores, consumidores).  
  - Sistemas externos (email, mapas, tasas de cambio, Beyco, blockchain, etc.).

- **Nivel 2 – Diagrama de Contenedores**  
  Archivo: [`02-contenedores.md`](./02-contenedores.md)  
  Describe los **contenedores lógicos** que componen la solución:
  - Frontend Angular.  
  - Backend Java / Spring Boot.  
  - Base de datos MySQL.  
  - Blockchain (Hyperledger Fabric, opcional).  
  - Nginx / proxies y otros componentes de infraestructura.

- **Nivel 3 – Componentes Backend**  
  Archivo: [`03-componentes-backend.md`](./03-componentes-backend.md)  
  Detalla los **componentes principales del backend** (módulos en `components/*`), por ejemplo:
  - `user`, `company`, `product`, `stockorder`, `payment`, etc.  
  - Servicios de integración externa (email, Beyco, exchange rates, blockchain).

- **Nivel 3 – Componentes Frontend**  
  Archivo: [`03-componentes-frontend.md`](./03-componentes-frontend.md)  
  Describe la estructura de módulos Angular y componentes clave de la SPA:
  - `core`, `shared`, `layout`, módulos de característica (`auth`, `company`, `product`, `dashboard`, etc.).

---

## 🖼️ Recursos Visuales

Las imágenes SVG/PNG asociadas a los diagramas se encuentran en la carpeta [`img/`](./img/).  
Se utilizan desde los archivos Markdown anteriores para facilitar la visualización en GitHub o en visores de documentación.

---

## 🔎 Recomendación de Lectura

1. Empezar por **Nivel 1 – Contexto** (`01-contexto.md`) para entender el alcance.  
2. Seguir con **Nivel 2 – Contenedores** (`02-contenedores.md`) para ver cómo se despliega la solución.  
3. Profundizar en **Componentes Backend** y **Componentes Frontend** según el rol (backend/frontend/arquitectura).
