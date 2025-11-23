import 'package:ulima_app/domain/entity/evento_entity.dart';

class EventoModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final String tipo;
  final String? autorId;

  EventoModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.tipo,
    this.autorId,
  });

  factory EventoModel.fromJson(Map<String, dynamic> json) {
    return EventoModel(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fecha: json['fecha'],
      tipo: json['tipo'],
      autorId: json['autorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'fecha': fecha,
      'tipo': tipo,
      'autorId': autorId,
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
