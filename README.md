# 📦 QuickStore

**QuickStore** es una aplicación móvil de e-commerce desarrollada en Flutter, enfocada en permitir a los usuarios visualizar, filtrar y agregar productos al carrito, gestionar favoritos y administrar su perfil. Está diseñada para ser una solución accesible para pequeñas y medianas empresas (PyMEs) que buscan digitalizar su catálogo y mejorar su presencia en el entorno digital.

## 🚀 Tecnologías Utilizadas

- **Framework:** Flutter 3.10+ (Dart)
- **Backend:** Firebase (Authentication, Firestore, Storage)
- **Gestión de Estado:** GetX
- **Base de Datos Local:** shared_preferences, SQLite
- **Dependencias adicionales:**
  - cached_network_image
  - carousel_slider
  - flutter_rating_bar
  - dio

## 🧹 Arquitectura del Proyecto

Seguimos el patrón **MVVM** utilizando **GetX**:

```
/models       -> Definición de las clases de datos
/views        -> Pantallas y widgets de la interfaz de usuario
/controllers  -> Lógica de presentación (GetX Controllers)
/services     -> Servicios de Firebase y APIs
/utils        -> Funciones de ayuda y constantes
/widgets      -> Componentes reutilizables
```

El flujo es unidireccional: **UI → Controllers (GetX Observables).**

## 🌟 Objetivos Principales

- Crear una interfaz intuitiva basada en **Material Design 3**.
- Integrar **Firestore** como sistema de gestión de productos y usuarios.
- Implementar carrito de compras con persistencia local.
- Diseñar sección de favoritos y perfil personalizable.
- Ofrecer funcionalidades de búsqueda avanzada y filtrado.

## 📱 Principales Funcionalidades

- **Autenticación:** Registro, login, recuperación de contraseña.
- **Catálogo:** Visualización en grid y lista, carga lazy, categorías destacadas.
- **Detalles de Producto:** Galería de imágenes con zoom, variantes y valoraciones.
- **Carrito:** Gestión de productos, resumen de compra, simulación de checkout.
- **Perfil de Usuario:** Edición de información, favoritos, historial y configuración.
- **Modo Oscuro/Claro** adaptable al sistema.

---

# 👥 Participantes

- [@JosePabloSG](https://github.com/JosePabloSG)
- [@Yoilin](https://github.com/YoilinCastrillo)
- [@Sofia](https://github.com/SofiaSJ09)
- [@Aaron](https://github.com/ItsChavesCR)
- [@Genesis](https://github.com/AlexaGenar)

---

# 🌱 ¿Cómo colaborar y subir cambios? (GitFlow para `develop`)

**Pasos para trabajar de forma ordenada:**

### 1. Clona el repositorio

```bash
git clone https://github.com/JosePabloSG/quickstore_app.git
cd quickstore_app
```

# 🏁 Cómo arrancar el proyecto (macOS y Windows)

Después de clonar el repositorio, sigue estos pasos para ejecutar la app en tu entorno local:

## 1. Instala Flutter

Asegúrate de tener [Flutter](https://docs.flutter.dev/get-started/install) instalado y configurado en tu sistema (incluye Dart SDK). Puedes verificarlo con:

```bash
flutter --version
```

## 2. Instala dependencias

Desde la raíz del proyecto:

```bash
flutter pub get
```

## 3. Ejecuta la app

### En macOS

- Conecta un simulador o dispositivo físico (iOS o Android).
- Ejecuta:

```bash
flutter run
```

### En Windows

- Conecta un emulador o dispositivo físico (Android).
- Ejecuta:

```bash
flutter run
```

> **Nota:** Para iOS necesitas una Mac con Xcode instalado. Para Android, asegúrate de tener Android Studio y los emuladores configurados.

## 4. Solución de problemas

- Si tienes problemas con dependencias nativas, ejecuta:
  ```bash
  flutter clean
  flutter pub get
  ```
- Si usas Firebase, asegúrate de tener los archivos `google-services.json` (Android) y/o `GoogleService-Info.plist` (iOS) en las carpetas correspondientes.

---


### 2. Crea una rama de desarrollo desde `develop`

```bash
git checkout develop
git pull origin develop
git checkout -b feature/nombre-del-feature
```

**Ejemplo de nombres de ramas:**

- `feature/login-authentication`
- `feature/product-listing`
- `bugfix/fix-cart-bug`

### 3. Sube tus cambios a `develop`

```bash
git add .
git commit -m "feat: agregada funcionalidad de favoritos"
git push origin feature/nombre-del-feature
```

### 4. Crea un Pull Request (PR) hacia `develop`

- El PR debe ser revisado y aprobado antes de hacer _merge_.

