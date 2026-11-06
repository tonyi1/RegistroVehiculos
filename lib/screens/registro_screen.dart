import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/vehiculo.dart';
import '../services/vehiculo_service.dart';
import '../utils/validadores.dart';

const tiposVehiculo = [
  'Automóvil',
  'Camioneta',
  'Motocicleta',
  'Camión',
  'Otro',
];

/// Formulario para registrar un vehículo en Firestore.
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _servicio = VehiculoService();

  final _placa = TextEditingController();
  final _marca = TextEditingController();
  final _modelo = TextEditingController();
  final _anio = TextEditingController();
  final _color = TextEditingController();
  final _propietario = TextEditingController();
  String? _tipo;
  bool _guardando = false;

  @override
  void dispose() {
    for (final c in [_placa, _marca, _modelo, _anio, _color, _propietario]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _guardar() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _guardando = true);
    final vehiculo = Vehiculo(
      placa: _placa.text.trim().toUpperCase(),
      marca: _marca.text.trim(),
      modelo: _modelo.text.trim(),
      anio: int.parse(_anio.text.trim()),
      color: _color.text.trim(),
      tipo: _tipo!,
      propietario: _propietario.text.trim(),
    );

    try {
      await _servicio.registrar(vehiculo);
      if (!mounted) return;
      _mensaje('Vehículo ${vehiculo.placa} registrado correctamente',
          error: false);
      _formKey.currentState!.reset();
      for (final c in [_placa, _marca, _modelo, _anio, _color, _propietario]) {
        c.clear();
      }
      setState(() => _tipo = null);
    } on PlacaDuplicadaException catch (e) {
      _mensaje(e.toString());
    } catch (e) {
      _mensaje('No se pudo guardar: $e');
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  void _mensaje(String texto, {bool error = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(texto),
      backgroundColor: error ? Colors.red.shade700 : Colors.green.shade700,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar vehículo'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Todos los campos son obligatorios.',
                  style: TextStyle(color: cs.outline)),
              const SizedBox(height: 12),
              _campo(
                controller: _placa,
                etiqueta: 'Placa',
                icono: Icons.pin,
                validator: Validadores.placa,
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9-]')),
                  LengthLimitingTextInputFormatter(10),
                  MayusculasFormatter(),
                ],
              ),
              _campo(
                controller: _marca,
                etiqueta: 'Marca',
                icono: Icons.business,
                validator: (v) => Validadores.texto(v, 'La marca'),
              ),
              _campo(
                controller: _modelo,
                etiqueta: 'Modelo',
                icono: Icons.directions_car,
                validator: (v) => Validadores.texto(v, 'El modelo', min: 1),
              ),
              _campo(
                controller: _anio,
                etiqueta: 'Año',
                icono: Icons.calendar_today,
                teclado: TextInputType.number,
                validator: Validadores.anio,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              _campo(
                controller: _color,
                etiqueta: 'Color',
                icono: Icons.palette,
                validator: (v) => Validadores.nombre(v, 'El color'),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: DropdownButtonFormField<String>(
                  initialValue: _tipo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de vehículo',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: [
                    for (final t in tiposVehiculo)
                      DropdownMenuItem(value: t, child: Text(t)),
                  ],
                  onChanged: (v) => setState(() => _tipo = v),
                  validator: (v) => v == null ? 'Selecciona el tipo' : null,
                ),
              ),
              _campo(
                controller: _propietario,
                etiqueta: 'Nombre del propietario',
                icono: Icons.person,
                validator: (v) => Validadores.nombre(v, 'El propietario'),
                capitalizacion: TextCapitalization.words,
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _guardando ? null : _guardar,
                style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                icon: _guardando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save),
                label: Text(_guardando ? 'Guardando...' : 'Guardar vehículo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String etiqueta,
    required IconData icono,
    required FormFieldValidator<String> validator,
    TextInputType? teclado,
    List<TextInputFormatter>? formatters,
    TextCapitalization capitalizacion = TextCapitalization.sentences,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration:
            InputDecoration(labelText: etiqueta, prefixIcon: Icon(icono)),
        keyboardType: teclado,
        inputFormatters: formatters,
        textCapitalization: capitalizacion,
        textInputAction: TextInputAction.next,
        validator: validator,
      ),
    );
  }
}
