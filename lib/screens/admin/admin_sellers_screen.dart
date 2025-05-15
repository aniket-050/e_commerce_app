import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_app/controllers/user_controller.dart';
import 'package:e_commerce_app/routes/app_routes.dart';
import 'package:e_commerce_app/utils/app_theme.dart';
import 'package:e_commerce_app/widgets/custom_app_bar.dart';

class AdminSellersScreen extends StatefulWidget {
  const AdminSellersScreen({super.key});

  @override
  State<AdminSellersScreen> createState() => _AdminSellersScreenState();
}

class _AdminSellersScreenState extends State<AdminSellersScreen> {
  final UserController _userController = Get.find<UserController>();
  final TextEditingController _searchController = TextEditingController();

  final RxList<RxString> filteredSellers = <RxString>[].obs;
  final RxBool isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    // This will be called through a Future.microtask to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _userController.loadUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sellers',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              isSearching.value = !isSearching.value;
              if (!isSearching.value) {
                _searchController.clear();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Obx(() {
            return isSearching.value
                ? Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search sellers...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      // In a real app, implement search functionality
                    },
                  ),
                )
                : const SizedBox.shrink();
          }),

          // Sellers List
          Expanded(
            child: Obx(() {
              final sellers = _userController.allSellers;

              if (sellers.isEmpty) {
                return const Center(child: Text('No sellers found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: sellers.length,
                itemBuilder: (context, index) {
                  final seller = sellers[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Seller Profile Image
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: _getAvatarColor(
                                  seller.username,
                                ),
                                child:
                                    seller.profileImageUrl != null
                                        ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          child: Image.asset(
                                            seller.profileImageUrl!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return _buildUserInitials(
                                                seller.username,
                                              );
                                            },
                                          ),
                                        )
                                        : _buildUserInitials(seller.username),
                              ),
                              const SizedBox(width: 16),

                              // Seller Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      seller.businessName ?? seller.username,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      seller.email,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      seller.phone ?? 'No phone provided',
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),

                          // Business Info
                          Row(
                            children: [
                              _buildInfoItem(
                                Icons.category,
                                'Category',
                                seller.businessCategory ?? 'N/A',
                              ),
                              const SizedBox(width: 16),
                              _buildInfoItem(
                                Icons.location_on,
                                'Location',
                                seller.businessAddress ?? 'N/A',
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // View Seller Button
                              OutlinedButton.icon(
                                onPressed: () {
                                  Get.toNamed(
                                    AppRoutes.adminSellerDetails,
                                    arguments: seller,
                                  );
                                },
                                icon: const Icon(Icons.visibility),
                                label: const Text('View Details'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Helper method to get user initials for avatar
  Widget _buildUserInitials(String username) {
    final initials =
        username.isNotEmpty ? username.substring(0, 1).toUpperCase() : '?';

    return Text(
      initials,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  // Helper method to get consistent avatar color based on username
  Color _getAvatarColor(String username) {
    // Generate a color based on the username to keep it consistent for the same user
    final colorIndex = username.codeUnits.fold<int>(
      0,
      (prev, element) => prev + element,
    );

    // List of avatar colors
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    return colors[colorIndex % colors.length];
  }

  Widget _buildInfoItem(IconData icon, String title, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
