import 'package:flutter/material.dart';
import 'package:ulima_app/domain/entity/menu_entity.dart';
import 'package:ulima_app/presentation/pages/cart/cart_page.dart';
import 'package:ulima_app/presentation/pages/menu/widgets/resena_slider.dart';

class MenuItemDetailPage extends StatefulWidget {
  final MenuItem menuItem;
  final Function addToCart;
  final int initialQuantity;
  final List<Map<String, dynamic>> cart;

  MenuItemDetailPage({
    required this.cart,
    required this.initialQuantity,
    required this.addToCart,
    required this.menuItem,
    super.key,
  });

  @override
  State<MenuItemDetailPage> createState() => _MenuItemDetailPageState();
}

class _MenuItemDetailPageState extends State<MenuItemDetailPage> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles: ${widget.menuItem.nombre}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(widget.menuItem.imagenUrl,
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.only(top: 32.0, left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.menuItem.nombre,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.menuItem.descripcion,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Precio: S/ ${widget.menuItem.precio.toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        quantity == 0
                            ? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    quantity++;
                                    widget.addToCart(
                                        widget.menuItem.id,
                                        quantity,
                                        widget.menuItem.nombre,
                                        widget.menuItem.precio,
                                        widget.menuItem.imagenUrl);
                                  });
                                },
                                child: const Text("Agregar al carrito"),
                              )
                            : Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        quantity++;
                                        widget.addToCart(
                                            widget.menuItem.id,
                                            quantity,
                                            widget.menuItem.nombre,
                                            widget.menuItem.precio,
                                            widget.menuItem.imagenUrl);
                                      });
                                    },
                                    icon: Icon(Icons.add_circle_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 30),
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (quantity > 0) {
                                          quantity--;
                                          widget.addToCart(
                                              widget.menuItem.id,
                                              quantity,
                                              widget.menuItem.nombre,
                                              widget.menuItem.precio,
                                              widget.menuItem.imagenUrl);
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.remove_circle_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 30),
                                  ),
                                ],
                              ),
                        Spacer(),
                        quantity > 0
                            ? Padding(
                                padding: const EdgeInsets.only(right: 32),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CartPage(cart: widget.cart)));
                                  },
                                  child: const Text("Comprar"),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Slider de reseñas
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SizedBox(
                        height: 100,
                        child: Center(
                            child: ResenaSlider(productId: widget.menuItem.id)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
