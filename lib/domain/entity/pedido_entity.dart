class PedidoEntity {
  final String codigo;
  final DateTime fecha;
  final List<PedidoItem> items;
  final double total;

  PedidoEntity({
    required this.codigo,
    required this.fecha,
    required this.items,
    required this.total,
  });
}

class PedidoItem {
  final String? id; // ID del item del menú (menuItemId)
  final String nombre;
  final int cantidad;
  final double precio;

  PedidoItem({
    this.id,
    required this.nombre,
    required this.cantidad,
    required this.precio,
  });
}
