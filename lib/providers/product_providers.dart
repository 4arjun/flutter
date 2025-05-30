import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lascade_demo_app/services/product_api.dart';
import 'package:lascade_demo_app/models/product.dart';

final _productApiProvider = Provider<ProductApi>((ref) => ProductApi());

final featuredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.read(_productApiProvider);

  final allProducts = await api.fetchAllProducts();

  allProducts.shuffle();
  return allProducts.take(4).toList();
});
final categoryProductProvider = FutureProvider.family<List<Product>, String>((
  ref,
  category,
) async {
  final api = ref.read(_productApiProvider);
  final categoryProducts = await api.fetchProductsByCategory(category);
  categoryProducts.shuffle();
  return categoryProducts.take(4).toList();
});

final popularProductProvider = FutureProvider<List<Product>>((ref) async {
  final api = ref.read(_productApiProvider);

  final allProducts = await api.fetchAllProducts();

  allProducts.shuffle();
  return allProducts.take(4).toList();
});
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  // Prevent this provider from being disposed
  ref.keepAlive();

  final api = ref.read(_productApiProvider);
  final allProducts = await api.fetchAllProducts();
  return allProducts;
});
