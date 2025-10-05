import 'package:ulima_app/data/datasource/menu_datasource.dart';
import 'package:ulima_app/domain/entity/menu_entity.dart';
import 'package:ulima_app/domain/repository/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuDatasource remoteDataSource;
  MenuRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MenuItem>> getMenuItems() async {
    final models = await remoteDataSource.getMenu();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<MenuItem> getMenuItemDetail(String id) async {
    final items = await getMenuItems();
    return items.firstWhere((item) => item.id == id);
  }
}
