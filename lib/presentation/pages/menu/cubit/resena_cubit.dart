import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/usecase/resena_usecase.dart';
import 'resena_state.dart';

class ResenaCubit extends Cubit<ResenaState> {
  final GetResenaItem getResenaItemUseCase;

  ResenaCubit({required this.getResenaItemUseCase}) : super(ResenaInitial());

  Future<void> getResenaItem(String id) async {
    try {
      emit(ResenaLoading());
      final item = await getResenaItemUseCase(id);

      if (item.comentarios.isEmpty) {
        emit(ResenaEmpty());
      } else {
        emit(ResenaLoaded(item));
      }
    } catch (e) {
      print('[ResenaCubit] Error al cargar reseña: $e');
      emit(ResenaError('Error al cargar reseñas: $e'));
    }
  }
}
