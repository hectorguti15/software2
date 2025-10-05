import 'package:flutter/material.dart';
import 'package:ulima_app/presentation/pages/pago/pago_page.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  const CartPage({required this.cart, super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final total = cart.fold<double>(
        0,
        (sum, item) =>
            sum + ((item['precio'] ?? 0.0) * (item['quantity'] ?? 1)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito'),
        backgroundColor: primary,
      ),
      body: cart.isEmpty
          ? Center(
              child: Text(
                'Tu carrito está vacío',
                style: TextStyle(fontSize: 20, color: secondary),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item['imagenUrl'] ?? '',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['nombre'] ?? 'Producto',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'S/. ${(item['precio'] ?? 0.0).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: secondary,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.shopping_bag,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Cantidad: ${item['quantity'] ?? 1}',
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Total',
                                      style: TextStyle(
                                          fontSize: 13, color: secondary),
                                    ),
                                    Text(
                                      'S/. ${((item['precio'] ?? 0.0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete_outline,
                                          color: Colors.red[400]),
                                      tooltip: 'Eliminar',
                                      onPressed: () {
                                        setState(() {
                                          cart.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                      Text(
                        'S/. ${total.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PagoPage(cart: cart, total: total)));
                      },
                      child: const Text('Comprar',
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
