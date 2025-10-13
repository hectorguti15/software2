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

  PedidoEntity toEntity() {
    return PedidoEntity(
      codigo: codigo,
      fecha: fecha,
      items: items,
      total: total,
    );
  }
}
