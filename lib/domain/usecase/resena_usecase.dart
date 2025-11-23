import 'package:ulima_app/domain/entity/resena_entity.dart';
import 'package:ulima_app/domain/repository/resena_repository.dart';

class GetResenaItem {
  final ResenaRepository repository;
  GetResenaItem(this.repository);

  Future<ResenaItem> call(String id) => repository.getResenaItem(id);
}

class AgregarResena {
  final ResenaRepository repository;
  AgregarResena(this.repository);

  Future<void> call(String productId, String usuarioId, String comentario,
      double calificacion) {
    return repository.agregarComentario(
        productId, usuarioId, comentario, calificacion);
  }
}
