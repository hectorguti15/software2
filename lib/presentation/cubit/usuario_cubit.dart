import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/domain/usecase/usuario_usecase.dart';
import 'package:ulima_app/presentation/cubit/usuario_state.dart';

/// Cubit global para gestionar el estado del usuario actual
/// Centraliza el usuario y su rol para que toda la app tenga acceso
class UsuarioCubit extends Cubit<UsuarioState> {
  final GetUsuarioActual getUsuarioActual;
  final CambiarRolUsuario cambiarRolUsuario;

  UsuarioCubit({
    required this.getUsuarioActual,
    required this.cambiarRolUsuario,
  }) : super(UsuarioInitial());

  /// Carga el usuario actual desde el backend
  Future<void> cargarUsuarioActual() async {
    emit(UsuarioLoading());
    try {
      final usuario = await getUsuarioActual();
      emit(UsuarioLoaded(usuario));
    } catch (e) {
      emit(UsuarioError('Error al cargar usuario: $e'));
    }
  }

  /// Cambia el rol del usuario actual
  Future<void> cambiarRol(RolUsuario nuevoRol) async {
    final currentState = state;
    if (currentState is! UsuarioLoaded) return;

    try {
      // Convertir enum a string
      final rolString = nuevoRol.name;

      // Llamar al backend para cambiar el rol
      final usuarioActualizado = await cambiarRolUsuario(
        currentState.usuario.id,
        rolString,
      );

      // Actualizar estado inmediatamente
      emit(UsuarioLoaded(usuarioActualizado));
    } catch (e) {
      // En caso de error, mantener usuario actual pero notificar
      emit(UsuarioError('Error al cambiar rol: $e'));
      // Recargar usuario anterior
      emit(UsuarioLoaded(currentState.usuario));
    }
  }

  /// Obtiene el usuario actual (si está cargado)
  Usuario? get usuarioActual {
    final currentState = state;
    if (currentState is UsuarioLoaded) {
      return currentState.usuario;
    }
    return null;
  }
}
