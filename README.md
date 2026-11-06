# Registro Vehicular

Aplicación móvil hecha con **Flutter** para registrar vehículos y consultarlos.
Los datos se guardan en **Cloud Firestore (Firebase)**.

- **URL web:** https://registrovehiculos-e6040.web.app
- **APK:** _pendiente_ (en la sección Releases del repositorio)

## Funciones

| Pantalla | Qué hace |
|---|---|
| Inicio | Muestra el estado de la conexión con Firebase y cuántos vehículos hay. Da acceso al formulario y al listado. |
| Registrar vehículo | Formulario con placa, marca, modelo, año, color, tipo y propietario. Todos los campos se validan antes de guardar. |
| Vehículos registrados | Lista que se actualiza en tiempo real. Permite buscar por placa, marca o propietario y eliminar registros con confirmación. |

## Estructura

```
lib/
├── main.dart                     # Inicializa Firebase y arranca la app
├── firebase_options.example.dart # Plantilla de configuración (sin claves)
├── models/vehiculo.dart          # Modelo y conversión a/desde Firestore
├── services/vehiculo_service.dart# Lectura, registro y borrado en Firestore
├── utils/validadores.dart        # Reglas de validación del formulario
└── screens/
    ├── home_screen.dart          # Pantalla principal
    ├── registro_screen.dart      # Formulario de registro
    └── lista_screen.dart         # Visualización de registros
firestore.rules                   # Reglas de seguridad de la base de datos
firebase.json                     # Configuración de Firestore y Hosting
```

## Validaciones y seguridad

**En la app**
- Todos los campos son obligatorios. No se puede guardar un registro vacío ni con espacios en blanco.
- La placa se convierte a mayúsculas y solo acepta letras, números y guiones (de 5 a 10 caracteres).
- El año solo acepta números, entre 1950 y el año siguiente al actual.
- El color y el propietario solo aceptan letras.
- No se permiten dos vehículos con la misma placa. La placa es el ID del documento.

**En el servidor ([firestore.rules](firestore.rules))**
- Solo se puede acceder a la colección `vehiculos`. Todo lo demás está bloqueado.
- Un registro se rechaza si le faltan campos, trae campos extra o tiene tipos y longitudes incorrectos.
- No se permite sobrescribir un registro existente.
- La fecha de registro la asigna el servidor.

**Credenciales**
- `lib/firebase_options.dart` y `google-services.json` contienen las claves del proyecto de Firebase. Están en [.gitignore](.gitignore) y no se suben a GitHub.
- El repositorio solo incluye una plantilla sin claves: [firebase_options.example.dart](lib/firebase_options.example.dart).
- Los archivos de firma del APK (`*.jks`, `key.properties`) también están excluidos.

## Requisitos

- Flutter 3.x (probado con 3.47.9)
- Android Studio con Android SDK, para generar el APK
- Una cuenta de Firebase
- Node.js 18 o superior, para el Firebase CLI

## Configuración desde cero

```bash
git clone https://github.com/tonyi1/RegistroVehiculos.git
cd registro_vehiculos
flutter pub get
```

Instalar las herramientas de Firebase:

```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
```

Conectar la app con tu proyecto de Firebase. Esto genera `lib/firebase_options.dart`:

```bash
flutterfire configure
```

Publicar las reglas de seguridad:

```bash
firebase deploy --only firestore:rules
```

## Ejecutar en desarrollo

```bash
flutter run            # celular o emulador conectado
flutter run -d chrome  # navegador
```

## Compilación y distribución

### 1. APK para Android

```bash
flutter build apk --release
```

El archivo queda en `build/app/outputs/flutter-apk/app-release.apk`.

Para instalarlo:
1. Copia el APK al celular, o descárgalo desde Releases en GitHub.
2. Ábrelo y permite la instalación de fuentes desconocidas.
3. Instálalo.

La app funciona sin Android Studio ni cable USB.

### 2. Versión web (URL pública)

```bash
flutter build web --release
firebase deploy --only hosting
```

Firebase muestra la URL pública al terminar, por ejemplo `https://<proyecto>.web.app`.

### 3. Publicar el APK en GitHub

En el repositorio, ve a **Releases → Draft a new release**. Crea la etiqueta `v1.0.0` y adjunta `app-release.apk`.

## Pruebas

```bash
flutter test
```

Las pruebas verifican las validaciones de campos vacíos, placa, año y nombre.

## Autor

_(Tu nombre completo)_, GitHub `tonyi1`. Desarrollo Móvil Integral, remedial del segundo parcial.
