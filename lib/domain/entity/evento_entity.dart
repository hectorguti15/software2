enum TipoEvento {
  entrega,
  evaluacion,
  evento,
}

class Evento {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime fecha;
  final TipoEvento tipo;

  Evento({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
  });
}
