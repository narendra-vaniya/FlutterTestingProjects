import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../bin/product_controller.dart';
import 'product_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ProductService>()])
void main() {
  group('Testing ProductsController', () {
    late ProductsController productController;
    late MockProductService mockProductService;
    late ProductModel product1;
    late ProductModel product2;
    late ProductModel product3;
    final categories = [
      "electronics",
      "jewelery",
      "men's clothing",
      "women's clothing"
    ];
    setUp(() {
      mockProductService = MockProductService();
      productController = ProductsController(
        mockProductService,
      );
      product1 = ProductModel(
          id: 1,
          title: 'Necklace',
          price: 1200,
          description: 'This is a necklace',
          category: 'jewelery',
          image: 'Image 1',
          rating: 4.5,
          count: 10);
      product2 = ProductModel(
          id: 2,
          title: 'Mobile',
          price: 3000,
          description: 'This is a mobile',
          category: 'electronics',
          image: 'Image 2',
          rating: 4.5,
          count: 2);
      product3 = ProductModel(
          id: 3,
          title: 'T-shirt',
          price: 250,
          description: 'This is a t-shirt',
          category: "men's clothing",
          image: 'Image 3',
          rating: 4.5,
          count: 7);
    });

    test('Check the products list is empty at initial state', () {
      expect(productController.products.isEmpty, true);
      expect(productController.categories.length, 0);
    });

    test('Get All Products From the API', () async {
      expect(productController.products.isEmpty, true);
      when(mockProductService.getProducts())
          .thenAnswer((_) async => [product1, product2, product3]);
      await productController.getProducts();

      // Check if the products list is not empty
      expect(productController.products.isNotEmpty, true);
      expect(productController.products.length, 3);

      // Check if the categories list is empty
      expect(productController.categories.isEmpty, true);

      // Check if the products list is not empty
      expect(productController.products[0].title, 'Necklace');
      expect(productController.products[1].count, 2);
      expect(productController.products[2], product3);
    });

    test('Check If Products API Failed', () async {
      expect(productController.products.isEmpty, true);
      when(mockProductService.getProducts())
          .thenThrow(Exception('Failed to get products'));
      await productController.getProducts();

      expect(productController.products.isEmpty, true);
      expect(productController.categories.isEmpty, true);
    });

    test('Get all categories', () async {
      expect(productController.categories.isEmpty, true);

      when(mockProductService.getCategories())
          .thenAnswer((_) async => categories);
      await productController.getCategories();

      expect(productController.categories.isNotEmpty, true);
      expect(productController.categories.length, 4);
      expect(productController.categories.first, categories.first);
      expect(productController.products.isEmpty, true);
    });

    test('Check If Categories API Failed', () async {
      expect(productController.categories.isEmpty, true);

      when(mockProductService.getCategories())
          .thenThrow(Exception('Failed to get categories'));
      await productController.getCategories();

      expect(productController.categories.isEmpty, true);
      expect(productController.products.isEmpty, true);
    });

    test('Get products by category', () async {
      expect(productController.products.isEmpty, true);
      expect(productController.categories.isEmpty, true);

      when(mockProductService.getProductsByCategory('electronics'))
          .thenAnswer((_) async => [product2]);
      await productController.getProductsByCategory('electronics');

      expect(productController.products.isNotEmpty, true);
      expect(productController.products.length, 1);
      expect(productController.products[0].category, 'electronics');
    });

    test('Check If Products By Category API Failed', () async {
      expect(productController.products.isEmpty, true);
      expect(productController.categories.isEmpty, true);

      when(mockProductService.getProductsByCategory(''))
          .thenThrow(Exception('Failed to get products by category'));
      await productController.getProductsByCategory('');
      verify(productController.getProductsByCategory('')).called(1);

      expect(productController.products.isEmpty, true);
      expect(productController.categories.isEmpty, true);
    });

    tearDown(() {
      productController.dispose();
    });
  });
}
