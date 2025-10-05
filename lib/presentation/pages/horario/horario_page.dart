import 'package:flutter/material.dart';

class HorarioPage extends StatelessWidget {
  const HorarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("Horario Ulima",
            style: Theme.of(context).textTheme.bodyLarge));
  }
}
