import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/models/product_model.dart';
import 'package:e_commerce_app/models/order_model.dart';

class DummyData {
  // Dummy Users
  static final List<User> users = [
    // Admin users
    User(
      id: 'admin1',
      username: 'admin',
      email: 'admin@shopeasy.com',
      password: 'admin123',
      role: 'admin',
      profileImageUrl: null,
    ),
    User(
      id: 'admin2',
      username: 'superadmin',
      email: 'superadmin@shopeasy.com',
      password: 'admin456',
      role: 'admin',
      profileImageUrl: null,
    ),

    // Seller users
    User(
      id: 'seller1',
      username: 'johndoe',
      email: 'john@example.com',
      password: 'seller123',
      role: 'seller',
      phone: '123-456-7890',
      profileImageUrl: null,
      businessName: 'John\'s Electronics',
      businessAddress: '123 Tech Street, Silicon Valley',
      businessCategory: 'Electronics',
      businessDescription: 'Quality electronics at affordable prices',
    ),
    User(
      id: 'seller2',
      username: 'janesmith',
      email: 'jane@example.com',
      password: 'seller123',
      role: 'seller',
      phone: '098-765-4321',
      profileImageUrl: null,
      businessName: 'Jane\'s Fashion',
      businessAddress: '456 Fashion Avenue, New York',
      businessCategory: 'Fashion',
      businessDescription: 'Trendy fashion items for all ages',
    ),
    User(
      id: 'seller3',
      username: 'mikebrown',
      email: 'mike@example.com',
      password: 'seller456',
      role: 'seller',
      phone: '555-987-6543',
      profileImageUrl: null,
      businessName: 'Mike\'s Home Decor',
      businessAddress: '789 Home Street, Chicago',
      businessCategory: 'Home & Decor',
      businessDescription:
          'Beautiful home decoration items at competitive prices',
    ),

    // Buyer users
    User(
      id: 'buyer1',
      username: 'buyer',
      email: 'buyer@example.com',
      password: 'buyer123',
      role: 'buyer',
      phone: '555-123-4567',
      profileImageUrl: null,
    ),
    User(
      id: 'buyer2',
      username: 'alice',
      email: 'alice@example.com',
      password: 'buyer456',
      role: 'buyer',
      phone: '555-789-1234',
      profileImageUrl: null,
    ),
    User(
      id: 'buyer3',
      username: 'bob',
      email: 'bob@example.com',
      password: 'buyer789',
      role: 'buyer',
      phone: '555-456-7890',
      profileImageUrl: null,
    ),
  ];

  // Dummy Products
  static final List<Product> products = [
    // Seller 1 Products (Electronics)
    Product(
      id: 'product1',
      name: 'Wireless Earbuds',
      price: 129.99,
      description:
          'High-quality wireless earbuds with noise cancellation. Features include touch controls, 30-hour battery life with charging case, and IPX7 waterproof rating.',
      imageUrl: 'assets/images/products/wireless_earbuds.jpeg',
      category: 'Electronics',
      sellerId: 'seller1',
      sellerName: 'John\'s Electronics',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Product(
      id: 'product2',
      name: 'Smart Watch',
      price: 199.99,
      description:
          'Modern smartwatch with health tracking features including heart rate monitoring, sleep tracking, and fitness activities. Compatible with both iOS and Android.',
      imageUrl: 'assets/images/products/smart_watch.jpeg',
      category: 'Electronics',
      sellerId: 'seller1',
      sellerName: 'John\'s Electronics',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
    ),
    Product(
      id: 'product3',
      name: 'Wireless Mouse',
      price: 39.99,
      description:
          'Ergonomic wireless mouse for comfortable use with adjustable DPI settings, silent clicking, and 18-month battery life.',
      imageUrl: 'assets/images/products/mouse_wireless.png',
      category: 'Electronics',
      sellerId: 'seller1',
      sellerName: 'John\'s Electronics',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    Product(
      id: 'product4',
      name: 'Laptop Stand',
      price: 49.99,
      description:
          'Adjustable laptop stand for better ergonomics with multiple height and angle settings. Foldable and portable design for easy storage and travel.',
      imageUrl: 'assets/images/products/study_table.png',
      category: 'Accessories',
      sellerId: 'seller1',
      sellerName: 'John\'s Electronics',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
    Product(
      id: 'product9',
      name: 'Bluetooth Speaker',
      price: 89.99,
      description:
          'Portable Bluetooth speaker with 24-hour battery life, waterproof design, and 360-degree sound.',
      imageUrl: 'assets/images/products/bt_speaker.png',
      category: 'Electronics',
      sellerId: 'seller1',
      sellerName: 'John\'s Electronics',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),

    // Seller 2 Products (Fashion)
    Product(
      id: 'product5',
      name: 'Premium Watch',
      price: 299.99,
      description:
          'Elegant premium watch for all occasions with genuine leather strap, sapphire crystal, and Japanese movement.',
      imageUrl: 'assets/images/products/watch.png',
      category: 'Fashion',
      sellerId: 'seller2',
      sellerName: 'Jane\'s Fashion',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Product(
      id: 'product6',
      name: 'Sport Shoes',
      price: 89.99,
      description:
          'Comfortable sport shoes for running and exercise with cushioned soles and breathable material.',
      imageUrl: 'assets/images/products/shoes.png',
      category: 'Fashion',
      sellerId: 'seller2',
      sellerName: 'Jane\'s Fashion',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Product(
      id: 'product10',
      name: 'Designer Handbag',
      price: 149.99,
      description:
          'Stylish designer handbag with multiple compartments, adjustable strap, and premium vegan leather.',
      imageUrl: 'assets/images/products/bag.png',
      category: 'Fashion',
      sellerId: 'seller2',
      sellerName: 'Jane\'s Fashion',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Product(
      id: 'product11',
      name: 'Summer Dress',
      price: 59.99,
      description:
          'Light and comfortable summer dress with floral pattern, perfect for beach or casual outings.',
      imageUrl: 'assets/images/products/dress.png',
      category: 'Fashion',
      sellerId: 'seller2',
      sellerName: 'Jane\'s Fashion',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // Seller 3 Products (Home & Decor)
    Product(
      id: 'product7',
      name: 'Premium Headphones',
      price: 199.99,
      description:
          'High-quality over-ear headphones with noise cancellation, premium sound quality, and comfortable design for extended wear.',
      imageUrl: 'assets/images/products/premium_headphones.png',
      category: 'Electronics',
      sellerId: 'seller3',
      sellerName: 'Mike\'s Electronics',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 12)),
    ),
    Product(
      id: 'product8',
      name: 'Decorative Throw Pillows',
      price: 45.99,
      description:
          'Set of 2 decorative throw pillows with removable covers. Various patterns available.',
      imageUrl: 'assets/images/products/Decorative_Throw_Pillows.png',
      category: 'Home & Decor',
      sellerId: 'seller3',
      sellerName: 'Mike\'s Home Decor',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 9)),
    ),
    Product(
      id: 'product12',
      name: 'Wall Art Canvas',
      price: 79.99,
      description:
          'Beautiful wall art canvas painting, perfect for living room or bedroom decor. Available in multiple designs.',
      imageUrl: 'assets/images/products/Wall_Art_Canvas.png',
      category: 'Home & Decor',
      sellerId: 'seller3',
      sellerName: 'Mike\'s Home Decor',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    // Add additional products using new images
    Product(
      id: 'product13',
      name: 'Wireless Technology',
      price: 129.99,
      description:
          'Latest wireless technology accessories for your smart home and personal use.',
      imageUrl: 'assets/images/products/pngegg (3).png',
      category: 'Electronics',
      sellerId: 'seller1',
      sellerName: 'John\'s Electronics',
      isActive: true,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  // Dummy Orders
  static final List<Order> orders = [
    Order(
      id: 'order1',
      buyerId: 'buyer1',
      buyerName: 'Buyer User',
      items: [
        OrderItem(
          productId: 'product1',
          productName: 'Wireless Earbuds',
          price: 129.99,
          quantity: 1,
          sellerId: 'seller1',
        ),
        OrderItem(
          productId: 'product2',
          productName: 'Smart Watch',
          price: 199.99,
          quantity: 1,
          sellerId: 'seller1',
        ),
      ],
      totalAmount: 329.98,
      status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
    ),
    Order(
      id: 'order2',
      buyerId: 'buyer1',
      buyerName: 'Buyer User',
      items: [
        OrderItem(
          productId: 'product5',
          productName: 'Premium Watch',
          price: 299.99,
          quantity: 1,
          sellerId: 'seller2',
        ),
      ],
      totalAmount: 299.99,
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Order(
      id: 'order3',
      buyerId: 'buyer2',
      buyerName: 'Alice',
      items: [
        OrderItem(
          productId: 'product6',
          productName: 'Sport Shoes',
          price: 89.99,
          quantity: 1,
          sellerId: 'seller2',
        ),
        OrderItem(
          productId: 'product10',
          productName: 'Designer Handbag',
          price: 149.99,
          quantity: 1,
          sellerId: 'seller2',
        ),
      ],
      totalAmount: 239.98,
      status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Order(
      id: 'order4',
      buyerId: 'buyer3',
      buyerName: 'Bob',
      items: [
        OrderItem(
          productId: 'product7',
          productName: 'Scented Candle Set',
          price: 34.99,
          quantity: 2,
          sellerId: 'seller3',
        ),
        OrderItem(
          productId: 'product8',
          productName: 'Decorative Throw Pillows',
          price: 45.99,
          quantity: 1,
          sellerId: 'seller3',
        ),
      ],
      totalAmount: 115.97,
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Method to get user by credentials
  static User? getUserByCredentials(String username, String password) {
    try {
      print("Searching for user with username/email: $username");

      // First, try to find by exact match (case-sensitive)
      var user = users.firstWhere(
        (user) =>
            (user.username == username || user.email == username) &&
            user.password == password,
        orElse:
            () => User(id: '', username: '', email: '', password: '', role: ''),
      );

      // If not found, try case-insensitive match
      if (user.id.isEmpty) {
        print("No exact match found, trying case-insensitive match");
        user = users.firstWhere(
          (user) =>
              (user.username.toLowerCase() == username.toLowerCase() ||
                  user.email.toLowerCase() == username.toLowerCase()) &&
              user.password == password,
          orElse:
              () =>
                  User(id: '', username: '', email: '', password: '', role: ''),
        );
      }

      if (user.id.isNotEmpty) {
        print("Found user: ${user.username}, Role: ${user.role}");
        return user;
      }

      print("No user found with these credentials");
      return null;
    } catch (e) {
      print("Error in getUserByCredentials: $e");
      return null;
    }
  }

  // Method to get user by username or email
  static User? getUserByUsernameOrEmail(String username, String email) {
    try {
      return users.firstWhere(
        (user) => user.username == username || user.email == email,
      );
    } catch (e) {
      return null;
    }
  }

  // Method to add a new user
  static void addUser(User user) {
    users.add(user);
  }

  // Method to get products by seller ID
  static List<Product> getProductsBySellerId(String sellerId) {
    return products.where((product) => product.sellerId == sellerId).toList();
  }

  // Method to get orders by buyer ID
  static List<Order> getOrdersByBuyerId(String buyerId) {
    return orders.where((order) => order.buyerId == buyerId).toList();
  }

  // Method to get orders by seller ID
  static List<Order> getOrdersBySellerId(String sellerId) {
    return orders
        .where((order) => order.items.any((item) => item.sellerId == sellerId))
        .toList();
  }

  // Method to get sellers
  static List<User> getSellers() {
    return users.where((user) => user.role == 'seller').toList();
  }

  // Method to get buyers
  static List<User> getBuyers() {
    return users.where((user) => user.role == 'buyer').toList();
  }
}
