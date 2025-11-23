import 'package:ulima_app/domain/entity/pedido_entity.dart';

class PedidoModel {
  final String codigo;
  final DateTime fecha;
  final List<PedidoItem> items;
  final double total;

  PedidoModel({
    required this.codigo,
    required this.fecha,
    required this.items,
    required this.total,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) {
    return PedidoModel(
      codigo: json['codigo'],
      fecha: DateTime.parse(json['fecha']),
      items: (json['items'] as List)
          .map((item) => PedidoItem(
                nombre: item['nombre'],
                cantidad: item['cantidad'],
                precio: (item['precio'] as num).toDouble(),
              ))
          .toList(),
      total: (json['total'] as num).toDouble(),
    );
  }

  PedidoEntity toEntity() {
    return PedidoEntity(
      codigo: codigo,
      fecha: fecha,
      items: items,
      total: total,
    );
  }
}
