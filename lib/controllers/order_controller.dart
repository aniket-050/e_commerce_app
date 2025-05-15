import 'package:get/get.dart';
import 'package:e_commerce_app/models/order_model.dart';
import 'package:e_commerce_app/utils/dummy_data.dart';
import 'package:e_commerce_app/controllers/auth_controller.dart';

class OrderController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxList<Order> _allOrders = <Order>[].obs;
  final RxList<Order> _userOrders =
      <Order>[].obs; // Buyer orders or seller orders

  List<Order> get allOrders => _allOrders;
  List<Order> get userOrders => _userOrders;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  void loadOrders() {
    // Prepare data before assigning to reactive variables
    List<Order> orders = [];
    List<Order> userSpecificOrders = [];

    // Load all orders for admin
    if (_authController.isAdmin) {
      orders = DummyData.orders;
    }

    // Load user-specific orders
    if (_authController.currentUser != null) {
      if (_authController.isBuyer) {
        userSpecificOrders = DummyData.getOrdersByBuyerId(
          _authController.currentUser!.id,
        );
      } else if (_authController.isSeller) {
        userSpecificOrders = DummyData.getOrdersBySellerId(
          _authController.currentUser!.id,
        );
      }
    }

    // Update in the next frame to avoid setState during build
    Future.microtask(() {
      _allOrders.value = orders;
      _userOrders.value = userSpecificOrders;
    });
  }

  // Method to get order details by ID
  Order? getOrderById(String orderId) {
    try {
      if (_authController.isAdmin) {
        return _allOrders.firstWhere((order) => order.id == orderId);
      } else {
        return _userOrders.firstWhere((order) => order.id == orderId);
      }
    } catch (e) {
      return null;
    }
  }

  // Method to update order status (for admin)
  Future<bool> updateOrderStatus(String orderId, String status) async {
    if (!_authController.isAdmin) {
      return false;
    }

    try {
      final index = _allOrders.indexWhere((order) => order.id == orderId);

      if (index != -1) {
        final updatedOrder = Order(
          id: _allOrders[index].id,
          buyerId: _allOrders[index].buyerId,
          buyerName: _allOrders[index].buyerName,
          items: _allOrders[index].items,
          totalAmount: _allOrders[index].totalAmount,
          status: status,
          createdAt: _allOrders[index].createdAt,
        );

        _allOrders[index] = updatedOrder;

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Method to get orders by status
  List<Order> getOrdersByStatus(String status) {
    if (_authController.isAdmin) {
      return _allOrders.where((order) => order.status == status).toList();
    } else {
      return _userOrders.where((order) => order.status == status).toList();
    }
  }

  // Method to calculate total sales for a seller
  double calculateTotalSales() {
    if (!_authController.isSeller || _authController.currentUser == null) {
      return 0.0;
    }

    double total = 0.0;

    for (final order in _userOrders) {
      for (final item in order.items) {
        if (item.sellerId == _authController.currentUser!.id) {
          total += item.price * item.quantity;
        }
      }
    }

    return total;
  }
}
