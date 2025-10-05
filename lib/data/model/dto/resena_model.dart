import 'package:ulima_app/domain/entity/resena_entity.dart';

class ComentarioModel {
  final String comentario;
  final String calificacion;

  ComentarioModel({
    required this.comentario,
    required this.calificacion,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      comentario: json['comentario'],
      calificacion: json['calificacion'],
    );
  }
}

class ResenaItemModel {
  final String id;
  final String productId;
  final String calificacion;
  final List<ComentarioModel> comentarios;

  ResenaItemModel({
    required this.id,
    required this.productId,
    required this.calificacion,
    required this.comentarios,
  });

  factory ResenaItemModel.fromJson(Map<String, dynamic> json) {
    return ResenaItemModel(
      id: json['id'],
      productId: json['productId'],
      calificacion: json['calificacion'],
      comentarios: (json['comentarios'] as List<dynamic>)
          .map((e) => ComentarioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  ResenaItem toEntity() => ResenaItem(
        id: id,
        productId: productId,
        calificacion: double.tryParse(calificacion) ?? 0.0,
        comentarios: comentarios
            .map((c) => ComentarioEntity(
                  comentario: c.comentario,
                  calificacion: double.tryParse(c.calificacion) ?? 0.0,
                ))
            .toList(),
      );
}
