enum TipoMaterial {
  pdf,
  video,
  imagen,
  documento,
  otro,
}

class Material {
  final String id;
  final String nombre;
  final TipoMaterial tipo;
  final String url;
  final DateTime fechaSubida;
  final String autorNombre;

  Material({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.url,
    required this.fechaSubida,
    required this.autorNombre,
  });
}
