import 'dart:convert';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import '../bin/product_controller.dart';
import 'product_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  group('Test Product Service', () {
    late ProductService productService;
    final mockClient = MockClient();
    late Map<String, dynamic> mensClothing;
    late Map<String, dynamic> jewelery;
    late Map<String, dynamic> electronics;
    late Map<String, dynamic> womenClothing;

    final menClothingCategory = 'men\'s clothing';
    // final jeweleryCategory = 'jewelery';
    // final electronicsCategory = 'electronics';
    final womenClothingCategory = 'women\'s clothing';

    setUpAll(() {
      productService = ProductService(mockClient);
      mensClothing = {
        "id": 1,
        "title": "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        "price": 109.95,
        "description":
            "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        "category": "men's clothing",
        "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        "rating": {"rate": 3.9, "count": 120}
      };

      jewelery = {
        "id": 5,
        "title":
            "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
        "price": 695,
        "description":
            "From our Legends Collection, the Naga was inspired by the mythical water dragon that protects the ocean's pearl. Wear facing inward to be bestowed with love and abundance, or outward for protection.",
        "category": "jewelery",
        "image":
            "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
        "rating": {"rate": 4.6, "count": 400}
      };
      electronics = {
        "id": 9,
        "title": "WD 2TB Elements Portable External Hard Drive - USB 3.0 ",
        "price": 64,
        "description":
            "USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7; Reformatting may be required for other operating systems; Compatibility may vary depending on user’s hardware configuration and operating system",
        "category": "electronics",
        "image": "https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg",
        "rating": {"rate": 3.3, "count": 203}
      };
      womenClothing = {
        "id": 15,
        "title": "BIYLACLESEN Women's 3-in-1 Snowboard Jacket Winter Coats",
        "price": 56.99,
        "description":
            "Note:The Jackets is US standard size, Please choose size as your usual wear Material: 100% Polyester; Detachable Liner Fabric: Warm Fleece. Detachable Functional Liner: Skin Friendly, Lightweigt and Warm.Stand Collar Liner jacket, keep you warm in cold weather. Zippered Pockets: 2 Zippered Hand Pockets, 2 Zippered Pockets on Chest (enough to keep cards or keys)and 1 Hidden Pocket Inside.Zippered Hand Pockets and Hidden Pocket keep your things secure. Humanized Design: Adjustable and Detachable Hood and Adjustable cuff to prevent the wind and water,for a comfortable fit. 3 in 1 Detachable Design provide more convenience, you can separate the coat and inner as needed, or wear it together. It is suitable for different season and help you adapt to different climates",
        "category": "women's clothing",
        "image": "https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_.jpg",
        "rating": {"rate": 2.6, "count": 235}
      };
    });

    group('/products api test', () {
      test('Test product api with status code 200', () async {
        final uri = Uri.parse('https://fakestoreapi.com/products');
        final staticRes = jsonEncode([mensClothing, jewelery]);

        when(mockClient.get(uri)).thenAnswer(
          (_) async => http.Response(staticRes, 200),
        );

        final products = await productService.getProducts();

        expect(products.length, 2);
        expect(products.first.price, 109.95);
        expect(products[1].rating, 4.6);
      });

      test('Test Products api with Exception', () async {
        try {
          final uri = Uri.parse('https://fakestoreapi.com/products');

          when(mockClient.get(uri))
              .thenThrow(Exception('Failed to fetch all products'));

          await productService.getProducts();
        } catch (e) {
          expect(Exception(), isA<Exception>());
          print(e.toString());
        }
      });

      test('Test Products api with diff status code ', () async {
        try {
          final uri = Uri.parse('https://fakestoreapi.com/products');
          final errorString =
              jsonEncode({'error': 'Failed to fetch categories'});
          when(mockClient.get(uri))
              .thenAnswer((_) async => http.Response(errorString, 404));

          await productService.getProducts();
        } catch (e) {
          expect(Exception(), isA<Exception>());
          print(e.toString());
        }
      });

      test("Test Products API with diff json format", () async {
        final uri = Uri.parse('https://fakestoreapi.com/products');
        final product1 = {
          "id": null,
          "price": 109.95,
          "description":
              "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
          "category": "men's clothing",
          "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        };
        final product2 = {
          "id": 1,
          "title": null,
          "price": 109.95,
          "description":
              "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
          "category": "men's clothing",
          "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
          "rating": {"rate": null, "count": 120}
        };
        final staticRes = jsonEncode([product1, product2]);
        when(mockClient.get(uri))
            .thenAnswer((_) async => http.Response(staticRes, 200));
        final products = await productService.getProducts();

        expect(products.length, 2);

        expect(products[0].id, isA<num>());
        expect(products[0].id, -1);
        expect(products[0].count, 0);

        expect(products[1].title.isEmpty, true);
        expect(products[1].rating, 0);

        expect(products[0].isValidModel, false);
        expect(products[1].isValidModel, false);
      });
    });

    group('/categories api test', () {
      test('Test getCategories api with status code 200', () async {
        final uri = Uri.parse('https://fakestoreapi.com/products/categories');
        final staticRes = jsonEncode(
          [
            mensClothing['category'],
            jewelery['category'],
            electronics['category'],
            womenClothing['category']
          ],
        );
        when(mockClient.get(uri))
            .thenAnswer((_) async => http.Response(staticRes, 200));
        final categories = await productService.getCategories();
        expect(categories.length, 4);
        expect(categories, [
          'men\'s clothing',
          'jewelery',
          'electronics',
          'women\'s clothing'
        ]);
      });

      test('Test getCategories api with other status code', () async {
        try {
          final uri = Uri.parse('https://fakestoreapi.com/products/categories');
          final errorString =
              jsonEncode({'error': 'Failed to fetch categories'});

          when(mockClient.get(uri))
              .thenAnswer((_) async => http.Response(errorString, 404));
          await productService.getCategories();
        } catch (e) {
          expect(Exception(), isA<Exception>());
          print(e.toString());
        }
      });

      test('Test getCategories api with exception', () async {
        try {
          final uri = Uri.parse('https://fakestoreapi.com/products/categories');

          when(mockClient.get(uri))
              .thenThrow(Exception('Failed to fetch categories'));
          await productService.getCategories();
        } catch (e) {
          expect(Exception(), isA<Exception>());
          print(e.toString());
        }
      });

      test('Test getCategories api with diff json format', () async {
        final uri = Uri.parse('https://fakestoreapi.com/products/categories');
        final staticRes = jsonEncode([]);
        when(mockClient.get(uri))
            .thenAnswer((_) async => http.Response(staticRes, 200));
        final categories = await productService.getCategories();
        expect(categories.length, 0);
      });
    });

    group('/productsByCategory api test', () {
      test('Test getProductsByCategory api with status code 200', () async {
        final uri = Uri.parse(
            'https://fakestoreapi.com/products/category/$menClothingCategory');
        final staticRes = jsonEncode([mensClothing]);
        when(mockClient.get(uri))
            .thenAnswer((_) async => http.Response(staticRes, 200));
        final products =
            await productService.getProductsByCategory(menClothingCategory);
        expect(products.length, 1);
        expect(products[0].price, 109.95);
        expect(products[0].rating, 3.9);
      });

      test('Test getProductsByCategory api with other status code', () async {
        try {
          final uri =
              Uri.parse('https://fakestoreapi.com/products/category/abc');
          final errorString =
              jsonEncode({'error': 'Product not available in this category'});

          when(mockClient.get(uri)).thenThrow(Exception(errorString));
          await productService.getProductsByCategory('abc');
        } catch (e) {
          expect(Exception(), isA<Exception>());
          print(e.toString());
        }
      });

      test('Test getProductsByCategory api with exception', () async {
        try {
          final uri = Uri.parse(
              'https://fakestoreapi.com/products/category/$womenClothingCategory');

          when(mockClient.get(uri))
              .thenThrow(Exception('Failed to fetch products by category'));
          await productService.getProductsByCategory(womenClothingCategory);
        } catch (e) {
          expect(Exception(), isA<Exception>());
          print(e.toString());
        }
      });

      test('Test getProductsByCategory api with diff json format', () async {
        final product1 = {
          "id": null,
          "price": 109.95,
          "description":
              "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
          "category": "men's clothing",
          "image": "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg",
        };

        final uri = Uri.parse(
            'https://fakestoreapi.com/products/category/$menClothingCategory');
        final staticRes = jsonEncode([product1]);
        when(mockClient.get(uri))
            .thenAnswer((_) async => http.Response(staticRes, 200));
        final products =
            await productService.getProductsByCategory(menClothingCategory);
        expect(products.length, 1);
        expect(products[0].id, -1);
        expect(products[0].title.isEmpty, true);
        expect(products[0].rating, 0);
        expect(products[0].isValidModel, false);
      });
    });
  });
}
