import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const RegistroVehiculosApp());
}

class RegistroVehiculosApp extends StatelessWidget {
  const RegistroVehiculosApp({super.key});

  @override
  Widget build(BuildContext context) {
    final esquema = ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0));
    return MaterialApp(
      title: 'Registro Vehicular',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: esquema,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          filled: true,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
