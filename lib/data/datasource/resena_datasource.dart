import 'package:ulima_app/data/model/dto/resena_model.dart';
import 'package:ulima_app/core/api_service.dart';

abstract class ResenaDatasource {
  Future<ResenaItemModel> getResenaItem(String productId);
  Future<ResenaItemModel> agregarComentario(String productId, String usuarioId,
      String comentario, double calificacion);
}

class ResenaDataSourceImpl implements ResenaDatasource {
  @override
  Future<ResenaItemModel> getResenaItem(String productId) async {
    try {
      // GET /api/resenas/:productId
      final data = await ApiService.get('/resenas/$productId');
      return ResenaItemModel.fromJson(data);
    } catch (e) {
      print('[ResenaDataSource] Error al obtener reseña: $e');
      rethrow;
    }
  }

  @override
  Future<ResenaItemModel> agregarComentario(
    String productId,
    String usuarioId,
    String comentario,
    double calificacion,
  ) async {
    try {
      // POST /api/resenas
      final body = {
        'productId': productId,
        'usuarioId': usuarioId,
        'calificacion': calificacion,
        'comentarios': [
          {
            'comentario': comentario,
            'calificacion': calificacion,
          }
        ],
      };

      final data = await ApiService.post('/resenas', body);
      return ResenaItemModel.fromJson(data);
    } catch (e) {
      print('[ResenaDataSource] Error al agregar comentario: $e');
      rethrow;
    }
  }
}
