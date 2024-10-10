# Unit Testing

## Cart Controller

### Description

The `CartController` class is designed to manage a shopping cart. It allows users to add products to the cart, remove products, and adjust the quantity of products. The cart also calculates the total price of the products. The `CartController` does not contain any API calls and serves as a row controller for managing the cart.

### Usage

To use the `CartController` class, you need to import the `cart_controller.dart` file into your project.

```dart
import 'cart_controller.dart';

void main() {
  final cart = CartController();

  // Adding products to the cart
  cart.addProductToCart(
    ProductModel(id: 'mango', name: 'Mango', priceInKg: 100, ratting: 5),
  );

// Adding another banana product
 cart.addProductToCart(
    ProductModel(id: 'banana', name: 'Banana', priceInKg: 40, ratting: 4.2),
  );

  // Adding another mango product with a different price
  cart.addProductToCart(
    ProductModel(id: 'mango', name: 'Mango', priceInKg: 120, ratting: 5),
  );

  // Adding mango product with a specified  quantity
  cart.addProductToCart(
    ProductModel(id: 'mango', name: 'Mango', priceInKg: 120, ratting: 5, quantity: 2),

  // Printing the total price of the cart
  print("===> Total price: ${cart.totalPrice()}");

}
```
