import 'package:ulima_app/domain/entity/seccion_entity.dart';

class SeccionModel {
  final String id;
  final String nombre;
  final String codigo;
  final String cursoNombre;
  final String profesorNombre;
  final String? delegadoNombre;

  SeccionModel({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.cursoNombre,
    required this.profesorNombre,
    this.delegadoNombre,
  });

  factory SeccionModel.fromJson(Map<String, dynamic> json) {
    return SeccionModel(
      id: json['id'],
      nombre: json['nombre'],
      codigo: json['codigo'],
      cursoNombre: json['cursoNombre'],
      profesorNombre: json['profesorNombre'],
      delegadoNombre: json['delegadoNombre'],
    );
  }

  Seccion toEntity() => Seccion(
        id: id,
        nombre: nombre,
        codigo: codigo,
        cursoNombre: cursoNombre,
        profesorNombre: profesorNombre,
        delegadoNombre: delegadoNombre,
      );
}
