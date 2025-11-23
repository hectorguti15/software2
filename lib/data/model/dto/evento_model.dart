import 'package:ulima_app/domain/entity/evento_entity.dart';

class EventoModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String tipo;

  EventoModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    return EventoModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'tipo': tipo,
    };
  }

  Evento toEntity() {
    TipoEvento tipoEnum;
    switch (tipo.toLowerCase()) {
      case 'entrega':
        tipoEnum = TipoEvento.entrega;
        break;
      case 'evaluacion':
        tipoEnum = TipoEvento.evaluacion;
        break;
      default:
        tipoEnum = TipoEvento.evento;
    }

    return Evento(
      id: id,
      titulo: titulo,
      descripcion: descripcion,
      fecha: DateTime.parse(fecha),
      tipo: tipoEnum,
    );
  }
}
