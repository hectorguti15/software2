import 'package:ulima_app/domain/entity/usuario_entity.dart';

class UsuarioModel {
  final String id;
  final String nombre;
  final String email;
  final String rol;

  UsuarioModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      rol: json['rol'],
    );
  }

  Usuario toEntity() {
    RolUsuario rolEnum;
    switch (rol.toLowerCase()) {
      case 'profesor':
        rolEnum = RolUsuario.profesor;
        break;
      case 'delegado':
        rolEnum = RolUsuario.delegado;
        break;
      default:
        rolEnum = RolUsuario.alumno;
    }

    return Usuario(
      id: id,
      nombre: nombre,
      email: email,
      rol: rolEnum,
    );
  }
}
