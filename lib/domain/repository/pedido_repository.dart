import 'package:ulima_app/domain/entity/pedido_entity.dart';

abstract class PedidoRepository {
  Future<void> enviarNotificacion(String codigo);
  Future<void> generarYEnviarBoleta(String codigo);
  Future<void> agregarResena();
  Future<List<PedidoEntity>> getHistorial();
}
