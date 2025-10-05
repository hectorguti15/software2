import 'package:ulima_app/domain/entity/menu_entity.dart';
import 'package:ulima_app/domain/repository/menu_repository.dart';

class GetMenuItems {
  final MenuRepository repository;
  GetMenuItems(this.repository);

  Future<List<MenuItem>> call() => repository.getMenuItems();
}

class GetMenuItemDetail {
  final MenuRepository repository;
  GetMenuItemDetail(this.repository);

  Future<MenuItem> call(String id) => repository.getMenuItemDetail(id);
}
