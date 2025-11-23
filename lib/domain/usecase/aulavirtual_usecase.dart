import 'package:ulima_app/domain/entity/evento_entity.dart';
import 'package:ulima_app/domain/entity/material_entity.dart';
import 'package:ulima_app/domain/entity/mensaje_entity.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/domain/repository/aulavirtual_repository.dart';

// HU01: Obtener secciones asignadas al usuario
class GetSeccionesUsuario {
  final AulavirtualRepository repository;
  GetSeccionesUsuario(this.repository);

  Future<List<Seccion>> call(String usuarioId) =>
      repository.getSeccionesUsuario(usuarioId);
}

// HU01: Obtener detalle de sección
class GetSeccionDetail {
  final AulavirtualRepository repository;
  GetSeccionDetail(this.repository);

  Future<Seccion> call(String seccionId) =>
      repository.getSeccionDetail(seccionId);
}

// HU02: Obtener mensajes del chat
class GetMensajes {
  final AulavirtualRepository repository;
  GetMensajes(this.repository);

  Future<List<Mensaje>> call(String seccionId) =>
      repository.getMensajes(seccionId);
}

// HU02, HU03: Enviar mensaje o anuncio
class EnviarMensaje {
  final AulavirtualRepository repository;
  EnviarMensaje(this.repository);

  Future<void> call(String seccionId, Mensaje mensaje) =>
      repository.enviarMensaje(seccionId, mensaje);
}

// HU04, HU05: Obtener materiales
class GetMateriales {
  final AulavirtualRepository repository;
  GetMateriales(this.repository);

  Future<List<Material>> call(String seccionId) =>
      repository.getMateriales(seccionId);
}

// HU04: Subir material
class SubirMaterial {
  final AulavirtualRepository repository;
  SubirMaterial(this.repository);

  Future<void> call(String seccionId, Material material) =>
      repository.subirMaterial(seccionId, material);
}

// HU06: Obtener eventos del calendario
class GetEventos {
  final AulavirtualRepository repository;
  GetEventos(this.repository);

  Future<List<Evento>> call(String seccionId) =>
      repository.getEventos(seccionId);
}

// HU04, HU06: Crear evento
class CrearEvento {
  final AulavirtualRepository repository;
  CrearEvento(this.repository);

  Future<void> call(String seccionId, Evento evento) =>
      repository.crearEvento(seccionId, evento);
}

// Obtener usuario actual
class GetUsuarioActual {
  final AulavirtualRepository repository;
  GetUsuarioActual(this.repository);

  Future<Usuario> call() => repository.getUsuarioActual();
}
