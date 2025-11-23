import 'package:ulima_app/domain/entity/seccion_entity.dart';

abstract class SeccionesState {}

class SeccionesInitial extends SeccionesState {}

class SeccionesLoading extends SeccionesState {}

class SeccionesLoaded extends SeccionesState {
  final List<Seccion> secciones;
  SeccionesLoaded(this.secciones);
}

class SeccionesError extends SeccionesState {
  final String message;
  SeccionesError(this.message);
}
