import 'package:ulima_app/data/model/dto/menu_model.dart';

abstract class MenuDatasource {
  Future<List<MenuItemModel>> getMenu();
}

class MenuDataSourceImpl implements MenuDatasource {
  @override
  Future<List<MenuItemModel>> getMenu() async {
    // TODO: llamar al api real
    await Future.delayed(Duration(seconds: 1));
    final data = [
      {
        "id": "1",
        "nombre": "Ceviche",
        "descripcion": "Plato típico de pescado marinado",
        "imagenUrl":
            "https://assets.afcdn.com/recipe/20210416/119490_w1024h1024c1cx363cy240cxt0cyt0cxb726cyb480.jpg",
        "precio": 35
      },
      {
        "id": "2",
        "nombre": "Lomo Saltado",
        "descripcion": "Salteado de carne con papas fritas",
        "imagenUrl":
            "https://assets.afcdn.com/recipe/20210416/119490_w1024h1024c1cx363cy240cxt0cyt0cxb726cyb480.jpg",
        "precio": 40
      },
      {
        "id": "3",
        "nombre": "Aji de Gallina",
        "descripcion": "Pollo deshilachado en salsa cremosa",
        "imagenUrl":
            "https://assets.afcdn.com/recipe/20210416/119490_w1024h1024c1cx363cy240cxt0cyt0cxb726cyb480.jpg",
        "precio": 32
      },
      {
        "id": "4",
        "nombre": "Papa a la Huancaína",
        "descripcion": "Papas con salsa de queso y ají",
        "imagenUrl":
            "https://assets.afcdn.com/recipe/20210416/119490_w1024h1024c1cx363cy240cxt0cyt0cxb726cyb480.jpg",
        "precio": 28
      },
      {
        "id": "5",
        "nombre": "Anticuchos",
        "descripcion": "Brochetas de corazón de res",
        "imagenUrl":
            "https://assets.afcdn.com/recipe/20210416/119490_w1024h1024c1cx363cy240cxt0cyt0cxb726cyb480.jpg",
        "precio": 30
      }
    ];
    return data.map((json) => MenuItemModel.fromJson(json)).toList();
  }
}
