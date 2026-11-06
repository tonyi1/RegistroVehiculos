import 'package:flutter/services.dart';

/// Validaciones del formulario. Cada función devuelve `null` si el valor es
/// válido o un mensaje de error si no lo es.
class Validadores {
  static final _placa = RegExp(r'^[A-Z0-9]{2,4}(-?[A-Z0-9]{1,4}){1,2}$');
  static final _soloLetras = RegExp(r"^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ .'-]+$");

  static String? requerido(String? v, String campo) {
    if (v == null || v.trim().isEmpty) return '$campo es obligatorio';
    return null;
  }

  static String? placa(String? v) {
    final r = requerido(v, 'La placa');
    if (r != null) return r;
    final p = v!.trim().toUpperCase();
    if (p.length < 5 || p.length > 10 || !_placa.hasMatch(p)) {
      return 'Placa no válida (ej. ABC-123-D)';
    }
    return null;
  }

  static String? texto(String? v, String campo, {int min = 2, int max = 40}) {
    final r = requerido(v, campo);
    if (r != null) return r;
    final t = v!.trim();
    if (t.length < min) return '$campo debe tener al menos $min caracteres';
    if (t.length > max) return '$campo no puede pasar de $max caracteres';
    return null;
  }

  static String? nombre(String? v, String campo) {
    final r = texto(v, campo, min: 3, max: 60);
    if (r != null) return r;
    if (!_soloLetras.hasMatch(v!.trim())) return '$campo solo admite letras';
    return null;
  }

  static String? anio(String? v) {
    final r = requerido(v, 'El año');
    if (r != null) return r;
    final n = int.tryParse(v!.trim());
    final max = DateTime.now().year + 1;
    if (n == null || n < 1950 || n > max) {
      return 'Ingresa un año entre 1950 y $max';
    }
    return null;
  }
}

/// Convierte a mayúsculas lo que se escribe (para la placa).
class MayusculasFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      newValue.copyWith(text: newValue.text.toUpperCase());
}
