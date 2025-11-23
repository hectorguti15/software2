import 'package:ulima_app/data/datasource/usuario_datasource.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/domain/repository/usuario_repository.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioDatasource remoteDataSource;

  UsuarioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Usuario> getUsuarioActual() async {
    final usuarioModel = await remoteDataSource.getUsuarioActual();
    return usuarioModel.toEntity();
  }

  @override
  Future<Usuario> cambiarRol(String usuarioId, String nuevoRol) async {
    final usuarioModel = await remoteDataSource.cambiarRol(usuarioId, nuevoRol);
    return usuarioModel.toEntity();
  }

  @override
  Future<Usuario> getUsuarioById(String usuarioId) async {
    final usuarioModel = await remoteDataSource.getUsuarioById(usuarioId);
    return usuarioModel.toEntity();
  }
}
