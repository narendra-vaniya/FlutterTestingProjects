# Cart Controller

This `CartController` class implements a simple ways for managing products in a shopping cart. It allows adding, removing, and updating product quantities, as well as calculating the total price of the cart.

## Basic Use Case

Here is a code snippet demonstrating basic usage of the `CartController`:

```dart
void main() {
  final cart = CartController();

  // Adding products to the cart
  cart.addProductToCart(ProductModel(id: 'mango', name: 'Mango', priceInKg: 100, ratting: 5));
  cart.addProductToCart(ProductModel(id: 'apple', name: 'Apple', priceInKg: 160, ratting: 5));

  // Decreasing the quantity of a product
  cart.decreaseProductQuantityFromCart(ProductModel(id: 'mango', name: 'Mango', priceInKg: 100, ratting: 5));

  // Removing a product from the cart
  cart.removeProductFromCart('apple');

  // Printing the current state of the cart
  cart.toPrint();
  print("===> Total price: ${cart.totalPrice()}");
}
```



----
# ProductsController 

## Overview
The `ProductsController` class is responsible for managing product-related operations in the application. It interacts with the `ProductService` to fetch products and categories from an external API and provides methods to access and manipulate this data.

## Basic Usage
To use the `ProductsController`, instantiate it with a `ProductService` and call the relevant methods to fetch and manage product data.

```dart
// Import necessary packages
import 'package:http/http.dart' as http;

// Create an instance of ProductService
final productService = ProductService(http.Client());

// Instantiate the ProductsController
final productsController = ProductsController(productService);

// Fetch products and categories
await productsController.getProducts();
await productsController.getCategories();

// Print the count of products and categories
productsController.toPrint();
```

