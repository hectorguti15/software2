import 'package:flutter/material.dart';
import 'package:ulima_app/presentation/pages/historial/historial_page.dart';

class MiulimaPage extends StatefulWidget {
  const MiulimaPage({super.key});

  @override
  State<MiulimaPage> createState() => _MiulimaPageState();
}

class _MiulimaPageState extends State<MiulimaPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "ALUMNO",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).colorScheme.background,
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
                Text("RALF FERNANDO CALLALI VILLALTA",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w500)),
                Text("20220449",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withOpacity(0.7),
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          ButtonMiUlima(
              pressed: () {
                print("20220449");
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistorialPage()));
              },
              title: "Historial Pedidos",
              icon: Icons.history)
        ],
      ),
    );
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
