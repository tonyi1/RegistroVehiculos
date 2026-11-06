// PLANTILLA. El archivo real `lib/firebase_options.dart` NO se sube a GitHub
// (está en .gitignore) porque contiene las claves del proyecto de Firebase.
//
// Para generarlo en tu máquina:
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// Ese comando crea lib/firebase_options.dart con esta misma estructura.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    if (defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError('Plataforma no configurada');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'TU_API_KEY_WEB',
    appId: 'TU_APP_ID_WEB',
    messagingSenderId: 'TU_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    authDomain: 'TU_PROJECT_ID.firebaseapp.com',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TU_API_KEY_ANDROID',
    appId: 'TU_APP_ID_ANDROID',
    messagingSenderId: 'TU_SENDER_ID',
    projectId: 'TU_PROJECT_ID',
    storageBucket: 'TU_PROJECT_ID.firebasestorage.app',
  );
}
