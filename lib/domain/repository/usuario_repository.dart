import 'package:ulima_app/domain/entity/usuario_entity.dart';

abstract class UsuarioRepository {
  Future<Usuario> getUsuarioActual();
  Future<Usuario> cambiarRol(String usuarioId, String nuevoRol);
  Future<Usuario> getUsuarioById(String usuarioId);
}
