import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addToCart(ProductModel product) {
    final index =
        _items.indexWhere((e) => e.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  void increase(ProductModel product) {
    final item =
        _items.firstWhere((e) => e.product.id == product.id);
    item.quantity++;
    notifyListeners();
  }

  void decrease(ProductModel product) {
    final item =
        _items.firstWhere((e) => e.product.id == product.id);

    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }

    notifyListeners();
  }

  void remove(ProductModel product) {
    _items.removeWhere((e) => e.product.id == product.id);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(
      0,
      (sum, item) =>
          sum + item.product.price * item.quantity,
    );
  }
}