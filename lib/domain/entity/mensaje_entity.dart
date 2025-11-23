class Mensaje {
  final String id;
  final String contenido;
  final String autorId;
  final String autorNombre;
  final DateTime fecha;
  final bool esAnuncio; // HU03: anuncios destacados de profesor/delegado

  Mensaje({
    required this.id,
    required this.contenido,
    required this.autorId,
    required this.autorNombre,
    required this.fecha,
    this.esAnuncio = false,
  });
}
