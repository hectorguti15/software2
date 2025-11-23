import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/entity/seccion_entity.dart';
import 'package:ulima_app/domain/entity/usuario_entity.dart';
import 'package:ulima_app/domain/usecase/aulavirtual_usecase.dart';
import 'package:ulima_app/domain/usecase/usuario_usecase.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/eventos_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/materiales_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/cubit/mensajes_cubit.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/tabs/calendario_tab.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/tabs/chat_tab.dart';
import 'package:ulima_app/presentation/pages/aulavirtual/tabs/materiales_tab.dart';
import 'package:ulima_app/presentation/theme/colors.dart';

class SeccionDetailPage extends StatefulWidget {
  final Seccion seccion;

  const SeccionDetailPage({super.key, required this.seccion});

  @override
  State<SeccionDetailPage> createState() => _SeccionDetailPageState();
}

class _SeccionDetailPageState extends State<SeccionDetailPage> {
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    _loadUsuario();
  }

  Future<void> _loadUsuario() async {
    final usuario = await injector<GetUsuarioActual>()();
    setState(() {
      _usuario = usuario;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MensajesCubit(
            getMensajes: injector<GetMensajes>(),
            enviarMensaje: injector<EnviarMensaje>(),
          )..loadMensajes(widget.seccion.id),
        ),
        BlocProvider(
          create: (context) => MaterialesCubit(
            getMateriales: injector<GetMateriales>(),
            subirMaterial: injector<SubirMaterial>(),
          )..loadMateriales(widget.seccion.id),
        ),
        BlocProvider(
          create: (context) => EventosCubit(
            getEventos: injector<GetEventos>(),
            crearEvento: injector<CrearEvento>(),
          )..loadEventos(widget.seccion.id),
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
                  widget.seccion.nombre,
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  widget.seccion.codigo,
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
          body: TabBarView(
            children: [
              ChatTab(seccion: widget.seccion, usuario: _usuario),
              MaterialesTab(seccion: widget.seccion, usuario: _usuario),
              CalendarioTab(seccion: widget.seccion, usuario: _usuario),
            ],
          ),
        ),
      ),
    );
  }
}
