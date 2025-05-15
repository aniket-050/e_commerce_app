class User {
  final String id;
  final String username;
  final String email;
  final String password;
  final String role; // 'buyer', 'seller', or 'admin'
  final String? phone;
  final String? profileImageUrl;
  
  // Seller specific fields
  final String? businessName;
  final String? businessAddress;
  final String? businessCategory;
  final String? businessDescription;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.phone,
    this.profileImageUrl,
    this.businessName,
    this.businessAddress,
    this.businessCategory,
    this.businessDescription,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      phone: json['phone'],
      profileImageUrl: json['profileImageUrl'],
      businessName: json['businessName'],
      businessAddress: json['businessAddress'],
      businessCategory: json['businessCategory'],
      businessDescription: json['businessDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'businessCategory': businessCategory,
      'businessDescription': businessDescription,
    };
  }
} 