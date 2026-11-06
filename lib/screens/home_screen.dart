import 'package:flutter/material.dart';

import '../models/vehiculo.dart';
import '../services/vehiculo_service.dart';
import 'lista_screen.dart';
import 'registro_screen.dart';

/// Pantalla principal: resumen y acceso al formulario y al listado.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro Vehicular'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Icon(Icons.directions_car_filled, size: 96, color: cs.primary),
            const SizedBox(height: 8),
            Text(
              'Bienvenido',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Registra vehículos y consúltalos desde la nube.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const _TarjetaEstado(),
            const SizedBox(height: 16),
            _BotonMenu(
              icono: Icons.add_circle_outline,
              titulo: 'Registrar vehículo',
              subtitulo: 'Captura los datos de un vehículo nuevo',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegistroScreen())),
            ),
            const SizedBox(height: 12),
            _BotonMenu(
              icono: Icons.list_alt,
              titulo: 'Ver vehículos registrados',
              subtitulo: 'Consulta, busca y elimina registros',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ListaScreen())),
            ),
          ],
        ),
      ),
    );
  }
}

/// Muestra el estado de la conexión con Firestore y el total de registros.
class _TarjetaEstado extends StatelessWidget {
  const _TarjetaEstado();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return StreamBuilder<List<Vehiculo>>(
      stream: VehiculoService().obtenerVehiculos(),
      builder: (context, snap) {
        final IconData icono;
        final String texto;
        final Color color;
        if (snap.hasError) {
          icono = Icons.cloud_off;
          texto = 'Sin conexión con la base de datos';
          color = cs.error;
        } else if (!snap.hasData) {
          icono = Icons.cloud_sync;
          texto = 'Conectando con Firebase...';
          color = cs.outline;
        } else {
          icono = Icons.cloud_done;
          texto = 'Conectado a Firebase · ${snap.data!.length} vehículo(s)';
          color = Colors.green.shade700;
        }
        return Card(
          child: ListTile(
            leading: Icon(icono, color: color),
            title: Text(texto),
          ),
        );
      },
    );
  }
}

class _BotonMenu extends StatelessWidget {
  const _BotonMenu({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.primaryContainer,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icono, size: 36, color: cs.onPrimaryContainer),
        title: Text(titulo,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
