import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/entity/resena_entity.dart';
import 'package:ulima_app/domain/usecase/resena_usecase.dart';

class ResenaCubit extends Cubit<ResenaItem?> {
  final GetResenaItem getResenaItemUseCase;

  ResenaCubit({required this.getResenaItemUseCase}) : super(null);

  void getResenaItem(String id) async {
    try {
      final item = await getResenaItemUseCase(id);
      emit(item);
    } catch (e) {
      emit(null);
    }
  }
}
