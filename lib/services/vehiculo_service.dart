import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vehiculo.dart';

class PlacaDuplicadaException implements Exception {
  final String placa;
  PlacaDuplicadaException(this.placa);

  @override
  String toString() => 'Ya existe un vehículo registrado con la placa $placa';
}

/// Acceso a la colección `vehiculos` en Cloud Firestore.
class VehiculoService {
  VehiculoService({FirebaseFirestore? db})
      : _col = (db ?? FirebaseFirestore.instance).collection('vehiculos');

  final CollectionReference<Map<String, dynamic>> _col;

  /// Lista en tiempo real, del más reciente al más antiguo.
  Stream<List<Vehiculo>> obtenerVehiculos() {
    return _col
        .orderBy('fechaRegistro', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Vehiculo.fromDoc).toList());
  }

  /// Guarda un vehículo nuevo. Lanza [PlacaDuplicadaException] si la placa
  /// ya está registrada (las reglas de Firestore también lo impiden).
  Future<void> registrar(Vehiculo v) async {
    final ref = _col.doc(v.placa);
    final existente = await ref.get();
    if (existente.exists) throw PlacaDuplicadaException(v.placa);
    await ref.set(v.toMap());
  }

  Future<void> eliminar(String placa) => _col.doc(placa).delete();
}
