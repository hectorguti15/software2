import 'package:ulima_app/domain/entity/evento_entity.dart';
import 'package:ulima_app/domain/entity/material_entity.dart';
import 'package:ulima_app/domain/entity/mensaje_entity.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';

abstract class AulavirtualRepository {
  // HU01: Obtener secciones del usuario (asignación automática)
  Future<List<Seccion>> getSeccionesUsuario(String usuarioId);

  // HU01: Obtener detalle de una sección
  Future<Seccion> getSeccionDetail(String seccionId);

  // HU02: Obtener mensajes del chat grupal (con historial completo)
  Future<List<Mensaje>> getMensajes(String seccionId);

  // HU02, HU03: Enviar mensaje o anuncio
  Future<void> enviarMensaje(String seccionId, Mensaje mensaje);

  // HU04, HU05: Obtener materiales compartidos
  Future<List<Material>> getMateriales(String seccionId);

  // HU04: Subir material (profesor/delegado)
  Future<void> subirMaterial(String seccionId, Material material);

  // HU06: Obtener eventos del calendario
  Future<List<Evento>> getEventos(String seccionId);

  // HU04, HU06: Crear evento (profesor/delegado)
  Future<void> crearEvento(String seccionId, Evento evento);

  // Obtener usuario actual (simulado)
  Future<Usuario> getUsuarioActual();
}
