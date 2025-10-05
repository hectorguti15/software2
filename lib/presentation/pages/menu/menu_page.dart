import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ulima_app/core/injector.dart';
import 'package:ulima_app/domain/entity/menu_entity.dart';
import 'package:ulima_app/domain/usecase/menu_usecase.dart';
import 'package:ulima_app/presentation/pages/menu/widgets/menu_item_detail_page.dart';

import 'cubit/menu_cubit.dart';

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
                child: BlocBuilder<MenuCubit, List<MenuItem>>(
                  builder: (context, menuItems) {
                    if (menuItems.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return MenuItemCard(
                            nombre: item.nombre,
                            descripcion: item.descripcion,
                            imagenUrl: item.imagenUrl,
                            precio: item.precio,
                            onTap: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MenuItemDetailPage(
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
                child: Image.network(
                  imagenUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
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
