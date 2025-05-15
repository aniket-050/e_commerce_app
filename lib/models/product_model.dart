class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  final String? imageUrl;
  final String category;
  final String sellerId;
  final String sellerName;
  final bool isActive;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    this.isActive = true,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      description: json['description'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 