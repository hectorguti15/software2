import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/domain/usecase/usuario_usecase.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/secciones_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/secciones_state.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/seccion_detail_page.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

// HU01: Asignar espacios automáticos por sección
class AulavirtualPage extends StatefulWidget {
  const AulavirtualPage({super.key});

  @override
  State<AulavirtualPage> createState() => _AulavirtualPageState();
}

class _AulavirtualPageState extends State<AulavirtualPage> {
  String? _usuarioId;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUsuario();
  }

  Future<void> _loadUsuario() async {
    try {
      final usuario = await injector<GetUsuarioActual>()();
      setState(() {
        _usuarioId = usuario.id;
        _loading = false;
      });
    } catch (e) {
      print('[AulavirtualPage] Error al cargar usuario: $e');
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null || _usuarioId == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error al cargar usuario: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _loadUsuario();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return BlocProvider(
      create: (context) => SeccionesCubit(
        getSeccionesUsuario: injector<GetSeccionesUsuario>(),
      )..loadSecciones(_usuarioId!),
      child: AulavirtualView(usuarioId: _usuarioId!),
    );
  }
}

class AulavirtualView extends StatelessWidget {
  final String usuarioId;

  const AulavirtualView({super.key, required this.usuarioId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeccionesCubit, SeccionesState>(
      builder: (context, state) {
        if (state is SeccionesLoading || state is SeccionesInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SeccionesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<SeccionesCubit>().loadSecciones(usuarioId);
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is SeccionesLoaded) {
          final secciones = state.secciones;

          if (secciones.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes secciones asignadas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: secciones.length,
            itemBuilder: (context, index) {
              return _SeccionCard(seccion: secciones[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _SeccionCard extends StatelessWidget {
  final Seccion seccion;

  const _SeccionCard({required this.seccion});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SeccionDetailPage(seccion: seccion),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: UlimaColors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.class_,
                      color: UlimaColors.orange,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seccion.nombre,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          seccion.codigo,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Profesor: ${seccion.profesorNombre}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              if (seccion.delegadoNombre != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.stars, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Delegado: ${seccion.delegadoNombre}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
