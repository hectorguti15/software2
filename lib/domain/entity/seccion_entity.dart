class Seccion {
  final String id;
  final String nombre;
  final String codigo;
  final String cursoNombre;
  final String profesorNombre;
  final String? delegadoNombre;

  Seccion({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.cursoNombre,
    required this.profesorNombre,
    this.delegadoNombre,
  });
}
