import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartPage extends StatelessWidget {
  String _formatRupiah(int amount) {
    final angka = amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'Rp $angka';
  }

  final List<CartItem> cartItems;
  final void Function(String) onRemoveFromCart;
  final VoidCallback onCheckout;

  const CartPage({
    super.key,
    required this.cartItems,
    required this.onRemoveFromCart,
    required this.onCheckout,
  });

  int get totalPrice => cartItems.fold<int>(
        0,
        (sum, item) => sum + item.drink.price * item.quantity,
      );

  @override
  Widget build(BuildContext context) {
    if (cartItems.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('Keranjang Anda kosong.'),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Image.asset(
                        item.drink.imageUrl,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.local_cafe, size: 54),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.drink.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.quantity} x ${_formatRupiah(item.drink.price)}',
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatRupiah(item.drink.price * item.quantity),
                              style: const TextStyle(color: Color(0xFF277243)),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Hapus',
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          onRemoveFromCart(item.drink.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _CheckoutForm(
          totalHarga: _formatRupiah(totalPrice),
          onCheckout: onCheckout,
        ),
      ],
    );
  }
}
class _CheckoutForm extends StatefulWidget {
  final String totalHarga;
  final VoidCallback onCheckout;

  const _CheckoutForm({
    required this.totalHarga,
    required this.onCheckout,
  });

  @override
  State<_CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<_CheckoutForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _mejaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _mejaController.dispose();
    super.dispose();
  }


  String? _validasiNama(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama Pemesan tidak boleh kosong';
    }
    return null;
  }

  String? _validasiMeja(String? value) {
    final teks = value?.trim() ?? '';
    if (teks.isEmpty) {
      return 'Nomor Meja tidak boleh kosong';
    }

    final nomor = int.tryParse(teks);
    if (nomor == null) {
      return 'Nomor Meja harus berupa angka';
    }
    if (nomor < 1 || nomor > 20) {
      return 'Nomor Meja harus antara 1-20';
    }
    return null;
  }

  void _prosesCheckout() {
    if (!_formKey.currentState!.validate()) return;

    final nama = _namaController.text.trim();
    final meja = int.parse(_mejaController.text.trim());

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Checkout Berhasil'),
        content: Text(
          'Pesanan atas nama $nama untuk meja $meja berhasil dibuat. '
          'Total pembayaran: ${widget.totalHarga}. '
          'Terima kasih sudah memesan!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              widget.onCheckout();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFFE7F3FC),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data Pemesan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemesan',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: _validasiNama,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _mejaController,
              decoration: const InputDecoration(
                labelText: 'Nomor Meja (1-20)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.table_restaurant_outlined),
              ),
              keyboardType: TextInputType.number,
              validator: _validasiMeja,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _prosesCheckout(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Harga', style: TextStyle(fontSize: 16)),
                Text(
                  widget.totalHarga,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _prosesCheckout,
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
