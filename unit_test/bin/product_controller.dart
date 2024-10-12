import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final productsController = ProductsController(ProductService(http.Client()));
  await productsController.getProducts();
  await productsController.getCategories();
  await productsController
      .getProductsByCategory(productsController.categories[0]);
  await productsController.getProductsByCategory('');

  await productsController.getProduct(1);
  productsController.toPrint();
}

class ProductsController {
  final ProductService _productService;

  ProductsController(this._productService);

  final List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  final List<String> _categories = [];
  List<String> get categories => _categories;

  void dispose() {
    _products.clear();
    _categories.clear();
  }

  Future<void> getProducts() async {
    try {
      print("===> getProducts api called <===");
      _products.addAll(await _productService.getProducts());
    } catch (e) {
      print('Error getting products: $e');
    }
  }

  Future<void> getCategories() async {
    try {
      print("===> getCategories api called <===");
      _categories.addAll(await _productService.getCategories());
    } catch (e) {
      print('Error getting categories: $e');
    }
  }

  Future<ProductModel?> getProduct(num id) async {
    try {
      print("===> getProduct api called <===");
      return await _productService.getProduct(id);
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  Future<void> getProductsByCategory(String category) async {
    try {
      print(
          "===> getProductsByCategory api called with category: $category <===");
      _products.addAll(await _productService.getProductsByCategory(category));
    } catch (e) {
      print('Error getting products by category: $e');
    }
  }

  void toPrint() {
    print('Products: ${_products.length}');
    print('Categories: ${_categories.length}');
  }
}

class ProductService {
  final http.Client _client;

  const ProductService(this._client);

  Future<List<ProductModel>> getProducts() async {
    try {
      final response =
          await _client.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return jsonBody
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();
      }
      throw Exception(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ProductModel> getProduct(num id) async {
    try {
      final response =
          await _client.get(Uri.parse('https://fakestoreapi.com/products/$id'));
      if (response.statusCode == 200) {
        return ProductModel.fromJson(jsonDecode(response.body));
      }
      throw Exception(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _client
          .get(Uri.parse('https://fakestoreapi.com/products/categories'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body).cast<String>();
      }
      throw Exception(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final response = await _client.get(
          Uri.parse('https://fakestoreapi.com/products/category/$category'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)
            .map<ProductModel>((json) => ProductModel.fromJson(json))
            .toList();
      }
      throw Exception(response.body);
    } catch (e) {
      throw Exception(e);
    }
  }
}

///
/// [ProductModel]
///
class ProductModel {
  final num id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final num rating;
  final num count;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.count,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? -1) as num,
      title: (json['title'] ?? '') as String,
      price: (json['price'] ?? 0.0) as num,
      description: (json['description'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      rating: (json['rating']?['rate'] ?? 0.0) as num,
      count: (json['rating']?['count'] ?? 0) as num,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      "rating": {'rate': rating, 'count': count},
    };
  }

  bool get isValidModel => id >= 0 && title.isNotEmpty && price > 0.0;
}
