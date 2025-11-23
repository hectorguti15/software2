import 'package:ulima_app/data/model/dto/menu_model.dart';
import 'package:ulima_app/core/api_service.dart';

abstract class MenuDatasource {
  Future<List<MenuItemModel>> getMenu();
}

class MenuDataSourceImpl implements MenuDatasource {
  @override
  Future<List<MenuItemModel>> getMenu() async {
    try {
      // Llamada real al backend: GET /api/menu
      final data = await ApiService.get('/menu');
      return (data as List)
          .map((json) => MenuItemModel.fromJson(json))
          .toList();
    } catch (e) {
      print('[MenuDataSource] Error al obtener menú: $e');
      rethrow;
    }
  }
}
