import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/presentation/cubit/usuario_cubit.dart';
import 'package:ulima_app/presentation/pages/home/home_page.dart';
import 'package:ulima_app/presentation/theme/app_theme.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Cargar usuario actual al iniciar la app
    injector<UsuarioCubit>().cargarUsuarioActual();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UsuarioCubit>(
      create: (context) => injector<UsuarioCubit>(),
      child: MaterialApp(
        title: 'Ulima App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}
