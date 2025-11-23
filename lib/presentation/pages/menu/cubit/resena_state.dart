import 'package:ulima_app/domain/entity/resena_entity.dart';

abstract class ResenaState {}

class ResenaInitial extends ResenaState {}

class ResenaLoading extends ResenaState {}

class ResenaLoaded extends ResenaState {
  final ResenaItem resena;
  ResenaLoaded(this.resena);
}

class ResenaEmpty extends ResenaState {}

class ResenaError extends ResenaState {
  final String message;
  ResenaError(this.message);
}
