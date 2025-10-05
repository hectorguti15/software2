import 'package:ulima_app/domain/entity/menu_entity.dart';

class MenuItemModel {
  final String id;
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final double precio;

  MenuItemModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.precio,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      imagenUrl: json['imagenUrl'],
      precio: (json['precio'] as num).toDouble(),
    );
  }

  MenuItem toEntity() => MenuItem(
        id: id,
        nombre: nombre,
        descripcion: descripcion,
        imagenUrl: imagenUrl,
        precio: precio,
      );
}
