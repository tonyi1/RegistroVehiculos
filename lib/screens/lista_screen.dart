import 'package:flutter/material.dart';

import '../models/vehiculo.dart';
import '../services/vehiculo_service.dart';
import 'registro_screen.dart';

/// Listado en tiempo real de los vehículos guardados en Firestore.
class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  State<ListaScreen> createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final _servicio = VehiculoService();
  late final Stream<List<Vehiculo>> _stream = _servicio.obtenerVehiculos();
  String _busqueda = '';

  Future<void> _confirmarEliminar(Vehiculo v) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar vehículo'),
        content: Text('¿Seguro que deseas eliminar ${v.placa}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await _servicio.eliminar(v.placa);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${v.placa} eliminado')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No se pudo eliminar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehículos registrados'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const RegistroScreen())),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar por placa, marca o propietario',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (t) =>
                    setState(() => _busqueda = t.trim().toLowerCase()),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Vehiculo>>(
                stream: _stream,
                builder: (context, snap) {
                  if (snap.hasError) {
                    return _Mensaje(
                        icono: Icons.error_outline,
                        texto: 'Error al cargar los datos:\n${snap.error}');
                  }
                  if (!snap.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final lista = snap.data!.where((v) {
                    if (_busqueda.isEmpty) return true;
                    return v.placa.toLowerCase().contains(_busqueda) ||
                        v.marca.toLowerCase().contains(_busqueda) ||
                        v.propietario.toLowerCase().contains(_busqueda);
                  }).toList();

                  if (lista.isEmpty) {
                    return _Mensaje(
                      icono: Icons.no_crash_outlined,
                      texto: _busqueda.isEmpty
                          ? 'Aún no hay vehículos registrados'
                          : 'Sin resultados para "$_busqueda"',
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
                    itemCount: lista.length,
                    itemBuilder: (_, i) => _TarjetaVehiculo(
                      vehiculo: lista[i],
                      onEliminar: () => _confirmarEliminar(lista[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaVehiculo extends StatelessWidget {
  const _TarjetaVehiculo({required this.vehiculo, required this.onEliminar});

  final Vehiculo vehiculo;
  final VoidCallback onEliminar;

  IconData get _icono => switch (vehiculo.tipo) {
        'Motocicleta' => Icons.two_wheeler,
        'Camión' => Icons.local_shipping,
        'Camioneta' => Icons.airport_shuttle,
        _ => Icons.directions_car,
      };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final v = vehiculo;
    final f = v.fechaRegistro;
    final fecha = f == null
        ? 'Guardando...'
        : '${f.day.toString().padLeft(2, '0')}/'
            '${f.month.toString().padLeft(2, '0')}/${f.year} '
            '${f.hour.toString().padLeft(2, '0')}:'
            '${f.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: cs.primaryContainer,
              child: Icon(_icono, color: cs.onPrimaryContainer),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v.placa,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('${v.marca} ${v.modelo} · ${v.anio}'),
                  Text('${v.tipo} · ${v.color}'),
                  Text('Propietario: ${v.propietario}'),
                  Text('Registrado: $fecha',
                      style: TextStyle(color: cs.outline, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Eliminar',
              icon: Icon(Icons.delete_outline, color: cs.error),
              onPressed: onEliminar,
            ),
          ],
        ),
      ),
    );
  }
}

class _Mensaje extends StatelessWidget {
  const _Mensaje({required this.icono, required this.texto});

  final IconData icono;
  final String texto;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 12),
            Text(texto, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
