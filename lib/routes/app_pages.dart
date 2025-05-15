import 'package:e_commerce_app/screens/buyer/buyer_order_details_screen.dart';
import 'package:e_commerce_app/screens/buyer/buyer_orders_screen.dart';
import 'package:e_commerce_app/screens/buyer/buyer_profile_screen.dart';
import 'package:e_commerce_app/screens/buyer/edit_profile_screen.dart';
import 'package:e_commerce_app/screens/buyer/shipping_addresses_screen.dart';
import 'package:e_commerce_app/screens/buyer/payment_methods_screen.dart';
import 'package:e_commerce_app/screens/buyer/notifications_screen.dart'
    as buyer;
import 'package:e_commerce_app/screens/buyer/language_screen.dart';
import 'package:e_commerce_app/screens/buyer/help_support_screen.dart' as buyer;
import 'package:e_commerce_app/screens/buyer/privacy_policy_screen.dart';
import 'package:e_commerce_app/screens/buyer/search_screen.dart';
import 'package:e_commerce_app/screens/seller/seller_order_details_screen.dart';
import 'package:e_commerce_app/screens/seller/seller_orders_screen.dart';
import 'package:e_commerce_app/screens/seller/seller_profile_screen.dart';
import 'package:e_commerce_app/screens/seller/business_profile_screen.dart';
import 'package:e_commerce_app/screens/seller/notifications_screen.dart';
import 'package:e_commerce_app/screens/seller/payment_settings_screen.dart';
import 'package:e_commerce_app/screens/seller/account_security_screen.dart';
import 'package:e_commerce_app/screens/seller/help_support_screen.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/routes/app_routes.dart';

// Auth Screens
import 'package:e_commerce_app/screens/auth/splash_screen.dart';
import 'package:e_commerce_app/screens/auth/login_screen.dart';
import 'package:e_commerce_app/screens/auth/buyer_registration_screen.dart';
import 'package:e_commerce_app/screens/auth/admin_registration_screen.dart';
import 'package:e_commerce_app/screens/auth/seller_registration_screen.dart';
import 'package:e_commerce_app/screens/auth/seller_profile_completion_screen.dart';

// Buyer Screens
import 'package:e_commerce_app/screens/buyer/buyer_home_screen.dart';
import 'package:e_commerce_app/screens/buyer/product_details_screen.dart';
import 'package:e_commerce_app/screens/buyer/cart_screen.dart';
import 'package:e_commerce_app/screens/buyer/checkout_screen.dart';
import 'package:e_commerce_app/screens/buyer/order_success_screen.dart';

// Seller Screens
import 'package:e_commerce_app/screens/seller/seller_dashboard_screen.dart';
import 'package:e_commerce_app/screens/seller/seller_products_screen.dart';
import 'package:e_commerce_app/screens/seller/add_product_screen.dart';
import 'package:e_commerce_app/screens/seller/edit_product_screen.dart';

// Admin Screens
import 'package:e_commerce_app/screens/admin/admin_dashboard_screen.dart';
import 'package:e_commerce_app/screens/admin/admin_sellers_screen.dart';
import 'package:e_commerce_app/screens/admin/admin_seller_details_screen.dart';
import 'package:e_commerce_app/screens/admin/admin_buyers_screen.dart';
import 'package:e_commerce_app/screens/admin/admin_buyer_details_screen.dart';
import 'package:e_commerce_app/screens/admin/admin_products_screen.dart';
import 'package:e_commerce_app/screens/admin/admin_orders_screen.dart';
import 'package:e_commerce_app/screens/admin/admin_order_details_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    // Auth Routes
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(
      name: AppRoutes.register,
      page: () => const BuyerRegistrationScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerRegistration,
      page: () => const SellerRegistrationScreen(),
    ),
    GetPage(
      name: AppRoutes.adminRegistration,
      page: () => const AdminRegistrationScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerProfileCompletion,
      page: () => const SellerProfileCompletionScreen(),
    ),

    // Buyer Routes
    GetPage(name: AppRoutes.buyerHome, page: () => const BuyerHomeScreen()),
    GetPage(name: AppRoutes.search, page: () => const SearchScreen()),
    GetPage(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsScreen(),
    ),
    GetPage(name: AppRoutes.cart, page: () => const CartScreen()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessScreen(),
    ),
    GetPage(name: AppRoutes.buyerOrders, page: () => const BuyerOrdersScreen()),
    GetPage(
      name: AppRoutes.buyerOrderDetails,
      page: () => const BuyerOrderDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.buyerProfile,
      page: () => const BuyerProfileScreen(),
    ),
    // New Buyer Routes
    GetPage(name: AppRoutes.editProfile, page: () => const EditProfileScreen()),
    GetPage(
      name: AppRoutes.shippingAddresses,
      page: () => const ShippingAddressesScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentMethods,
      page: () => const PaymentMethodsScreen(),
    ),
    GetPage(
      name: AppRoutes.buyerNotifications,
      page: () => const buyer.NotificationsScreen(),
    ),
    GetPage(name: AppRoutes.language, page: () => const LanguageScreen()),
    GetPage(
      name: AppRoutes.buyerHelpSupport,
      page: () => const buyer.HelpSupportScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
    ),

    // Seller Routes
    GetPage(
      name: AppRoutes.sellerDashboard,
      page: () => const SellerDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerProducts,
      page: () => const SellerProductsScreen(),
    ),
    GetPage(name: AppRoutes.addProduct, page: () => const AddProductScreen()),
    GetPage(name: AppRoutes.editProduct, page: () => const EditProductScreen()),
    GetPage(
      name: AppRoutes.sellerOrders,
      page: () => const SellerOrdersScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerOrderDetails,
      page: () => const SellerOrderDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerProfile,
      page: () => const SellerProfileScreen(),
    ),
    // New Seller Routes
    GetPage(
      name: AppRoutes.businessProfile,
      page: () => const BusinessProfileScreen(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.paymentSettings,
      page: () => const PaymentSettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.accountSecurity,
      page: () => const AccountSecurityScreen(),
    ),
    GetPage(name: AppRoutes.helpSupport, page: () => const HelpSupportScreen()),

    // Admin Routes
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.adminSellers,
      page: () => const AdminSellersScreen(),
    ),
    GetPage(
      name: AppRoutes.adminSellerDetails,
      page: () => const AdminSellerDetailsScreen(),
    ),
    GetPage(name: AppRoutes.adminBuyers, page: () => const AdminBuyersScreen()),
    GetPage(
      name: AppRoutes.adminBuyerDetails,
      page: () => const AdminBuyerDetailsScreen(),
    ),
    GetPage(
      name: AppRoutes.adminProducts,
      page: () => const AdminProductsScreen(),
    ),
    GetPage(name: AppRoutes.adminOrders, page: () => const AdminOrdersScreen()),
    GetPage(
      name: AppRoutes.adminOrderDetails,
      page: () => const AdminOrderDetailsScreen(),
    ),
  ];
}
