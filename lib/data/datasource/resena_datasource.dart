import 'package:ulima_app/data/model/dto/resena_model.dart';

abstract class ResenaDatasource {
  Future<ResenaItemModel> getResenaItem(String id);
}

class ResenaDataSourceImpl implements ResenaDatasource {
  @override
  Future<ResenaItemModel> getResenaItem(String id) async {
    // TODO: llamar al api real
    await Future.delayed(Duration(seconds: 1));
    final data = {
      "id": id,
      "productId": "p$id",
      "calificacion": "4.5",
      "comentarios": [
        {"comentario": "Muy bueno", "calificacion": "4.2"},
        {"comentario": "Repetiría", "calificacion": "4.7"}
      ]
    };
    return ResenaItemModel.fromJson(data);
  }
}
