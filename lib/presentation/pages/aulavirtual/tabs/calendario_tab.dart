import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ulima_app/domain/entity/evento_entity.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/eventos_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/eventos_state.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

// HU06: Calendario de entregables y eventos
class CalendarioTab extends StatefulWidget {
  final Seccion seccion;
  final Usuario? usuario;

  const CalendarioTab({super.key, required this.seccion, this.usuario});

  @override
  State<CalendarioTab> createState() => _CalendarioTabState();
}

class _CalendarioTabState extends State<CalendarioTab> {
  DateTime _mesActual = DateTime.now();

  bool _puedeCrearEventos() {
    // HU04: Solo profesor y delegado pueden crear eventos
    return widget.usuario?.rol == RolUsuario.profesor ||
        widget.usuario?.rol == RolUsuario.delegado;
  }

  void _mostrarDialogoCrearEvento() {
    final tituloController = TextEditingController();
    final descripcionController = TextEditingController();
    DateTime fechaSeleccionada = DateTime.now();
    TipoEvento tipoSeleccionado = TipoEvento.evento;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Crear Evento'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    hintText: 'Ej: Entrega Proyecto Final',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descripcionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Descripción',
                    hintText: 'Detalles del evento...',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Tipo de evento:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<TipoEvento>(
                  value: tipoSeleccionado,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: TipoEvento.values.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Row(
                        children: [
                          Icon(_getIconoTipo(tipo), size: 20),
                          const SizedBox(width: 8),
                          Text(_getNombreTipo(tipo)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    setDialogState(() {
                      tipoSeleccionado = valor!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Fecha'),
                  subtitle:
                      Text(DateFormat('dd/MM/yyyy').format(fechaSeleccionada)),
                  onTap: () async {
                    final fecha = await showDatePicker(
                      context: context,
                      initialDate: fechaSeleccionada,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (fecha != null) {
                      setDialogState(() {
                        fechaSeleccionada = fecha;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final titulo = tituloController.text.trim();
                final descripcion = descripcionController.text.trim();

                if (titulo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ingresa un título para el evento')),
                  );
                  return;
                }

                final evento = Evento(
                  id: 'evt_${DateTime.now().millisecondsSinceEpoch}',
                  titulo: titulo,
                  descripcion: descripcion,
                  fecha: fechaSeleccionada,
                  tipo: tipoSeleccionado,
                );

                try {
                  await this.context.read<EventosCubit>().crear(
                        widget.seccion.id,
                        evento,
                      );

                  // Solo si llegamos aquí, fue exitoso
                  Navigator.pop(dialogContext);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Evento creado exitosamente')),
                    );
                  }
                } catch (e) {
                  // Error al crear
                  Navigator.pop(dialogContext);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al crear evento: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: UlimaColors.orange,
              ),
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }

  List<Evento> _getEventosDelMes(List<Evento> eventos) {
    return eventos.where((evento) {
      return evento.fecha.year == _mesActual.year &&
          evento.fecha.month == _mesActual.month;
    }).toList();
  }

  List<Evento> _getProximosEventos(List<Evento> eventos) {
    final ahora = DateTime.now();
    return eventos.where((evento) => evento.fecha.isAfter(ahora)).toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventosCubit, EventosState>(
      builder: (context, state) {
        if (state is EventosLoading || state is EventosInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EventosError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<EventosCubit>().loadEventos(widget.seccion.id);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is EventosLoaded) {
          final eventos = state.eventos;
          final eventosDelMes = _getEventosDelMes(eventos);
          final proximosEventos = _getProximosEventos(eventos);

          return Column(
            children: [
              // Header con mes actual y botón crear
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: UlimaColors.orange,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _mesActual = DateTime(
                            _mesActual.year,
                            _mesActual.month - 1,
                          );
                        });
                      },
                    ),
                    Text(
                      DateFormat('MMMM yyyy', 'es').format(_mesActual),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon:
                          const Icon(Icons.chevron_right, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _mesActual = DateTime(
                            _mesActual.year,
                            _mesActual.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
              // Mini calendario visual del mes
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[100],
                child: _MiniCalendario(
                  mesActual: _mesActual,
                  eventos: eventosDelMes,
                ),
              ),
              // Botón crear evento (solo profesor/delegado)
              if (_puedeCrearEventos())
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: _mostrarDialogoCrearEvento,
                    icon: const Icon(Icons.add),
                    label: const Text('Crear Evento'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: UlimaColors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ),
              // Lista de próximos eventos
              Expanded(
                child: proximosEventos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.event_available,
                                size: 60, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              'No hay eventos próximos',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            if (_puedeCrearEventos()) ...[
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: _mostrarDialogoCrearEvento,
                                icon: const Icon(Icons.add),
                                label: const Text('Crear primer evento'),
                              ),
                            ],
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: proximosEventos.length,
                        itemBuilder: (context, index) {
                          return _EventoItem(evento: proximosEventos[index]);
                        },
                      ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  IconData _getIconoTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.entrega:
        return Icons.assignment_turned_in;
      case TipoEvento.evaluacion:
        return Icons.quiz;
      default:
        return Icons.event;
    }
  }

  String _getNombreTipo(TipoEvento tipo) {
    switch (tipo) {
      case TipoEvento.entrega:
        return 'Entrega';
      case TipoEvento.evaluacion:
        return 'Evaluación';
      default:
        return 'Evento';
    }
  }
}

class _MiniCalendario extends StatelessWidget {
  final DateTime mesActual;
  final List<Evento> eventos;

  const _MiniCalendario({
    required this.mesActual,
    required this.eventos,
  });

  @override
  Widget build(BuildContext context) {
    final primerDia = DateTime(mesActual.year, mesActual.month, 1);
    final ultimoDia = DateTime(mesActual.year, mesActual.month + 1, 0);
    final diasEnMes = ultimoDia.day;
    final primerDiaSemana = primerDia.weekday % 7;

    return Column(
      children: [
        // Nombres de los días
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['D', 'L', 'M', 'X', 'J', 'V', 'S']
              .map((dia) => Expanded(
                    child: Text(
                      dia,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Días del mes
        ...List.generate((diasEnMes + primerDiaSemana) ~/ 7 + 1, (semana) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (diaSemana) {
              final dia = semana * 7 + diaSemana - primerDiaSemana + 1;
              if (dia < 1 || dia > diasEnMes) {
                return const Expanded(child: SizedBox(height: 36));
              }

              final fecha = DateTime(mesActual.year, mesActual.month, dia);
              final tieneEvento = eventos.any((e) =>
                  e.fecha.year == fecha.year &&
                  e.fecha.month == fecha.month &&
                  e.fecha.day == fecha.day);
              final esHoy = DateTime.now().year == fecha.year &&
                  DateTime.now().month == fecha.month &&
                  DateTime.now().day == fecha.day;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(2),
                  height: 36,
                  decoration: BoxDecoration(
                    color: esHoy
                        ? UlimaColors.orange
                        : (tieneEvento ? Colors.orange[100] : null),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      '$dia',
                      style: TextStyle(
                        fontSize: 12,
                        color: esHoy ? Colors.white : Colors.black87,
                        fontWeight:
                            tieneEvento ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}

class _EventoItem extends StatelessWidget {
  final Evento evento;

  const _EventoItem({required this.evento});

  IconData _getIcono() {
    switch (evento.tipo) {
      case TipoEvento.entrega:
        return Icons.assignment_turned_in;
      case TipoEvento.evaluacion:
        return Icons.quiz;
      default:
        return Icons.event;
    }
  }

  Color _getColor() {
    switch (evento.tipo) {
      case TipoEvento.entrega:
        return Colors.blue;
      case TipoEvento.evaluacion:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  String _getDiasRestantes() {
    final ahora = DateTime.now();
    final diferencia = evento.fecha.difference(ahora).inDays;

    if (diferencia == 0) {
      return 'Hoy';
    } else if (diferencia == 1) {
      return 'Mañana';
    } else if (diferencia < 7) {
      return 'En $diferencia días';
    } else {
      return DateFormat('dd/MM/yyyy').format(evento.fecha);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getColor().withOpacity(0.1),
          child: Icon(_getIcono(), color: _getColor()),
        ),
        title: Text(
          evento.titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (evento.descripcion.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                evento.descripcion,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _getDiasRestantes(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: evento.descripcion.isNotEmpty,
      ),
    );
  }
}
