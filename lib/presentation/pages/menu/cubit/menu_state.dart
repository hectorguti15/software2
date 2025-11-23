import 'package:ulima_app/domain/entity/menu_entity.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> items;
  MenuLoaded(this.items);
}

class MenuError extends MenuState {
  final String message;
  MenuError(this.message);
}
