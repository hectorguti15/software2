import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/entity/mensaje_entity.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/mensajes_state.dart';

class MensajesCubit extends Cubit<MensajesState> {
  final GetMensajes getMensajes;
  final EnviarMensaje enviarMensaje;

  MensajesCubit({
    required this.getMensajes,
    required this.enviarMensaje,
  }) : super(MensajesInitial());

  Future<void> loadMensajes(String seccionId) async {
    try {
      emit(MensajesLoading());
      final mensajes = await getMensajes(seccionId);
      emit(MensajesLoaded(mensajes));
    } catch (e) {
      emit(MensajesError('Error al cargar mensajes: $e'));
    }
  }

  Future<void> enviar(String seccionId, Mensaje mensaje) async {
    try {
      await enviarMensaje(seccionId, mensaje);
      await loadMensajes(seccionId); // Recargar mensajes
    } catch (e) {
      emit(MensajesError('Error al enviar mensaje: $e'));
    }
  }
}
