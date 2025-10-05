import 'package:ulima_app/domain/entity/menu_entity.dart';

abstract class MenuRepository {
  Future<List<MenuItem>> getMenuItems();
  Future<MenuItem> getMenuItemDetail(String id);
}
