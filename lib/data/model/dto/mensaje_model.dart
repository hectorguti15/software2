import 'package:ulima_app/domain/entity/mensaje_entity.dart';

class MensajeModel {
  final String id;
  final String contenido;
  final String autorId;
  final String autorNombre;
  final String fecha;
  final bool esAnuncio;

  MensajeModel({
    required this.id,
    required this.contenido,
    required this.autorId,
    required this.autorNombre,
    required this.fecha,
    this.esAnuncio = false,
  });

  factory MensajeModel.fromJson(Map<String, dynamic> json) {
    return MensajeModel(
      id: json['id'],
      contenido: json['contenido'],
      autorId: json['autorId'],
      autorNombre: json['autorNombre'],
      fecha: json['fecha'],
      esAnuncio: json['esAnuncio'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contenido': contenido,
      'autorId': autorId,
      'autorNombre': autorNombre,
      'fecha': fecha,
      'esAnuncio': esAnuncio,
    };
  }

  Mensaje toEntity() => Mensaje(
        id: id,
        contenido: contenido,
        autorId: autorId,
        autorNombre: autorNombre,
        fecha: DateTime.parse(fecha),
        esAnuncio: esAnuncio,
      );
}
