import 'package:ulima_app/data/datasource/aulavirtual_datasource.dart';
import 'package:ulima_app/data/model/dto/evento_model.dart';
import 'package:ulima_app/data/model/dto/material_model.dart';
import 'package:ulima_app/data/model/dto/mensaje_model.dart';
import 'package:ulima_app/domain/entity/evento_entity.dart';
import 'package:ulima_app/domain/entity/material_entity.dart';
import 'package:ulima_app/domain/entity/mensaje_entity.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/domain/repository/aulavirtual_repository.dart';

class AulavirtualRepositoryImpl implements AulavirtualRepository {
  final AulavirtualDatasource remoteDataSource;

  AulavirtualRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Seccion>> getSeccionesUsuario(String usuarioId) async {
    final models = await remoteDataSource.getSeccionesUsuario(usuarioId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Seccion> getSeccionDetail(String seccionId) async {
    final model = await remoteDataSource.getSeccionDetail(seccionId);
    return model.toEntity();
  }

  @override
  Future<List<Mensaje>> getMensajes(String seccionId) async {
    final models = await remoteDataSource.getMensajes(seccionId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> enviarMensaje(String seccionId, Mensaje mensaje) async {
    final model = MensajeModel(
      id: mensaje.id,
      contenido: mensaje.contenido,
      autorId: mensaje.autorId,
      autorNombre: mensaje.autorNombre,
      fecha: mensaje.fecha.toIso8601String(),
      esAnuncio: mensaje.esAnuncio,
    );
    await remoteDataSource.enviarMensaje(seccionId, model);
  }

  @override
  Future<List<Material>> getMateriales(String seccionId) async {
    final models = await remoteDataSource.getMateriales(seccionId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> subirMaterial(String seccionId, Material material) async {
    // Obtener usuario actual para autorId
    final usuarioActual = await remoteDataSource.getUsuarioActual();

    String tipoString;
    switch (material.tipo) {
      case TipoMaterial.pdf:
        tipoString = 'pdf';
        break;
      case TipoMaterial.video:
        tipoString = 'video';
        break;
      case TipoMaterial.imagen:
        tipoString = 'imagen';
        break;
      case TipoMaterial.documento:
        tipoString = 'documento';
        break;
      default:
        tipoString = 'otro';
    }

    final model = MaterialModel(
      id: material.id,
      nombre: material.nombre,
      tipo: tipoString,
      url: material.url,
      fechaSubida: material.fechaSubida.toIso8601String(),
      autorId: usuarioActual.id, // ✅ Incluir autorId del usuario actual
      autorNombre: material.autorNombre,
    );
    await remoteDataSource.subirMaterial(seccionId, model);
  }

  @override
  Future<List<Evento>> getEventos(String seccionId) async {
    final models = await remoteDataSource.getEventos(seccionId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> crearEvento(String seccionId, Evento evento) async {
    // Obtener usuario actual para autorId
    final usuarioActual = await remoteDataSource.getUsuarioActual();

    String tipoString;
    switch (evento.tipo) {
      case TipoEvento.entrega:
        tipoString = 'entrega';
        break;
      case TipoEvento.evaluacion:
        tipoString = 'evaluacion';
        break;
      default:
        tipoString = 'evento';
    }

    final model = EventoModel(
      id: evento.id,
      titulo: evento.titulo,
      descripcion: evento.descripcion,
      fecha: evento.fecha.toIso8601String(),
      tipo: tipoString,
      autorId: usuarioActual.id, // ✅ Incluir autorId del usuario actual
    );
    await remoteDataSource.crearEvento(seccionId, model);
  }

  @override
  Future<Usuario> getUsuarioActual() async {
    final model = await remoteDataSource.getUsuarioActual();
    return model.toEntity();
  }
}
