import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/domain/repository/usuario_repository.dart';

class GetUsuarioActual {
  final UsuarioRepository repository;

  GetUsuarioActual(this.repository);

  Future<Usuario> call() {
    return repository.getUsuarioActual();
  }
}

class CambiarRolUsuario {
  final UsuarioRepository repository;

  CambiarRolUsuario(this.repository);

  Future<Usuario> call(String usuarioId, String nuevoRol) {
    return repository.cambiarRol(usuarioId, nuevoRol);
  }
}

class GetUsuarioById {
  final UsuarioRepository repository;

  GetUsuarioById(this.repository);

  Future<Usuario> call(String usuarioId) {
    return repository.getUsuarioById(usuarioId);
  }
}
