import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _gambarController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _gambarController.dispose();
    super.dispose();
  }

  String? _validasiNama(String? value) {
    final nama = value?.trim() ?? '';
    if (nama.isEmpty) {
      return 'Nama produk tidak boleh kosong.';
    }
    if (nama.length < 3) {
      return 'Nama produk minimal 3 karakter.';
    }
    return null;
  }

  String? _validasiHarga(String? value) {
    final harga = value?.trim() ?? '';
    if (harga.isEmpty) {
      return 'Harga tidak boleh kosong.';
    }
    final price = int.tryParse(harga);
    if (price == null) {
      return 'Masukkan harga dalam bentuk angka.';
    }
    if (price <= 0) {
      return 'Harga harus lebih dari 0.';
    }
    return null;
  }

  String? _validasiGambar(String? value) {
    final path = value?.trim() ?? '';
    if (path.isEmpty) {
      return 'Path gambar tidak boleh kosong.';
    }
    if (!path.startsWith('assets/')) {
      return "Path harus dimulai dengan 'assets/'.";
    }
    final lowerPath = path.toLowerCase();
    if (!lowerPath.endsWith('.png') &&
        !lowerPath.endsWith('.jpg') &&
        !lowerPath.endsWith('.jpeg')) {
      return 'Path harus berupa file gambar (.png, .jpg).';
    }
    return null;
  }

  void _simpan() {
    if (_formKey.currentState!.validate()) {
      // Sesuai ketentuan: cukup mengecek form, belum menyimpan produk.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Form valid! Data produk belum ditambahkan ke menu.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  prefixIcon: Icon(Icons.local_cafe_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: _validasiNama,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hargaController,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  prefixIcon: Icon(Icons.payments_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                // Huruf tetap dapat diketik untuk menguji validasi angka.
                validator: _validasiHarga,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gambarController,
                decoration: const InputDecoration(
                  labelText: 'Path Aset Gambar',
                  hintText: 'assets/cafe.png',
                  prefixIcon: Icon(Icons.image_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: _validasiGambar,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _simpan(),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _simpan,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
