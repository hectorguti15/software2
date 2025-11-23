import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/secciones_state.dart';

class SeccionesCubit extends Cubit<SeccionesState> {
  final GetSeccionesUsuario getSeccionesUsuario;

  SeccionesCubit({required this.getSeccionesUsuario})
      : super(SeccionesInitial());

  Future<void> loadSecciones(String usuarioId) async {
    try {
      emit(SeccionesLoading());
      final secciones = await getSeccionesUsuario(usuarioId);
      emit(SeccionesLoaded(secciones));
    } catch (e) {
      emit(SeccionesError('Error al cargar secciones: $e'));
    }
  }
}
