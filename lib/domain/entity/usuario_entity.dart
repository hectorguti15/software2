enum RolUsuario {
  alumno,
  profesor,
  delegado,
}

class Usuario {
  final String id;
  final String nombre;
  final String email;
  final RolUsuario rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.rol,
  });
}
