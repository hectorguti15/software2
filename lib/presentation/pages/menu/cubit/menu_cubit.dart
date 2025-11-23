import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final GetMenuItems getMenuItemsUseCase;

  MenuCubit({required this.getMenuItemsUseCase}) : super(MenuInitial());

  Future<void> getMenuItems() async {
    try {
      emit(MenuLoading());
      final items = await getMenuItemsUseCase();
      emit(MenuLoaded(items));
    } catch (e) {
      emit(MenuError('Error al cargar el menú: $e'));
    }
  }
}
