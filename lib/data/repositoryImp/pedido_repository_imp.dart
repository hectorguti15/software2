import 'package:ulima_app/data/datasource/pedido_datasource.dart';
import 'package:ulima_app/domain/entity/pedido_entity.dart';
import 'package:ulima_app/domain/repository/pedido_repository.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoDataSource remoteDataSource;
  PedidoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> enviarNotificacion(String codigo) async {
    remoteDataSource.enviarNotificacion(codigo);
  }

  @override
  Future<void> generarYEnviarBoleta(String codigo) async {
    remoteDataSource.generarYEnviarBoleta(codigo);
  }

  @override
  Future<void> agregarResena() async {}

  @override
  Future<List<PedidoEntity>> getHistorial({String? usuarioId}) async {
    final models = await remoteDataSource.getHistorial(usuarioId: usuarioId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> crearPedido(
      String usuarioId, List<PedidoItem> items, double total) async {
    await remoteDataSource.crearPedido(usuarioId, items, total);
  }
}
