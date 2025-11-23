import 'package:ulima_app/domain/entity/pedido_entity.dart';
import 'package:ulima_app/domain/repository/pedido_repository.dart';

class EnviarNotificacion {
  final PedidoRepository repository;
  String codigo;
  EnviarNotificacion(this.repository, this.codigo);

  Future<void> call() => repository.enviarNotificacion(codigo);
}

class GenerarYEnviarBoleta {
  final PedidoRepository repository;
  String codigo;
  GenerarYEnviarBoleta(this.repository, this.codigo);

  Future<void> call() => repository.generarYEnviarBoleta(codigo);
}

class GetHistorial {
  final PedidoRepository repository;

  GetHistorial(this.repository);

  Future<List<PedidoEntity>> call({String? usuarioId}) async {
    return await repository.getHistorial(usuarioId: usuarioId);
  }
}

class CrearPedido {
  final PedidoRepository repository;

  CrearPedido(this.repository);

  Future<void> call(
      String usuarioId, List<PedidoItem> items, double total) async {
    return await repository.crearPedido(usuarioId, items, total);
  }
}
