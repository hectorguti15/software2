import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/presentation/cubit/usuario_cubit.dart';
import 'package:ulima_app/presentation/cubit/usuario_state.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/eventos_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/materiales_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/mensajes_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/tabs/calendario_tab.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/tabs/chat_tab.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/tabs/materiales_tab.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

class SeccionDetailPage extends StatelessWidget {
  final Seccion seccion;

  const SeccionDetailPage({super.key, required this.seccion});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MensajesCubit(
            getMensajes: injector<GetMensajes>(),
            enviarMensaje: injector<EnviarMensaje>(),
          )..loadMensajes(seccion.id),
        ),
        BlocProvider(
          create: (context) => MaterialesCubit(
            getMateriales: injector<GetMateriales>(),
            subirMaterial: injector<SubirMaterial>(),
          )..loadMateriales(seccion.id),
        ),
        BlocProvider(
          create: (context) => EventosCubit(
            getEventos: injector<GetEventos>(),
            crearEvento: injector<CrearEvento>(),
          )..loadEventos(seccion.id),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: UlimaColors.orange,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seccion.nombre,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  seccion.codigo,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            bottom: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(icon: Icon(Icons.chat), text: 'Chat'),
                Tab(icon: Icon(Icons.folder), text: 'Materiales'),
                Tab(icon: Icon(Icons.calendar_today), text: 'Calendario'),
              ],
            ),
          ),
          body: BlocBuilder<UsuarioCubit, UsuarioState>(
            builder: (context, state) {
              final usuario = state is UsuarioLoaded ? state.usuario : null;

              return TabBarView(
                children: [
                  ChatTab(seccion: seccion, usuario: usuario),
                  MaterialesTab(seccion: seccion, usuario: usuario),
                  CalendarioTab(seccion: seccion, usuario: usuario),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
