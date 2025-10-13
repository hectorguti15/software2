import 'package:ulima_app/data/model/dto/pedido_model.dart';
import 'package:ulima_app/domain/entity/pedido_entity.dart';

abstract class PedidoDataSource {
  Future<void> enviarNotificacion(String codigo);
  Future<void> generarYEnviarBoleta(String codigo);
  Future<void> agregarResena();
  Future<List<PedidoModel>> getHistorial();
}

class PedidoDataSourceImpl implements PedidoDataSource {
  @override
  Future<void> enviarNotificacion(String codigo) async {}
  @override
  Future<void> generarYEnviarBoleta(codigo) async {}

  @override
  Future<void> agregarResena() async {}

  Future<List<PedidoModel>> getHistorial() async {
    // Simula la obtención del historial de pedidos
    await Future.delayed(Duration(seconds: 1)); // Simula un retraso de red
    return [
      PedidoModel(
        codigo: '123',
        fecha: DateTime.now().subtract(Duration(days: 1)),
        items: [],
        total: 29.99,
      ),
      PedidoModel(
        codigo: '124',
        fecha: DateTime.now().subtract(Duration(days: 2)),
        items: [],
        total: 49.99,
      ),
    ];
  }
}
