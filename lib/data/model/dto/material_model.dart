import 'package:ulima_app/domain/entity/material_entity.dart';

class MaterialModel {
  final String id;
  final String nombre;
  final String tipo;
  final String url;
  final String fechaSubida;
  final String autorNombre;

  MaterialModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.url,
    required this.fechaSubida,
    required this.autorNombre,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      nombre: json['nombre'],
      tipo: json['tipo'],
      url: json['url'],
      fechaSubida: json['fechaSubida'],
      autorNombre: json['autorNombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'tipo': tipo,
      'url': url,
      'fechaSubida': fechaSubida,
      'autorNombre': autorNombre,
    };
  }

  Material toEntity() {
    TipoMaterial tipoEnum;
    switch (tipo.toLowerCase()) {
      case 'pdf':
        tipoEnum = TipoMaterial.pdf;
        break;
      case 'video':
        tipoEnum = TipoMaterial.video;
        break;
      case 'imagen':
        tipoEnum = TipoMaterial.imagen;
        break;
      case 'documento':
        tipoEnum = TipoMaterial.documento;
        break;
      default:
        tipoEnum = TipoMaterial.otro;
    }

    return Material(
      id: id,
      nombre: nombre,
      tipo: tipoEnum,
      url: url,
      fechaSubida: DateTime.parse(fechaSubida),
      autorNombre: autorNombre,
    );
  }
}
