# Plan de Producción Audiovisual y Guiones Técnicos INATrace
## Serie de Cápsulas Didácticas en Video: Implementación, Arquitectura y Operación
### Proyecto GIZ · Fortalecimiento y Escalamiento de INATrace (ELKE / Sinergia SVNA – Iniciativa SASI)

---

## 🎬 1. Visión General del Programa Audiovisual

El presente programa audiovisual complementa la suite de manuales técnicos (`docs/manuales/`), proporcionando un conjunto de **cápsulas explicativas en video de alta definición (Full HD 1080p / 4K)** diseñadas para capacitar a equipos técnicos de cooperativas, agencias de desarrollo, ingenieros de sistemas y tomadores de decisión en América Latina y a nivel global.

Los videos combinan:
- **Explicación conceptual y pedagógica** mediante diagramas animados y gráficos de arquitectura.
- **Demostración práctica en pantalla dividida (*screencast*):** terminal de Linux, compilación desde repositorio, comandos de Docker, configuración de Keycloak e interfaz gráfica de INATrace.
- **Narración profesional en español neutro**, con subtitulado completo en español e inglés para accesibilidad y transferencia internacional.

```text
┌──────────────────────────────────────────────────────────────────────────────┐
│                  SERIE AUDIOVISUAL: IMPLEMENTACIÓN INATRACE                  │
├──────────────┬──────────────────┬──────────────┬──────────────┬──────────────┤
│  Cápsula 01  │   Cápsula 02     │  Cápsula 03  │  Cápsula 04  │  Cápsula 05  │
│ Arquitectura │ Infraestructura  │  Despliegue  │ Parametrizac.│ Regulatorio  │
│  Open Source │ y Costos Reales  │ Docker & KC  │ Multi-Cadena │ EUDR/TRACES  │
│  (8-10 min)  │   (8-10 min)     │ (12-15 min)  │ (10-12 min)  │ (10-12 min)  │
└──────────────┴──────────────────┴──────────────┴──────────────┴──────────────┘
```

---

## 📋 2. Matriz Curricular del Curso en Video

| N° | Título de la Cápsula | Documento de Guion | Duración | Contenido y Competencias Transmitidas |
|---|---|---|---|---|
| **01** | **Arquitectura, Repositorios GitHub y Filosofía *Open Source*** | [`01-guion-video-arquitectura-repositorios-licencias.md`](./01-guion-video-arquitectura-repositorios-licencias.md) | 08:30 min | Filosofía de bien público digital, Licencia **MPL-2.0**, origen **AgStack** (Linux Foundation), estructura de repositorios (`Atijaguar-ec/backend`, `Atijaguar-ec/fe`), aislamiento institucional (ADR-007) y desacoplamiento por cadena (ADR-016). |
| **02** | **Infraestructura, *Sizing* y Estimación de Costos Reales** | [`02-guion-video-infraestructura-costos-sizing.md`](./02-guion-video-infraestructura-costos-sizing.md) | 09:15 min | Análisis del Costo Total de Propiedad (TCO), arquitectura obligatoria `x86_64`, memoria separada de compilación (*build* + *swap*) vs. ejecución, comparativa Cloud vs. *On-Premises* rural (enlace LAN síncrono) y ahorro de licencias. |
| **03** | **Despliegue Práctico en Vivo con Docker, PostgreSQL y Keycloak** | [`03-guion-video-despliegue-docker-keycloak.md`](./03-guion-video-despliegue-docker-keycloak.md) | 14:20 min | Paso a paso desde consola limpia: OS/Docker/UFW+VPC, compilación desde rama `main`, `initdb` + tema visual `inatrace`, `.env` y Compose (`50MB`, `INATRACE_KEYCLOAK_ADMIN_CLIENT_SECRET`), Nginx con TLS/hooks/redirección canónica `301` y *rate-limit*, más *bootstrap* con `inatrace-browser-flow`, `manage-users`, auto-sincronización `SYSTEM_ADMIN` y semilla `'QUINTALES'`. |
| **04** | **Parametrización Multi-Cadena, Báscula y Trazabilidad QR** | [`04-guion-video-configuracion-multicadena-qr.md`](./04-guion-video-configuracion-multicadena-qr.md) | 11:45 min | Demostración en UI: alta y activación de empresa, Cacao en Baba vs. Seco vs. Café (y alcance separado de Camarón), pesaje físico con control de cupos, ticket térmico POS de 72 mm (QR ~3.2 cm) y consulta pública sin login. |
| **05** | **Cumplimiento Regulatorio EUDR, TRACES-NT y Mantenimiento** | [`05-guion-video-traces-eudr-mantenimiento-buenas-practicas.md`](./05-guion-video-traces-eudr-mantenimiento-buenas-practicas.md) | 11:10 min | Demostración satelital de deforestación (fecha corte 2020), polígonos WGS84, generación del payload JSON-LD para la Unión Europea, respaldos automatizados con `cron` y mesa de ayuda. |

---

## ⚙️ 3. Estándares Técnicos de Grabación y Post-Producción

Para asegurar un acabado profesional uniforme en toda la serie:

### 3.1 Especificaciones de Video
- **Resolución:** Full HD ($1920 \times 1080$) o 4K UHD ($3840 \times 2160$).
- **Relación de Aspecto:** 16:9 panorámico.
- **Cuadros por Segundo (FPS):** 60 fps (garantiza máxima fluidez en animaciones de consola y navegación web).
- **Códec de Compresión:** H.264 / AVC (perfil High, *bitrate* constante 12–16 Mbps) o H.265 / HEVC.
- **Formato Contenedor:** MP4.

### 3.2 Especificaciones de Audio
- **Canales:** Estéreo (2.0).
- **Frecuencia de Muestreo:** 48 kHz / 24-bit.
- **Códec:** AAC estéreo a 320 kbps.
- **Normalización de Volumen:** Estándar EBU R128 (*Integrated Loudness*: $-14\text{ LUFS} \pm 1\text{ LUFS}$, *True Peak* máx.: $-1.0\text{ dBFS}$).
- **Voz en Off:** Micrófono de condensador profesional con filtro antipop y cabina insonorizada.
- **Música de Fondo:** Música instrumental acústica/electrónica suave, licenciada bajo Creative Commons CC-BY, atenuada a $-24\text{ dB}$ (*sidechain* / *audio ducking* automático al hablar el locutor).

### 3.3 Herramientas de Software Recomendadas (Flujo *Open Source*)
- **Captura de Pantalla y *Streaming*:** OBS Studio (*Open Broadcaster Software*) v30+.
- **Grabación y Limpieza de Audio:** Audacity (reducción de ruido, compresor y ecualización paramétrica).
- **Edición y Montaje de Video:** Kdenlive / Shotcut / DaVinci Resolve.
- **Diagramación y Títulos:** Inkscape / GIMP para texturas y diagramas vectoriales SVG.

---

## 🌈 4. Pertinencia Territorial, Género e Inclusión Visual

En concordancia con los lineamientos transversales de la Cooperación Técnica Alemana (GIZ):
1. **Representación Equitativa:** Los videos incorporan en sus tomas de apoyo a mujeres productoras líderes de comités de trazabilidad, socias de cooperativas de cacao y acuicultura, y jóvenes técnicos rurales.
2. **Iconografía Regional Culturalmente Apropiada:** Los gráficos ilustrativos representan el paisaje productivo montuvio y costero (ríos, fincas agroforestales, secaderos solares y muelles de acopio).
3. **Lenguaje Claro y Accesible:** Se evita la jerga técnica innecesaria cuando se describen procesos agropecuarios, empleando analogías cotidianas sobre el pesaje, la fermentación y el cuidado del bosque.
