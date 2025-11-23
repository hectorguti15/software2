import 'package:ulima_app/domain/entity/usuario_entity.dart';

/// Helper para manejar permisos basados en roles
/// según las HU del Sprint 2
class RolPermisosHelper {
  /// HU04: Profesor y delegado pueden crear eventos
  /// HU06: Calendario de entregables y eventos
  static bool puedeCrearEventos(Usuario? usuario) {
    if (usuario == null) return false;
    return usuario.rol == RolUsuario.profesor ||
        usuario.rol == RolUsuario.delegado;
  }

  /// HU04: Profesor y delegado pueden subir materiales
  /// HU05: Alumnos solo pueden ver y descargar
  static bool puedeSubirMateriales(Usuario? usuario) {
    if (usuario == null) return false;
    return usuario.rol == RolUsuario.profesor ||
        usuario.rol == RolUsuario.delegado;
  }

  /// HU03: Profesor y delegado pueden enviar anuncios destacados
  /// HU04: Gestión del aula virtual
  static bool puedeEnviarAnuncios(Usuario? usuario) {
    if (usuario == null) return false;
    return usuario.rol == RolUsuario.profesor ||
        usuario.rol == RolUsuario.delegado;
  }

  /// Verifica si el usuario es profesor
  static bool esProfesor(Usuario? usuario) {
    return usuario?.rol == RolUsuario.profesor;
  }

  /// Verifica si el usuario es delegado
  static bool esDelegado(Usuario? usuario) {
    return usuario?.rol == RolUsuario.delegado;
  }

  /// Verifica si el usuario es alumno
  static bool esAlumno(Usuario? usuario) {
    return usuario?.rol == RolUsuario.alumno;
  }

  /// Verifica si el usuario tiene permisos administrativos (profesor o delegado)
  static bool tienePermisosAdministrativos(Usuario? usuario) {
    return esProfesor(usuario) || esDelegado(usuario);
  }

  /// Obtiene descripción de permisos del rol
  static String obtenerDescripcionPermisos(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.alumno:
        return 'Puede ver contenido del aula virtual (eventos, materiales, mensajes)';
      case RolUsuario.profesor:
        return 'Puede crear eventos, subir materiales y enviar anuncios destacados';
      case RolUsuario.delegado:
        return 'Puede crear eventos, subir materiales y enviar anuncios destacados (autorizado por profesor)';
    }
  }

  /// Obtiene el nombre del rol en español
  static String obtenerNombreRol(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.alumno:
        return 'Alumno';
      case RolUsuario.profesor:
        return 'Profesor';
      case RolUsuario.delegado:
        return 'Delegado';
    }
  }
}
