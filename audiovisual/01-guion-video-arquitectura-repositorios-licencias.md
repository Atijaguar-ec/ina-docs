# Guion Técnico Audiovisual · Cápsula 01
## Arquitectura del Ecosistema INATrace, Repositorios GitHub y Filosofía *Open Source*
### Duración Estimada: 08:30 minutos · Formato: Full HD 1080p60 · Idioma: Español (Neutro)

---

## 🎯 Ficha Pedagógica de la Cápsula

- **Objetivo de Aprendizaje:** Comprender la visión de bien público digital de INATrace, su marco de licenciamiento **MPL-2.0** bajo el origen **AgStack** (Linux Foundation), la organización real de repositorios en GitHub (`Atijaguar-ec/backend` y `Atijaguar-ec/fe`), el aislamiento por cliente institucional (ADR-007) y el desacoplamiento por cadena productiva (ADR-016).
- **Público Objetivo:** Directores de TI, desarrolladores de software, líderes de cooperativas agrícolas y coordinadores de proyectos de cooperación técnica.
- **Recursos Técnicos Requeridos:** Navegador web en GitHub, cliente Git en terminal, diagramas animados SVG.

---

## ⏱️ Storyboard y Guion Minuto a Minuto

| Código de Tiempo (TC) | Plano Visual en Pantalla | Pistas de Audio y Efectos | Locución en Off (Voz Profesional) | Elementos Gráficos Superpuestos |
|---|---|---|---|---|
| **00:00 – 00:25** (25s) | **Cabecera Institucional:** Animación de logos GIZ, BMZ, Iniciativa SASI y logotipo oficial de INATrace con mapa de América Latina interconectado. | Música institucional suave y moderna (*in crescendo*). SFX sutil de conexión de red. | "Bienvenidos a la serie técnica sobre la implementación de INATrace, la plataforma de código abierto para la trazabilidad y debida diligencia de cadenas agroalimentarias desde el productor hasta el mercado global." | Título: *INATrace: Trazabilidad Abierta y Soberana*<br>Subtítulo: *Módulo 1: Arquitectura y Repositorios* |
| **00:25 – 01:45** (80s) | **Toma Conceptual:** *B-roll* de fincas de cacao agroforestal y centros de acopio en Ecuador, seguido por la página oficial de Linux Foundation / AgStack. | Música de fondo baja a $-24\text{ dB}$ (*sidechain*). | "Ante normativas internacionales exigentes como el Reglamento Europeo contra la Deforestación (EUDR), las organizaciones de pequeños productores necesitan controlar sus propios datos sin quedar atadas a licencias privativas costosas. INATrace se respalda como bien público digital desde AgStack en la Fundación Linux y la Cooperación Alemana GIZ, bajo licencia abierta MPL-2.0." | Badge flotante: *Licencia MPL-2.0 (Mozilla Public License)*<br>Icono: *AgStack / Linux Foundation*<br>Texto: *Cero Costo de Licenciamiento* |
| **01:45 – 03:10** (85s) | **Pantalla Dividida (Diagrama C4 Nivel 2):** Se anima un diagrama de contenedores mostrando Nginx, Frontend Angular 19, Backend Spring Boot 3.3, Keycloak 26 y PostgreSQL 16. | Efecto sonoro de zoom digital suave al iluminarse cada bloque del diagrama. | "La arquitectura de INATrace opera sobre cuatro contenedores aislados detrás de un proxy Nginx: PostgreSQL 16 como motor relacional, Keycloak 26 para autenticación OIDC con PKCE, un núcleo en Spring Boot 3.3 con Java 17 y un frontend web en Angular 19 organizado en monorepo Nx 22. Además, cada organización cliente cuenta con su propia instancia dedicada bajo el principio de aislamiento institucional ADR-007." | Resaltar bloques:<br>1. *Keycloak 26 (IAM / OIDC)*<br>2. *Spring Boot 3.3 (Java 17)*<br>3. *Angular 19 / Nx 22 (Web UI)*<br>4. *PostgreSQL 16.10 (Debian glibc)* |
| **03:10 – 04:50** (100s) | **Navegación Web (GitHub):** Recorrido por la organización en GitHub (`github.com/Atijaguar-ec`), mostrando `backend`, `fe` y su *upstream* en `agstack`. | Clics audibles discretos. | "El código fuente adaptado y probado en Ecuador reside en dos repositorios públicos principales dentro de GitHub: `Atijaguar-ec/backend` y `Atijaguar-ec/fe`, bifurcados del proyecto original en AgStack. Para cadenas especializadas como la acuicultura de camarón, la arquitectura ADR-016 desacopla por completo los microservicios y microfrontends dedicados (`ms-shrimp`), manteniendo el núcleo de cacao y café liviano y limpio." | Lower Third con enlaces reales:<br>📂 `github.com/Atijaguar-ec/backend`<br>📂 `github.com/Atijaguar-ec/fe`<br>🔗 *Upstream: `agstack/inatrace-*`* |
| **04:50 – 06:15** (85s) | **Terminal *Screencast*:** Comandos Git clonando el *fork* propio, inspeccionando ramas (`main`, `staging`) y verificando el archivo `LICENSE` (MPL-2.0). | Sonido suave de tecleo en terminal. | "La licencia Mozilla Public License 2.0 permite a cualquier cooperativa, ministerio o proveedor local hacer un *fork* del código, adaptarlo y operarlo en sus servidores sin pagar regalías por usuario, con la condición justa de mantener abiertas bajo la misma licencia las modificaciones realizadas sobre los archivos fuente originales." | Terminal en pantalla (fuente 20 px):<br>`git clone https://github.com/SU-ORG/backend.git`<br>`head -n 15 backend/LICENSE` *(MPL-2.0)* |
| **06:15 – 07:45** (90s) | **Demostración Gráfica:** Mapa de replicabilidad regional mostrando la ruta de transferencia desde Manabí y Guayas hacia Centroamérica y el Caribe (Iniciativa SASI). | Música adopta un tono inspiracional y dinámico. | "Lo desarrollado y sistematizado en cadenas de cacao y acuicultura en Ecuador sirve hoy como referencia estándar para organizaciones cafetaleras y agroexportadoras en Honduras, República Dominicana y el resto de América Latina bajo la Iniciativa SASI, apoyándose en el mismo esquema relacional y catálogos territoriales adaptables." | Animación geográfica:<br>🇪🇨 Ecuador ➔ 🇭🇳 Honduras ➔ 🇩🇴 Rep. Dominicana<br>Texto: *Sinergia SVNA – Iniciativa SASI* |
| **07:45 – 08:30** (45s) | **Cierre y Llamado a la Acción:** Pantalla final con resumen visual, enlaces a la documentación técnica y vista previa del siguiente video. | Música sube gradualmente para el cierre. | "En la próxima cápsula revisaremos los requerimientos reales de infraestructura en arquitectura `x86_64`, diferenciaremos la memoria para compilación frente a ejecución, y calcularemos el costo total de propiedad en nube versus servidores locales. ¡Nos vemos en la Cápsula Dos!" | Tarjeta de salida:<br>*Siguiente: Infraestructura y Costos Reales*<br>Manual: `docs/manuales/README.md`<br>Logos finales GIZ y SASI |

---

## 📝 Notas de Producción y Pautas para el Locutor

1. **Tono de Voz:** Seguro, pedagógico, sobrio y profesional.
2. **Ritmo de Locución:** 130 a 140 palabras por minuto, haciendo pausas breves cuando aparezcan las rutas de repositorios en pantalla.
3. **Precisión Legal:** Pronunciar claramente *"Licencia Eme-Pe-Ele dos punto cero"* (MPL-2.0) y verificar en pantalla que coincida exactamente con el archivo `LICENSE` de los repositorios.
