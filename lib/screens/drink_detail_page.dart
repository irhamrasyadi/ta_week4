import 'package:flutter/material.dart';
import '../models/drink.dart';

class DrinkDetailPage extends StatefulWidget {
  final Drink drink;
  final void Function(Drink, int) onAddToCart;

  const DrinkDetailPage({
    super.key,
    required this.drink,
    required this.onAddToCart,
  });

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  String _formatRupiah(int amount) {
    final angka = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $angka';
  }

  int _quantity = 1;

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addSelectedDrink() {
    widget.onAddToCart(widget.drink, _quantity);
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Berhasil Ditambahkan'),
        content: Text(
          '${widget.drink.name} sebanyak $_quantity cup '
          'telah masuk ke keranjang.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.drink.name)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDEFFB),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Image.asset(
                    widget.drink.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.local_cafe, size: 110),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.drink.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Harga: ${_formatRupiah(widget.drink.price)}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF277243),
                  ),
                ),
                const SizedBox(height: 34),
                const Text(
                  'Jumlah Pesanan',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _decrement,
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                        size: 34,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _increment,
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.green,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Subtotal: ${_formatRupiah(widget.drink.price * _quantity)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addSelectedDrink,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Tambah ke Keranjang'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
