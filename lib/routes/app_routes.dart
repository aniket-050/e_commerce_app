class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String sellerRegistration = '/seller-registration';
  static const String adminRegistration = '/admin-registration';
  static const String sellerProfileCompletion = '/seller-profile-completion';

  // Buyer Routes
  static const String buyerHome = '/buyer/home';
  static const String search = '/buyer/search';
  static const String productDetails = '/buyer/product-details';
  static const String cart = '/buyer/cart';
  static const String checkout = '/buyer/checkout';
  static const String orderSuccess = '/buyer/order-success';
  static const String buyerOrders = '/buyer/orders';
  static const String buyerOrderDetails = '/buyer/order-details';
  static const String buyerProfile = '/buyer/profile';
  // New Buyer Routes
  static const String editProfile = '/buyer/edit-profile';
  static const String shippingAddresses = '/buyer/shipping-addresses';
  static const String paymentMethods = '/buyer/payment-methods';
  static const String buyerNotifications = '/buyer/notifications';
  static const String language = '/buyer/language';
  static const String darkMode = '/buyer/dark-mode';
  static const String buyerHelpSupport = '/buyer/help-support';
  static const String privacyPolicy = '/buyer/privacy-policy';

  // Seller Routes
  static const String sellerDashboard = '/seller/dashboard';
  static const String sellerProducts = '/seller/products';
  static const String addProduct = '/seller/add-product';
  static const String editProduct = '/seller/edit-product';
  static const String sellerOrders = '/seller/orders';
  static const String sellerOrderDetails = '/seller/order-details';
  static const String sellerProfile = '/seller/profile';
  static const String businessProfile = '/seller/business-profile';
  static const String notifications = '/seller/notifications';
  static const String paymentSettings = '/seller/payment-settings';
  static const String accountSecurity = '/seller/account-security';
  static const String helpSupport = '/seller/help-support';

  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminSellers = '/admin/sellers';
  static const String adminSellerDetails = '/admin/seller-details';
  static const String adminBuyers = '/admin/buyers';
  static const String adminBuyerDetails = '/admin/buyer-details';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String adminOrderDetails = '/admin/order-details';
}
