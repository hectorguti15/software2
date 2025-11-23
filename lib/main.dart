import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/presentation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar locale español para DateFormat
  Intl.defaultLocale = 'es';
  await initializeDateFormatting('es', null);

  setup();
  runApp(const App());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return App();
  }
}
