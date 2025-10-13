import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/repository/pedido_repository.dart';
import 'package:ulima_app/domain/usecase/pedido_usecase.dart';
import 'package:ulima_app/presentation/pages/resena/resena_page.dart';
import 'package:permission_handler/permission_handler.dart';

class PagoPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final double total;

  const PagoPage({required this.total, required this.cart, super.key});

  @override
  State<PagoPage> createState() => _PagoPageState();
}

class _PagoPageState extends State<PagoPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _requestNotificationPermission();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    const InitializationSettings initSettings =
        InitializationSettings(android: initSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      await Permission.notification.request();
    }
  }

  Future<void> showOrderNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_pedidos',
      'Pedidos',
      channelDescription: 'Notificaciones de nuevos pedidos',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@drawable/ic_notification',
    );

    const NotificationDetails generalNotificationDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Nuevo Pedido',
      'Tu pedido ha sido confirmado 🎉',
      generalNotificationDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final total = widget.total;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago Exitoso'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600], size: 80),
                  const SizedBox(height: 16),
                  const Text(
                    '¡Pago realizado con éxito!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen de compra',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Número de pedido:'),
                        Text('#12345',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:'),
                        Text('${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                            )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Artículos:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...cart.map(
                      (item) => Text(
                        '${item['quantity']}x ${item['nombre']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                final repository = injector<PedidoRepository>();
                final enviarNotificacion =
                    EnviarNotificacion(repository, "20221178");
                await enviarNotificacion.call();
                final status = await Permission.notification.status;
                if (!status.isGranted) {
                  await Permission.notification.request();
                }
                showOrderNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notificación enviada')),
                );
              },
              icon: const Icon(Icons.notifications),
              label: const Text('Enviar notificación'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final repository = injector<PedidoRepository>();
                final generarYEnviarBoleta =
                    GenerarYEnviarBoleta(repository, "20221178");
                await generarYEnviarBoleta.call();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Boleta enviada')),
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Generar y enviar boleta'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResenaPage(codigoPedido: "123"),
                  ),
                );
              },
              icon: const Icon(Icons.rate_review),
              label: const Text('Agregar reseña'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
