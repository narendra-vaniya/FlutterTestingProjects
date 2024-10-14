# Flutter Testing Project


The `unit_test/` project provides unit tests for various components, including `CartController`, `ProductsController`, and `ProductService`, ensuring each component behaves as expected.

## Project Structure

### Folders and Files

- **unit_test/**: Contains all unit testing files for the project.
  - **cart_controller.dart**: Implements the `CartController`, managing the shopping cart's products.
  - **product_controller.dart**: Implements the `ProductsController`, handling product-related operations and interactions with the `ProductService`.

- **unit_test/test/**:
  - **cart_controller_test.dart**: Tests for the `CartController`, verifying functionality such as adding, removing, and updating products in the cart.
  - **product_controller_test.dart**: Tests for the `ProductsController`, ensuring it correctly fetches products and categories.
  - **product_service_test.dart**: Tests for the `ProductService`, which interacts with an external API to fetch product data.
