import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
