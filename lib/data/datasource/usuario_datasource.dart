import 'package:ulima_app/data/model/dto/usuario_model.dart';
import 'package:ulima_app/core/api_service.dart';

abstract class UsuarioDatasource {
  Future<UsuarioModel> getUsuarioActual();
  Future<UsuarioModel> cambiarRol(String usuarioId, String nuevoRol);
  Future<UsuarioModel> getUsuarioById(String usuarioId);
}

class UsuarioDatasourceImpl implements UsuarioDatasource {
  @override
  Future<UsuarioModel> getUsuarioActual() async {
    try {
      // GET /api/usuarios/actual
      final data = await ApiService.get('/usuarios/actual');
      return UsuarioModel.fromJson(data);
    } catch (e) {
      print('[UsuarioDatasource] Error al obtener usuario actual: $e');
      rethrow;
    }
  }

  @override
  Future<UsuarioModel> cambiarRol(String usuarioId, String nuevoRol) async {
    try {
      // PATCH /api/usuarios/:id/rol
      final body = {'rol': nuevoRol};
      final data = await ApiService.patch('/usuarios/$usuarioId/rol', body);
      return UsuarioModel.fromJson(data);
    } catch (e) {
      print('[UsuarioDatasource] Error al cambiar rol: $e');
      rethrow;
    }
  }

  @override
  Future<UsuarioModel> getUsuarioById(String usuarioId) async {
    try {
      // GET /api/usuarios/:id
      final data = await ApiService.get('/usuarios/$usuarioId');
      return UsuarioModel.fromJson(data);
    } catch (e) {
      print('[UsuarioDatasource] Error al obtener usuario: $e');
      rethrow;
    }
  }
}
