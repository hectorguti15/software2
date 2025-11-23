import 'package:ulima_app/domain/entity/mensaje_entity.dart';

abstract class MensajesState {}

class MensajesInitial extends MensajesState {}

class MensajesLoading extends MensajesState {}

class MensajesLoaded extends MensajesState {
  final List<Mensaje> mensajes;
  MensajesLoaded(this.mensajes);
}

class MensajesError extends MensajesState {
  final String message;
  MensajesError(this.message);
}
