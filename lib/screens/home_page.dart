import 'package:flutter/material.dart';
import '../models/drink.dart';
import 'drink_detail_page.dart';
import 'add_product.dart';

class HomePage extends StatefulWidget {
  final List<Drink> drinkList;
  final void Function(Drink, int) onAddToCart;

  const HomePage({
    super.key,
    required this.drinkList,
    required this.onAddToCart,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _formatRupiah(int amount) {
    final angka = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $angka';
  }

  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredDrinks = widget.drinkList.where((drink) {
      return drink.name.toLowerCase().contains(searchText);
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                labelText: 'Cari Minuman',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase().trim();
                });
              },
            ),
          ),
          Expanded(
            child: filteredDrinks.isEmpty
                ? const Center(child: Text('Minuman tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredDrinks.length,
                    itemBuilder: (context, index) {
                      final drink = filteredDrinks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDEFFB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                drink.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.local_cafe, size: 48),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    drink.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatRupiah(drink.price),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF277243),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DrinkDetailPage(
                                      drink: drink,
                                      onAddToCart: widget.onAddToCart,
                                    ),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                              ),
                              child: const Text('Detail'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.onAddToCart(drink, 1);
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${drink.name} ditambahkan ke keranjang.',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              child: const Text('Pesan'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah Produk',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
