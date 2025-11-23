import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';
import 'package:ulima_app/presentation/pages/menu/widgets/menu_item_detail_page.dart';

import 'cubit/menu_cubit.dart';
import 'cubit/menu_state.dart';

class MenuPage extends StatefulWidget {
  Function addToCart;
  List<Map<String, dynamic>> cart;
  MenuPage({required this.addToCart, required this.cart, super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<MenuCubit>(
      create: (_) {
        final cubit = MenuCubit(getMenuItemsUseCase: injector<GetMenuItems>());
        cubit.getMenuItems();
        print(widget.cart);
        return cubit;
      },
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.6),
                      ),
                      hintText: "Buscar comida, bebida o snack",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ))),
                ),
              ),
              Expanded(
                child: BlocBuilder<MenuCubit, MenuState>(
                  builder: (context, state) {
                    if (state is MenuLoading || state is MenuInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is MenuError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline,
                                size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(state.message, textAlign: TextAlign.center),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<MenuCubit>().getMenuItems(),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is MenuLoaded) {
                      if (state.items.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.restaurant_menu,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No hay platos disponibles en este momento',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return MenuItemCard(
                              nombre: item.nombre,
                              descripcion: item.descripcion,
                              imagenUrl: item.imagenUrl,
                              precio: item.precio,
                              onTap: () => {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MenuItemDetailPage(
                                                  menuItem: item,
                                                  addToCart: widget.addToCart,
                                                  initialQuantity: widget.cart
                                                      .firstWhere(
                                                          (element) =>
                                                              element['id'] ==
                                                              item.id,
                                                          orElse: () => {
                                                                'quantity': 0
                                                              })['quantity'],
                                                  cart: widget.cart,
                                                )))
                                  });
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final String imagenUrl;
  final double precio;
  final VoidCallback? onTap;

  const MenuItemCard({
    Key? key,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    required this.precio,
    this.onTap,
  }) : super(key: key);

  Widget _buildMenuImage(String url) {
    // Si la URL está vacía o es inválida, usar placeholder
    if (url.isEmpty) {
      return _fallbackMenuImage();
    }

    return Image.network(
      url,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _fallbackMenuImage();
      },
    );
  }

  Widget _fallbackMenuImage() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.restaurant, size: 40, color: Colors.grey),
          SizedBox(height: 4),
          Text(
            'Sin imagen',
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Imagen del plato
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: SizedBox(
                width: 100,
                height: 100,
                child: _buildMenuImage(imagenUrl),
              ),
            ),
            const SizedBox(width: 12),
            // Nombre, descripción y precio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "S/. $precio",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
