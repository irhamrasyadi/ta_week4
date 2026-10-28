import 'drink.dart';

// Data minuman yang sudah ditambahkan ke keranjang.
class CartItem {
  final Drink drink;
  int quantity;

  CartItem({
    required this.drink,
    required this.quantity,
  });
}
