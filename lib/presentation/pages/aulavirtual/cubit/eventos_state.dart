import 'package:ulima_app/domain/entity/evento_entity.dart';

abstract class EventosState {}

class EventosInitial extends EventosState {}

class EventosLoading extends EventosState {}

class EventosLoaded extends EventosState {
  final List<Evento> eventos;
  EventosLoaded(this.eventos);
}

class EventosError extends EventosState {
  final String message;
  EventosError(this.message);
}
