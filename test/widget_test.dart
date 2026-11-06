import 'package:flutter_test/flutter_test.dart';
import 'package:registro_vehiculos/utils/validadores.dart';

void main() {
  group('Validadores', () {
    test('campos vacíos no son válidos', () {
      expect(Validadores.placa(''), isNotNull);
      expect(Validadores.placa('   '), isNotNull);
      expect(Validadores.texto(null, 'La marca'), isNotNull);
      expect(Validadores.anio(''), isNotNull);
      expect(Validadores.nombre('', 'El propietario'), isNotNull);
    });

    test('placa', () {
      expect(Validadores.placa('ABC-123-D'), isNull);
      expect(Validadores.placa('abc1234'), isNull);
      expect(Validadores.placa('AB'), isNotNull);
      expect(Validadores.placa('--------'), isNotNull);
    });

    test('año', () {
      expect(Validadores.anio('2020'), isNull);
      expect(Validadores.anio('1800'), isNotNull);
      expect(Validadores.anio('abcd'), isNotNull);
      expect(Validadores.anio('${DateTime.now().year + 5}'), isNotNull);
    });

    test('nombre solo letras', () {
      expect(Validadores.nombre('José Pérez', 'El propietario'), isNull);
      expect(Validadores.nombre('Juan123', 'El propietario'), isNotNull);
    });
  });
}
