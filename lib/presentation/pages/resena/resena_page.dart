import 'package:flutter/material.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/usecase/resena_usecase.dart'
    as resena_usecases;
import 'package:ulima_app/domain/usecase/usuario_usecase.dart';

class ResenaPage extends StatefulWidget {
  final String codigoPedido;
  final String productId;
  const ResenaPage(
      {required this.codigoPedido, required this.productId, super.key});

  @override
  State<ResenaPage> createState() => _ResenaPageState();
}

class _ResenaPageState extends State<ResenaPage> {
  final TextEditingController _textoController = TextEditingController();
  int _calificacion = 0;
  bool _enviando = false;

  void _agregarResena() async {
    if (_calificacion == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una calificación')),
      );
      return;
    }

    if (_textoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe un comentario')),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      // Obtener usuario actual
      final usuario = await injector<GetUsuarioActual>()();

      // Agregar reseña con usuario actual
      await injector<resena_usecases.AgregarResena>().call(
        widget.productId,
        usuario.id,
        _textoController.text.trim(),
        _calificacion.toDouble(),
      );

      if (mounted) {
        setState(() => _enviando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reseña agregada exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print('[ResenaPage] Error al agregar reseña: $e');
      if (mounted) {
        setState(() => _enviando = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al agregar reseña: $e')),
        );
      }
    }
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
