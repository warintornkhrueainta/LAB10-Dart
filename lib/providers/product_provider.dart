import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApiService _api = ProductApiService();

  List<ProductModel> products = [];
  bool isLoading = false;

  Future<void> loadProducts() async {
    isLoading = true;
    notifyListeners();

    products = await _api.fetchProducts();

    isLoading = false;
    notifyListeners();
  }
}