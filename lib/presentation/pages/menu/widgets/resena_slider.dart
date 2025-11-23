import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/usecase/resena_usecase.dart';
import 'package:ulima_app/presentation/pages/menu/cubit/resena_cubit.dart';
import 'package:ulima_app/presentation/pages/menu/cubit/resena_state.dart';

class ResenaSlider extends StatelessWidget {
  final String productId;
  const ResenaSlider({required this.productId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit =
            ResenaCubit(getResenaItemUseCase: injector<GetResenaItem>());
        cubit.getResenaItem(productId);
        return cubit;
      },
      child: BlocBuilder<ResenaCubit, ResenaState>(
        builder: (context, state) {
          if (state is ResenaLoading || state is ResenaInitial) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state is ResenaError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (state is ResenaEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No hay reseñas disponibles',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          if (state is ResenaLoaded) {
            final resena = state.resena;
            return SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: resena.comentarios.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final comentario = resena.comentarios[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Calificación: ${comentario.calificacion}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              '• ${comentario.comentario}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
