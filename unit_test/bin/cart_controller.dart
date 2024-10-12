void main() {
  final cart = CartController();

  // Adding products to the cart
  cart.addProductToCart(
    ProductModel(id: 'mango', name: 'Mango', priceInKg: 100, ratting: 5),
  );

  cart.addProductToCart(
    ProductModel(id: 'apple', name: 'Apple', priceInKg: 160, ratting: 5),
  );

  cart.addProductToCart(
    ProductModel(id: 'banana', name: 'Banana', priceInKg: 40, ratting: 4.2),
  );

  // Adding another mango product with a different price
  cart.addProductToCart(
    ProductModel(id: 'mango', name: 'Mango', priceInKg: 120, ratting: 5),
  );

  // Adding mango product with a specified quantity
  cart.addProductToCart(
    ProductModel(
        id: 'mango', name: 'Mango', priceInKg: 120, ratting: 5, quantity: 2),
  );

  // Decreasing the quantity of a mango product
  cart.decreaseProductQuantityFromCart(
    ProductModel(id: 'mango', name: 'Mango', priceInKg: 120, ratting: 4.2),
  );

  // Removing a mango product from the cart
  cart.removeProductFromCart('mango');

  // Printing the current state of the cart
  cart.toPrint();
  // Printing the total price of the cart
  print("===> Total price: ${cart.totalPrice()}");
}

class CartController {
  final products = <String, ProductModel>{};

  /// Prints all products in the cart
  void toPrint() {
    for (var key in products.keys) {
      products[key]!.toPrint();
    }
  }

  /// Adds a product to the cart, updating quantity if it already exists
  void addProductToCart(ProductModel model) {
    final isAlreadyInCart = products.containsKey(model.id);

    if (isAlreadyInCart) {
      final oldVersionOfProduct = products[model.id];
      if (oldVersionOfProduct == null) {
        print("====> Product not found in cart");
        return;
      }
      products[model.id] = oldVersionOfProduct.copyWith(
        quantity: oldVersionOfProduct.quantity + model.quantity,
        priceInKg: model.priceInKg,
        ratting: model.ratting,
      );
    } else {
      products[model.id] = model;
    }
  }

  /// Removes a product from the cart by its ID
  void removeProductFromCart(String productId) {
    final isAlreadyInCart = products.containsKey(productId);
    if (!isAlreadyInCart) {
      print("====> Product not found in cart");
    }
    products.remove(productId);
  }

  /// Decreases the quantity of a product in the cart
  void decreaseProductQuantityFromCart(ProductModel model) {
    final isAlreadyInCart = products.containsKey(model.id);
    if (!isAlreadyInCart) {
      print("====> Product not found in cart");
      return;
    }
    final product = products[model.id] as ProductModel;
    if (product.quantity <= 1) {
      print("====> Product remove from cart ");
      return removeProductFromCart(model.id);
    } else {
      final oldVersionOfProduct = products[model.id];
      if (oldVersionOfProduct == null) {
        print("====> Product not found in cart");
        return;
      }
      products[model.id] = oldVersionOfProduct.copyWith(
        quantity: oldVersionOfProduct.quantity - 1,
        priceInKg: model.priceInKg,
        ratting: model.ratting,
      );
    }
  }

  /// Returns the total price of all products in the cart
  double totalPrice() {
    try {
      if (products.isEmpty || products.values.isEmpty) {
        print("====> Cart is empty");
        return 0;
      }
      return products.values.fold(
        0,
        (sum, product) => sum + product.priceInKg * product.quantity,
      );
    } catch (e) {
      print("====> $e");
      return 0;
    }
  }

  /// clean the cart
  void cleanCart() {
    products.clear();
  }
}

///
/// [ProductModel]
///
class ProductModel {
  final String name;
  final String id;
  double priceInKg;
  double ratting;
  int quantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.priceInKg,
    required this.ratting,
    this.quantity = 1,
  });

  /// Creates a copy of the product with updated fields
  ProductModel copyWith({double? priceInKg, double? ratting, int? quantity}) {
    return ProductModel(
      id: id,
      name: name,
      priceInKg: priceInKg ?? this.priceInKg,
      ratting: ratting ?? this.ratting,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Prints the product details
  void toPrint() {
    print("===> $id | $name | $priceInKg | $ratting | $quantity");
  }
}
