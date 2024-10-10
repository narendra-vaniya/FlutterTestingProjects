import 'package:test/test.dart';
import '../bin/cart_contorller.dart';

void main() {
  group('Testing CartController', () {
    late CartController cartController;
    late ProductModel apple;
    late ProductModel banana;
    late ProductModel orange;

    /// SetUpAll will be called before all tests are executed
    setUpAll(() {});

    /// setUp will be called before each test is executed
    setUp(() {
      cartController = CartController();
      apple = ProductModel(
          id: "apple",
          name: 'Apple',
          priceInKg: 150.0,
          ratting: 4.5,
          quantity: 1);
      banana = ProductModel(
          id: "banana",
          name: 'Banana',
          priceInKg: 80.0,
          ratting: 4.8,
          quantity: 1);
      orange = ProductModel(
          id: "orange",
          name: 'Orange',
          priceInKg: 120.0,
          ratting: 4.2,
          quantity: 1);
    });

    test('Add a product to the cart', () {
      expect(cartController.products.isEmpty, true);
      cartController.addProductToCart(apple);
      cartController.addProductToCart(banana);
      cartController.addProductToCart(orange);

      expect(cartController.products.length, 3);
      expect(cartController.products["apple"], apple);
      expect(cartController.products["orange"], orange);

      cartController.toPrint();
    });

    test('Add a product that is already in the cart should update quantity',
        () {
      expect(cartController.products.isEmpty, true);
      cartController.addProductToCart(apple);
      cartController.addProductToCart(banana);
      cartController.addProductToCart(orange);
      cartController.addProductToCart(
        ProductModel(
            id: "apple",
            name: 'Apple',
            priceInKg: 120.0,
            ratting: 4.5,
            quantity: 3),
      );
      cartController.addProductToCart(
        ProductModel(
            id: "banana",
            name: 'Banana',
            priceInKg: 70.0,
            ratting: 4.5,
            quantity: 1),
      );

      expect(cartController.products.length, 3);
      expect(cartController.products["apple"]?.quantity, 4);
      expect(cartController.products["banana"]?.quantity, 2);
      expect(cartController.products["orange"]?.quantity, 1);
    });

    test(
        'Add a product that is already in the cart should update price and ratting',
        () {
      expect(cartController.products.isEmpty, true);
      cartController.addProductToCart(apple);
      cartController.addProductToCart(banana);
      cartController.addProductToCart(orange);

      expect(cartController.products['apple']?.priceInKg, 150.0);
      expect(cartController.products['apple']?.ratting, 4.5);

      cartController.addProductToCart(
        ProductModel(
            id: "apple",
            name: 'Apple',
            priceInKg: 120.0,
            ratting: 4,
            quantity: 3),
      );

      expect(cartController.products['apple']?.priceInKg, 120.0);
      expect(cartController.products['apple']?.ratting, 4);
      expect(cartController.products.length, 3);
    });

    test('Test total price of the cart', () {
      expect(cartController.products.isEmpty, true);

      cartController.addProductToCart(apple);
      cartController.addProductToCart(banana);
      cartController.addProductToCart(orange);
      cartController.addProductToCart(
        ProductModel(
            id: "apple",
            name: 'Apple',
            priceInKg: 120.0,
            ratting: 4.5,
            quantity: 3),
      );

      /// apple quantity is 4 * 120 = 480
      /// banana quantity is 1 * 80 = 80
      /// orange quantity is 1 * 120 = 120
      cartController.toPrint();
      expect(cartController.totalPrice(), 680.0);
    });

    test('Test total price of cart when no product is added', () {
      expect(cartController.products.isEmpty, true);
      expect(cartController.totalPrice(), 0.0);
    });

    test('Remove a product from the cart', () {
      expect(cartController.products.isEmpty, true);
      cartController.addProductToCart(apple);
      cartController.addProductToCart(banana);
      cartController.addProductToCart(orange);
      cartController.removeProductFromCart("apple");
      expect(cartController.products.length, 2);
    });

    test('Removing a non-existing product should not affect the cart', () {
      expect(cartController.products.isEmpty, true);
      cartController.addProductToCart(apple);
      cartController.addProductToCart(banana);
      cartController.removeProductFromCart("orange");
      expect(cartController.products.length, 2);
    });

    test('Decrease product quantity from cart', () {
      expect(cartController.products.isEmpty, true);
      cartController.addProductToCart(apple);
      cartController.addProductToCart(banana);
      cartController.addProductToCart(orange);
      cartController.addProductToCart(
        ProductModel(
            id: "apple",
            name: 'Apple',
            priceInKg: 120.0,
            ratting: 4.5,
            quantity: 3),
      );

      cartController.decreaseProductQuantityFromCart(apple);

      expect(cartController.products["apple"]?.quantity, 3);
      expect(cartController.products["banana"]?.quantity, 1);
      expect(cartController.products["orange"]?.quantity, 1);
    });

    test('Decrease product quantity to zero should remove it from cart', () {
      expect(cartController.products.isEmpty, true);
      cartController.addProductToCart(banana);
      cartController.addProductToCart(apple);

      cartController.decreaseProductQuantityFromCart(banana);

      expect(cartController.products.length, 1);
      expect(cartController.products.containsKey("banana"), false);
    });

    test(
        'Decrease product quantity of a non-existing product should do nothing',
        () {
      expect(cartController.products.isEmpty, true);
      cartController.decreaseProductQuantityFromCart(apple);
      expect(cartController.products.containsKey("apple"), false);
      expect(cartController.products.isEmpty, true);
    });

    /// tearDown will be called after each test is executed
    tearDown(() {
      cartController.cleanCart();
    });

    /// tearDownAll will be called after all tests are executed
    tearDownAll(() {});
  });
}
