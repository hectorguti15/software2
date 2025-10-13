import 'package:flutter/material.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/repository/pedido_repository.dart';
import 'package:ulima_app/domain/usecase/pedido_usecase.dart';

class ResenaPage extends StatefulWidget {
  final String codigoPedido;
  const ResenaPage({required this.codigoPedido, super.key});

  @override
  State<ResenaPage> createState() => _ResenaPageState();
}

class _ResenaPageState extends State<ResenaPage> {
  final TextEditingController _textoController = TextEditingController();
  int _calificacion = 0;
  bool _enviando = false;

  void _agregarResena() async {
    setState(() => _enviando = true);
    final repository = injector<PedidoRepository>();
    final agregarResena = AgregarResena(repository);

    await agregarResena.call();
    setState(() => _enviando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reseña agregada')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Reseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textoController,
              decoration: const InputDecoration(
                labelText: 'Escribe tu reseña',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Calificación:'),
                const SizedBox(width: 8),
                for (int i = 1; i <= 5; i++)
                  IconButton(
                    icon: Icon(
                      Icons.star,
                      color: i <= _calificacion ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _calificacion = i;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _enviando ? null : _agregarResena,
              icon: const Icon(Icons.send),
              label: const Text('Enviar reseña'),
            ),
          ],
        ),
      ),
    );
  }
}
