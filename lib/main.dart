import 'package:flutter/material.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/presentation/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
