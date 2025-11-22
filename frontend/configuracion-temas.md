# Configuración de Temas (Frontend INATrace)

> **Audiencia**: Desarrolladores Frontend, DevOps, Implementadores de Proyecto  
> **Componente**: Frontend Angular (fe)  
> **Última actualización**: Noviembre 2025

---

## 1. Objetivo

INATrace permite **personalizar la apariencia** de la UI por cadena de valor o por despliegue (cacao, camarón, etc.) mediante variables de configuración.  
Este documento resume **dónde** se configuran los temas y **qué parámetros** se usan.

---

## 2. Configuración vía `assets/env.js` (runtime)

En despliegues con Docker/Nginx, la forma recomendada de configurar temas es usando el archivo `fe/src/assets/env.js` (o el generado en tiempo de despliegue).

Ejemplo de configuración para una cadena de **Cacao**:

```javascript
// src/assets/env.js
(function(window) {
  window["env"] = window["env"] || {};
  window["env"]["apiUrl"] = "https://inatrace.atijaguar.com/api";
  window["env"]["companyTheme"] = "COCOA"; // Activa estilos y lógica de Cacao
  window["env"]["primaryColor"] = "#5D4037"; // Marrón Cacao
})(this);
```

Ejemplo de configuración para **Camarón**:

```javascript
// src/assets/env.js
(function(window) {
  window["env"] = window["env"] || {};
  window["env"]["apiUrl"] = "https://camaron.atijaguar.com/api";
  window["env"]["companyTheme"] = "SHRIMP"; // Activa estilos y lógica de Camarón
  window["env"]["primaryColor"] = "#0277BD"; // Azul Camarón
})(this);
```

### Parámetros típicos de tema

- `companyTheme`: Identificador lógico de la cadena (`COCOA`, `SHRIMP`, `COFFEE`, etc.).  
- `primaryColor`: Color principal de la interfaz para esa cadena.  
- (Opcional) Otros campos específicos pueden ser leídos por componentes de UI si se extiende el código (`secondaryColor`, logos, etc.).

> **Nota**: En producción, este archivo suele generarse desde los scripts de despliegue (CI/CD) para evitar rebuilds de Angular.

---

## 3. Configuración vía `environment.*` (build-time)

Para entornos de desarrollo local, también se puede controlar el tema mediante los archivos de entorno Angular en `fe/src/environments/`.

Ejemplo en `environment.dev.ts`:

```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:8080/api',
  companyTheme: 'COCOA',
};
```

En este caso:

- `companyTheme` se usa en el frontend para decidir textos, traducciones por cadena y estilos específicos.
- La combinación de `apiUrl` + `companyTheme` define contra qué backend se habla y qué tema se aplica.

---

## 4. Uso típico por cadena

- **Cacao**  
  - `companyTheme`: `COCOA`  
  - Paleta: marrones/verde oscuro  

- **Camarón**  
  - `companyTheme`: `SHRIMP`  
  - Paleta: azules  

- **Café (original)**  
  - `companyTheme`: `COFFEE` (o el valor heredado del proyecto original)  

La lógica exacta de cómo se aplican estos temas (clases CSS, traducciones por cadena, imágenes) está implementada en el código Angular (módulos de layout, servicios de configuración y i18n).

---

## 5. Buenas prácticas

- Mantener un **único archivo `env.js` por despliegue** y no commitear variantes específicas de cliente.  
- Documentar en `README-es.md` de `fe` qué `companyTheme` corresponde a cada dominio/subdominio.  
- Cuando se agregue una nueva cadena de valor:
  - Definir un nuevo `companyTheme`.
  - Asociar paleta de colores y assets.
  - (Opcional) Crear archivos de traducción específicos (`assets/i18n/<cadena>/es.json`).
