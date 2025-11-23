import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/entity/pedido_entity.dart';
import 'package:ulima_app/domain/usecase/pedido_usecase.dart';
import 'package:ulima_app/domain/usecase/usuario_usecase.dart';

class HistorialPage extends StatelessWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Pedidos'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<List<PedidoEntity>>(
        future: _loadHistorial(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final pedidos = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pedido #${pedido.codigo}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(pedido.fecha),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const Divider(),
                      ...pedido.items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.cantidad}x ${item.nombre}'),
                                Text('S/ ${item.precio.toStringAsFixed(2)}'),
                              ],
                            ),
                          )),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'S/ ${pedido.total.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<PedidoEntity>> _loadHistorial() async {
    try {
      // Obtener usuario actual
      final usuario = await injector<GetUsuarioActual>()();
      // Obtener historial filtrado por usuario
      return await injector<GetHistorial>().call(usuarioId: usuario.id);
    } catch (e) {
      print('[HistorialPage] Error al cargar historial: $e');
      rethrow;
    }
  }
}
