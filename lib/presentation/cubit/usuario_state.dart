import 'package:ulima_app/domain/entity/usuario_entity.dart';

/// Estados del usuario en la aplicación
abstract class UsuarioState {}

/// Estado inicial (usuario no cargado)
class UsuarioInitial extends UsuarioState {}

/// Cargando datos del usuario
class UsuarioLoading extends UsuarioState {}

/// Usuario cargado exitosamente
class UsuarioLoaded extends UsuarioState {
  final Usuario usuario;

  UsuarioLoaded(this.usuario);
}

/// Error al cargar o actualizar usuario
class UsuarioError extends UsuarioState {
  final String message;

  UsuarioError(this.message);
}
