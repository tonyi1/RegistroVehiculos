import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa un vehículo registrado en la colección `vehiculos` de Firestore.
/// El ID del documento es la placa, así no puede haber dos vehículos con la
/// misma placa.
class Vehiculo {
  final String placa;
  final String marca;
  final String modelo;
  final int anio;
  final String color;
  final String tipo;
  final String propietario;
  final DateTime? fechaRegistro;

  const Vehiculo({
    required this.placa,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.color,
    required this.tipo,
    required this.propietario,
    this.fechaRegistro,
  });

  /// Datos que se guardan en Firestore. La fecha la pone el servidor.
  Map<String, dynamic> toMap() => {
        'placa': placa,
        'marca': marca,
        'modelo': modelo,
        'anio': anio,
        'color': color,
        'tipo': tipo,
        'propietario': propietario,
        'fechaRegistro': FieldValue.serverTimestamp(),
      };

  factory Vehiculo.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Vehiculo(
      placa: d['placa'] as String? ?? doc.id,
      marca: d['marca'] as String? ?? '',
      modelo: d['modelo'] as String? ?? '',
      anio: (d['anio'] as num?)?.toInt() ?? 0,
      color: d['color'] as String? ?? '',
      tipo: d['tipo'] as String? ?? '',
      propietario: d['propietario'] as String? ?? '',
      fechaRegistro: (d['fechaRegistro'] as Timestamp?)?.toDate(),
    );
  }
}
