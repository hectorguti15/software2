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

class AgregarResena {
  final PedidoRepository repository;
  AgregarResena(this.repository);

  Future<void> call() => repository.agregarResena();
}

class GetHistorial {
  final PedidoRepository repository;

  GetHistorial(this.repository);

  Future<List<PedidoEntity>> call() async {
    return await repository.getHistorial();
  }
}
