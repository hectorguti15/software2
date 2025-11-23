import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ulima_app/domain/entity/mensaje_entity.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/mensajes_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/mensajes_state.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

// HU02: Chat grupal por sección
// HU03: Privilegios del delegado o profesor para anuncios
class ChatTab extends StatefulWidget {
  final Seccion seccion;
  final Usuario? usuario;

  const ChatTab({super.key, required this.seccion, this.usuario});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool _puedeEnviarAnuncios() {
    // HU03: Solo profesor y delegado pueden enviar anuncios
    return widget.usuario?.rol == RolUsuario.profesor ||
        widget.usuario?.rol == RolUsuario.delegado;
  }

  void _enviarMensaje({bool esAnuncio = false}) {
    final contenido = _messageController.text.trim();
    if (contenido.isEmpty) return;

    final mensaje = Mensaje(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      contenido: contenido,
      autorId: widget.usuario?.id ?? 'user001',
      autorNombre: widget.usuario?.nombre ?? 'Usuario',
      fecha: DateTime.now(),
      esAnuncio: esAnuncio,
    );

    context.read<MensajesCubit>().enviar(widget.seccion.id, mensaje);
    _messageController.clear();
    _scrollToBottom();

    // HU07: Notificación (si es anuncio)
    if (esAnuncio) {
      // TODO: Enviar notificación push real cuando esté el backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anuncio enviado a todos los miembros'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _mostrarDialogoAnuncio() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enviar Anuncio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Los anuncios se destacarán en el chat y todos los miembros recibirán una notificación.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Escribe tu anuncio...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _messageController.clear();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _enviarMensaje(esAnuncio: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UlimaColors.orange,
            ),
            child: const Text('Enviar Anuncio'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HU03: Botón para enviar anuncios (solo profesor/delegado)
        if (_puedeEnviarAnuncios())
          Container(
            padding: const EdgeInsets.all(8),
            color: UlimaColors.orange.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.campaign, color: UlimaColors.orange),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Tienes permisos para enviar anuncios',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton.icon(
                  onPressed: _mostrarDialogoAnuncio,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Anuncio'),
                  style: TextButton.styleFrom(
                    foregroundColor: UlimaColors.orange,
                  ),
                ),
              ],
            ),
          ),
        // Lista de mensajes
        Expanded(
          child: BlocBuilder<MensajesCubit, MensajesState>(
            builder: (context, state) {
              if (state is MensajesLoading || state is MensajesInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is MensajesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(state.message),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<MensajesCubit>()
                              .loadMensajes(widget.seccion.id);
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                );
              }

              if (state is MensajesLoaded) {
                final mensajes = state.mensajes;
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _scrollToBottom());

                if (mensajes.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline,
                            size: 60, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No hay mensajes aún',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sé el primero en enviar un mensaje',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: mensajes.length,
                  itemBuilder: (context, index) {
                    final mensaje = mensajes[index];
                    final esMio = mensaje.autorId == widget.usuario?.id ||
                        mensaje.autorId == 'user001';

                    return _MensajeItem(
                      mensaje: mensaje,
                      esMio: esMio,
                    );
                  },
                );
              }

              return const SizedBox();
            },
          ),
        ),
        // Campo de entrada de mensaje
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Escribe un mensaje...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _enviarMensaje(),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: UlimaColors.orange,
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () => _enviarMensaje(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MensajeItem extends StatelessWidget {
  final Mensaje mensaje;
  final bool esMio;

  const _MensajeItem({required this.mensaje, required this.esMio});

  @override
  Widget build(BuildContext context) {
    // HU03: Los anuncios se muestran destacados
    if (mensaje.esAnuncio) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: UlimaColors.orange.withOpacity(0.1),
          border: Border.all(color: UlimaColors.orange, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.campaign,
                    color: UlimaColors.orange, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'ANUNCIO',
                  style: TextStyle(
                    color: UlimaColors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              mensaje.contenido,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mensaje.autorNombre,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: UlimaColors.orange,
                  ),
                ),
                Text(
                  _formatearFecha(mensaje.fecha),
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Mensajes normales
    return Align(
      alignment: esMio ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment:
              esMio ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!esMio)
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  mensaje.autorNombre,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: esMio ? UlimaColors.orange : Colors.grey[300],
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                mensaje.contenido,
                style: TextStyle(
                  fontSize: 15,
                  color: esMio ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Text(
                _formatearFecha(mensaje.fecha),
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inMinutes < 1) {
      return 'Ahora';
    } else if (diferencia.inHours < 1) {
      return '${diferencia.inMinutes}m';
    } else if (diferencia.inDays < 1) {
      return '${diferencia.inHours}h';
    } else if (diferencia.inDays < 7) {
      return '${diferencia.inDays}d';
    } else {
      return DateFormat('dd/MM/yyyy').format(fecha);
    }
  }
}
