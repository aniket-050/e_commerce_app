import 'package:get/get.dart';
import 'package:e_commerce_app/models/user_model.dart';
import 'package:e_commerce_app/utils/dummy_data.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';

class UserController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxList<User> _allSellers = <User>[].obs;
  final RxList<User> _allBuyers = <User>[].obs;

  List<User> get allSellers => _allSellers;
  List<User> get allBuyers => _allBuyers;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  void loadUsers() {
    if (_authController.isAdmin) {
      // Use standard List first, then assign to the reactive list
      final sellers = DummyData.getSellers();
      final buyers = DummyData.getBuyers();

      // Update in the next frame to avoid setState during build
      Future.microtask(() {
        _allSellers.value = sellers;
        _allBuyers.value = buyers;
      });
    }
  }

  // Method to get user details by ID
  User? getUserById(String userId) {
    try {
      // First check in sellers
      final sellerIndex = _allSellers.indexWhere(
        (seller) => seller.id == userId,
      );
      if (sellerIndex != -1) {
        return _allSellers[sellerIndex];
      }

      // Then check in buyers
      final buyerIndex = _allBuyers.indexWhere((buyer) => buyer.id == userId);
      if (buyerIndex != -1) {
        return _allBuyers[buyerIndex];
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  // Method to get seller count (for admin dashboard)
  int get sellerCount => _allSellers.length;

  // Method to get buyer count (for admin dashboard)
  int get buyerCount => _allBuyers.length;

  // Method to get total user count
  int get totalUserCount => sellerCount + buyerCount;
}
