import 'package:e_commerce_app/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get total => product.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

class Cart {
  final String buyerId;
  final Map<String, CartItem> items;

  Cart({
    required this.buyerId,
    Map<String, CartItem>? items,
  }) : items = items ?? {};

  void addItem(Product product) {
    if (items.containsKey(product.id)) {
      items[product.id]!.quantity++;
    } else {
      items[product.id] = CartItem(product: product);
    }
  }

  void removeItem(String productId) {
    items.remove(productId);
  }

  void decreaseQuantity(String productId) {
    if (items.containsKey(productId)) {
      if (items[productId]!.quantity > 1) {
        items[productId]!.quantity--;
      } else {
        items.remove(productId);
      }
    }
  }

  void clear() {
    items.clear();
  }

  double get totalAmount {
    double total = 0;
    items.forEach((key, item) {
      total += item.total;
    });
    return total;
  }

  int get itemCount {
    return items.length;
  }

  List<CartItem> get itemsList {
    return items.values.toList();
  }
} 