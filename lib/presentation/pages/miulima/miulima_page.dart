import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/presentation/cubit/usuario_cubit.dart';
import 'package:ulima_app/presentation/cubit/usuario_state.dart';
import 'package:ulima_app/presentation/pages/historial/historial_page.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

class MiulimaPage extends StatefulWidget {
  const MiulimaPage({super.key});

  @override
  State<MiulimaPage> createState() => _MiulimaPageState();
}

class _MiulimaPageState extends State<MiulimaPage> {
  String _getRolTexto(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.alumno:
        return 'ALUMNO';
      case RolUsuario.profesor:
        return 'PROFESOR';
      case RolUsuario.delegado:
        return 'DELEGADO';
    }
  }

  IconData _getRolIcono(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.alumno:
        return Icons.school;
      case RolUsuario.profesor:
        return Icons.account_balance;
      case RolUsuario.delegado:
        return Icons.stars;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsuarioCubit, UsuarioState>(
      builder: (context, state) {
        if (state is UsuarioLoading || state is UsuarioInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UsuarioError) {
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
                    context.read<UsuarioCubit>().cargarUsuarioActual();
                  },
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        if (state is! UsuarioLoaded) {
          return const SizedBox();
        }

        final usuario = state.usuario;

        return Container(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.45),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getRolIcono(usuario.rol),
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _getRolTexto(usuario.rol),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          child: Icon(
                            Icons.person_rounded,
                            size: 60,
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.4),
                          ),
                        ),
                      ),
                      Text(usuario.nombre.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(usuario.email,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.7),
                                  fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                // Selector de Rol
                _SelectorRol(usuarioActual: usuario),
                ButtonMiUlima(
                    pressed: () {
                      print(usuario.id);
                    },
                    title: "Carné",
                    icon: Icons.card_membership),
                ButtonMiUlima(
                    pressed: () {
                      print("Horaio");
                    },
                    title: "Horario",
                    icon: Icons.calendar_month),
                ButtonMiUlima(
                    pressed: () {
                      print("Pagos");
                    },
                    title: "Pagos",
                    icon: Icons.payment),
                ButtonMiUlima(
                    pressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HistorialPage()));
                    },
                    title: "Historial Pedidos",
                    icon: Icons.history)
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Widget para seleccionar el rol del usuario
class _SelectorRol extends StatelessWidget {
  final Usuario usuarioActual;

  const _SelectorRol({required this.usuarioActual});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: UlimaColors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: UlimaColors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings,
                  color: UlimaColors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Cambiar Rol (Simulación)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Selecciona un rol para probar las funcionalidades de Aula Virtual:',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: RolUsuario.values.map((rol) {
              final isSelected = usuarioActual.rol == rol;
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getRolIcono(rol),
                      size: 16,
                      color: isSelected ? Colors.white : UlimaColors.orange,
                    ),
                    const SizedBox(width: 6),
                    Text(_getRolNombre(rol)),
                  ],
                ),
                selected: isSelected,
                selectedColor: UlimaColors.orange,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                onSelected: (selected) async {
                  if (selected && !isSelected) {
                    // Mostrar indicador de carga
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Cambiando rol a ${_getRolNombre(rol)}...'),
                        duration: const Duration(milliseconds: 800),
                      ),
                    );

                    // Cambiar rol
                    await context.read<UsuarioCubit>().cambiarRol(rol);

                    // Confirmar cambio
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Rol actualizado a ${_getRolNombre(rol)} ✓'),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          const Text(
            '• Alumno: Solo puede ver contenido\n'
            '• Profesor: Puede crear eventos, materiales y anuncios\n'
            '• Delegado: Mismo permiso que profesor',
            style: TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  String _getRolNombre(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.alumno:
        return 'Alumno';
      case RolUsuario.profesor:
        return 'Profesor';
      case RolUsuario.delegado:
        return 'Delegado';
    }
  }

  IconData _getRolIcono(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.alumno:
        return Icons.school;
      case RolUsuario.profesor:
        return Icons.account_balance;
      case RolUsuario.delegado:
        return Icons.stars;
    }
  }
}

class ButtonMiUlima extends StatelessWidget {
  Function pressed;
  String title;
  IconData icon;
  ButtonMiUlima(
      {required this.pressed,
      required this.title,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          pressed();
        },
        style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.background),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 10),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(
              Icons.arrow_right,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
