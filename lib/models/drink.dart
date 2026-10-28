// Model data untuk satu jenis minuman.
class Drink {
  final String id;
  final String name;
  final int price;
  final String imageUrl;

  const Drink({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
