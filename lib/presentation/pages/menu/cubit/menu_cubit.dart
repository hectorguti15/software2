import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/entity/menu_entity.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';

class MenuCubit extends Cubit<List<MenuItem>> {
  final GetMenuItems getMenuItemsUseCase;

  MenuCubit({required this.getMenuItemsUseCase}) : super([]);

  void getMenuItems() async {
    try {
      final items = await getMenuItemsUseCase();
      emit(items);
    } catch (e) {
      emit([]);
    }
  }
}
