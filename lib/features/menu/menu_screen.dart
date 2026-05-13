import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/mock_data.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/widgets/category_tab.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String selectedCategory = 'All';
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getEmojiForCategory(String category) {
    if (category == 'All') return '🍽️';
    switch (category) {
      case 'Starters': return '🥙';
      case 'Biryani': return '🥘';
      case 'Main Course': return '🍛';
      case 'Rolls': return '🌯';
      case 'Chinese': return '🍜';
      case 'Desserts': return '🍰';
      case 'Cakes': return '🎂';
      case 'Ice Creams': return '🍨';
      case 'Beverages': return '🥤';
      default: return '🍔';
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['All', ...MockData.categories];
    
    final categoryItems = selectedCategory == 'All'
        ? MockData.foodItems
        : MockData.foodItems.where((item) => item.category == selectedCategory).toList();
        
    final filteredItems = searchQuery.isEmpty 
        ? categoryItems 
        : categoryItems.where((item) => item.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Text(
                'Our Menu',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ).animate().fadeIn().slideX(begin: -0.2),
            ),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search for dishes...',
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                    suffixIcon: searchQuery.isNotEmpty 
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms),
            
            const SizedBox(height: 20),
            
            // Categories
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return SwiggyCategoryTab(
                    label: category,
                    emoji: _getEmojiForCategory(category),
                    isSelected: selectedCategory == category,
                    onTap: () => setState(() => selectedCategory = category),
                  );
                },
              ),
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 20),
            
            // Food Items Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return _buildMenuItem(context, item, ref).animate().fadeIn(delay: Duration(milliseconds: 300 + (index * 50))).slideY(begin: 0.1);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 1),
    );
  }

  Widget _buildMenuItem(BuildContext context, FoodItem item, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    
    // Check if item is in cart
    final cartItemIndex = cartItems.indexWhere((element) => element.foodItem.id == item.id);
    final isInCart = cartItemIndex != -1;
    final quantity = isInCart ? cartItems[cartItemIndex].quantity : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardTheme.shadowColor ?? Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₹${item.price.toInt()}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              // Inline Cart Controls
              isInCart 
              ? Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 16),
                        onPressed: () => cartNotifier.updateQuantity(item.id, quantity - 1),
                        color: Theme.of(context).colorScheme.primary,
                        constraints: const BoxConstraints(minWidth: 32),
                        padding: EdgeInsets.zero,
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () => cartNotifier.updateQuantity(item.id, quantity + 1),
                        color: Theme.of(context).colorScheme.primary,
                        constraints: const BoxConstraints(minWidth: 32),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    cartNotifier.addToCart(item);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                    ),
                    child: Text('ADD', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.primary)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
