import 'package:ulima_app/domain/entity/menu_entity.dart';
import 'package:ulima_app/domain/entity/resena_entity.dart';

abstract class ResenaRepository {
  Future<ResenaItem> getResenaItem(String id);
  Future<void> agregarComentario(String productId, String usuarioId,
      String comentario, double calificacion);
}
