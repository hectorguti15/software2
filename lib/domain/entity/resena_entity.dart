class ComentarioEntity {
  final String comentario;
  final double calificacion;

  ComentarioEntity({
    required this.comentario,
    required this.calificacion,
  });
}

class ResenaItem {
  final String id;
  final String productId;
  final double calificacion;
  final List<ComentarioEntity> comentarios;

  ResenaItem({
    required this.id,
    required this.productId,
    required this.calificacion,
    required this.comentarios,
  });
}
