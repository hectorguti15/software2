import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/entity/evento_entity.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/eventos_state.dart';

class EventosCubit extends Cubit<EventosState> {
  final GetEventos getEventos;
  final CrearEvento crearEvento;

  EventosCubit({
    required this.getEventos,
    required this.crearEvento,
  }) : super(EventosInitial());

  Future<void> loadEventos(String seccionId) async {
    try {
      emit(EventosLoading());
      final eventos = await getEventos(seccionId);
      emit(EventosLoaded(eventos));
    } catch (e) {
      emit(EventosError('Error al cargar eventos: $e'));
    }
  }

  Future<void> crear(String seccionId, Evento evento) async {
    try {
      await crearEvento(seccionId, evento);
      // Recargar eventos después de crear exitosamente
      final eventos = await getEventos(seccionId);
      emit(EventosLoaded(eventos));
    } catch (e) {
      emit(EventosError('Error al crear evento: $e'));
      rethrow; // Permitir que la UI capture el error
    }
  }
}
