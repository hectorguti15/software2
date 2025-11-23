import 'package:ulima_app/data/model/dto/pedido_model.dart';
import 'package:ulima_app/domain/entity/pedido_entity.dart';
import 'package:ulima_app/core/api_service.dart';

abstract class PedidoDataSource {
  Future<PedidoModel> crearPedido(
      String usuarioId, List<PedidoItem> items, double total);
  Future<void> enviarNotificacion(String codigo);
  Future<void> generarYEnviarBoleta(String codigo);
  Future<void> agregarResena();
  Future<List<PedidoModel>> getHistorial({String? usuarioId});
}

class PedidoDataSourceImpl implements PedidoDataSource {
  @override
  Future<PedidoModel> crearPedido(
      String usuarioId, List<PedidoItem> items, double total) async {
    try {
      // POST /api/pedidos
      final body = {
        'usuarioId': usuarioId,
        'items': items
            .map((item) => {
                  'menuItemId': item.id ?? '', // ID del item del menú
                  'nombre': item.nombre,
                  'cantidad': item.cantidad,
                  'precio': item.precio,
                })
            .toList(),
      };

      final data = await ApiService.post('/pedidos', body);
      return PedidoModel.fromJson(data);
    } catch (e) {
      print('[PedidoDataSource] Error al crear pedido: $e');
      rethrow;
    }
  }

  @override
  Future<void> enviarNotificacion(String codigo) async {
    try {
      // POST /api/pedidos/:codigo/notificacion
      await ApiService.post('/pedidos/$codigo/notificacion', {});
    } catch (e) {
      print('[PedidoDataSource] Error al enviar notificación: $e');
      rethrow;
    }
  }

  @override
  Future<void> generarYEnviarBoleta(String codigo) async {
    try {
      // POST /api/pedidos/:codigo/boleta
      await ApiService.post('/pedidos/$codigo/boleta', {});
    } catch (e) {
      print('[PedidoDataSource] Error al generar boleta: $e');
      rethrow;
    }
  }

  @override
  Future<void> agregarResena() async {
    // TODO: Implementar cuando se defina el flujo completo de reseñas
  }

  @override
  Future<List<PedidoModel>> getHistorial({String? usuarioId}) async {
    try {
      // GET /api/pedidos?usuarioId=xxx (opcional)
      String endpoint = '/pedidos';
      if (usuarioId != null && usuarioId.isNotEmpty) {
        endpoint += '?usuarioId=$usuarioId';
      }

      final data = await ApiService.get(endpoint);
      return (data as List).map((json) => PedidoModel.fromJson(json)).toList();
    } catch (e) {
      print('[PedidoDataSource] Error al obtener historial: $e');
      rethrow;
    }
  }
}
