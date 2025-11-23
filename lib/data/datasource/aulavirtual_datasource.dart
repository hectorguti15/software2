import 'package:ulima_app/data/model/dto/evento_model.dart';
import 'package:ulima_app/data/model/dto/material_model.dart';
import 'package:ulima_app/data/model/dto/mensaje_model.dart';
import 'package:ulima_app/data/model/dto/seccion_model.dart';
import 'package:ulima_app/data/model/dto/usuario_model.dart';
import 'package:ulima_app/core/api_service.dart';

abstract class AulavirtualDatasource {
  Future<List<SeccionModel>> getSeccionesUsuario(String usuarioId);
  Future<SeccionModel> getSeccionDetail(String seccionId);
  Future<List<MensajeModel>> getMensajes(String seccionId);
  Future<void> enviarMensaje(String seccionId, MensajeModel mensaje);
  Future<List<MaterialModel>> getMateriales(String seccionId);
  Future<void> subirMaterial(String seccionId, MaterialModel material);
  Future<List<EventoModel>> getEventos(String seccionId);
  Future<void> crearEvento(String seccionId, EventoModel evento);
  Future<UsuarioModel> getUsuarioActual();
}

class AulavirtualDatasourceImpl implements AulavirtualDatasource {
  @override
  Future<UsuarioModel> getUsuarioActual() async {
    try {
      // GET /api/usuarios/actual
      final data = await ApiService.get('/usuarios/actual');
      return UsuarioModel.fromJson(data);
    } catch (e) {
      print('[AulavirtualDatasource] Error al obtener usuario actual: $e');
      rethrow;
    }
  }

  @override
  Future<List<SeccionModel>> getSeccionesUsuario(String usuarioId) async {
    try {
      // GET /api/aula-virtual/usuarios/:usuarioId/secciones
      final data =
          await ApiService.get('/aula-virtual/usuarios/$usuarioId/secciones');
      return (data as List).map((json) => SeccionModel.fromJson(json)).toList();
    } catch (e) {
      print('[AulavirtualDatasource] Error al obtener secciones: $e');
      rethrow;
    }
  }

  @override
  Future<SeccionModel> getSeccionDetail(String seccionId) async {
    try {
      // GET /api/aula-virtual/secciones/:seccionId
      final data = await ApiService.get('/aula-virtual/secciones/$seccionId');
      return SeccionModel.fromJson(data);
    } catch (e) {
      print('[AulavirtualDatasource] Error al obtener detalle de sección: $e');
      rethrow;
    }
  }

  @override
  Future<List<MensajeModel>> getMensajes(String seccionId) async {
    try {
      // GET /api/aula-virtual/secciones/:seccionId/mensajes
      final data =
          await ApiService.get('/aula-virtual/secciones/$seccionId/mensajes');
      return (data as List).map((json) => MensajeModel.fromJson(json)).toList();
    } catch (e) {
      print('[AulavirtualDatasource] Error al obtener mensajes: $e');
      rethrow;
    }
  }

  @override
  Future<void> enviarMensaje(String seccionId, MensajeModel mensaje) async {
    try {
      // POST /api/aula-virtual/secciones/:seccionId/mensajes
      final body = {
        'contenido': mensaje.contenido,
        'autorId': mensaje.autorId,
        'autorNombre': mensaje.autorNombre,
        'esAnuncio': mensaje.esAnuncio,
      };

      await ApiService.post(
          '/aula-virtual/secciones/$seccionId/mensajes', body);
    } catch (e) {
      print('[AulavirtualDatasource] Error al enviar mensaje: $e');
      rethrow;
    }
  }

  @override
  Future<List<MaterialModel>> getMateriales(String seccionId) async {
    try {
      // GET /api/aula-virtual/secciones/:seccionId/materiales
      final data =
          await ApiService.get('/aula-virtual/secciones/$seccionId/materiales');
      return (data as List)
          .map((json) => MaterialModel.fromJson(json))
          .toList();
    } catch (e) {
      print('[AulavirtualDatasource] Error al obtener materiales: $e');
      rethrow;
    }
  }

  @override
  Future<void> subirMaterial(String seccionId, MaterialModel material) async {
    try {
      // POST /api/aula-virtual/secciones/:seccionId/materiales
      final body = {
        'nombre': material.nombre,
        'tipo': material.tipo,
        'url': material.url,
        'autorId': material.autorId,
        'autorNombre': material.autorNombre,
      };

      await ApiService.post(
          '/aula-virtual/secciones/$seccionId/materiales', body);
    } catch (e) {
      print('[AulavirtualDatasource] Error al subir material: $e');
      rethrow;
    }
  }

  @override
  Future<List<EventoModel>> getEventos(String seccionId) async {
    try {
      // GET /api/aula-virtual/secciones/:seccionId/eventos
      final data =
          await ApiService.get('/aula-virtual/secciones/$seccionId/eventos');
      return (data as List).map((json) => EventoModel.fromJson(json)).toList();
    } catch (e) {
      print('[AulavirtualDatasource] Error al obtener eventos: $e');
      rethrow;
    }
  }

  @override
  Future<void> crearEvento(String seccionId, EventoModel evento) async {
    try {
      // POST /api/aula-virtual/secciones/:seccionId/eventos
      final body = {
        'titulo': evento.titulo,
        'descripcion': evento.descripcion,
        'fecha': evento.fecha,
        'tipo': evento.tipo,
        'autorId': evento.autorId,
      };

      await ApiService.post('/aula-virtual/secciones/$seccionId/eventos', body);
    } catch (e) {
      print('[AulavirtualDatasource] Error al crear evento: $e');
      rethrow;
    }
  }
}
