import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/mock_data.dart';
import '../../shared/widgets/food_card.dart';
import '../../shared/widgets/category_chip.dart';
import '../../shared/widgets/category_tab.dart';
import '../../shared/widgets/item_detail_sheet.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String selectedCategory = 'Starters';
  final PageController _offersController = PageController(viewportFraction: 0.9);

  String _getEmojiForCategory(String category) {
    switch (category) {
      case 'Starters': return '🥙';
      case 'Biryani': return '🥘';
      case 'Main Course': return '🍛';
      case 'Rolls': return '🌯';
      case 'Chinese': return '🍜';
      case 'Desserts': return '🍰';
      case 'Beverages': return '🥤';
      default: return '🍔';
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularItems = MockData.foodItems.where((item) => item.category == selectedCategory).toList();
    final itemsToDisplay = popularItems.isNotEmpty ? popularItems : MockData.foodItems;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bonalu Kitchen',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 28,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Text(
                          'What would you like to eat today?',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/cart'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Badge(
                          label: Text(ref.watch(cartProvider).length.toString()),
                          isLabelVisible: ref.watch(cartProvider).isNotEmpty,
                          child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn().slideY(begin: -0.2),
              ),
              
              const SizedBox(height: 24),
              
              // Offers Carousel
              SizedBox(
                height: 80,
                child: PageView(
                  controller: _offersController,
                  padEnds: false,
                  children: [
                    _buildCouponCard(
                      context,
                      '10% off upto ₹75',
                      'USE VISAPLATINUMDC | ABOVE ₹300',
                      'VISA',
                      Colors.blue.shade900,
                    ),
                    _buildCouponCard(
                      context,
                      '20% off upto ₹100',
                      'USE MASTERCARD | ABOVE ₹500',
                      'MASTER',
                      Colors.orange.shade900,
                    ),
                    _buildCouponCard(
                      context,
                      'FREE DELIVERY',
                      'USE NEWUSER | ON FIRST ORDER',
                      'GIFT',
                      Theme.of(context).colorScheme.primary,
                    ),
                    _buildCouponCard(
                      context,
                      '₹50 CASHBACK',
                      'USE PAYTM50 | ABOVE ₹200',
                      'PAYTM',
                      Colors.lightBlue.shade800,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 32),
              
              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Explore by Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.categories.length,
                    itemBuilder: (context, index) {
                      final category = MockData.categories[index];
                      return SwiggyCategoryTab(
                        label: category,
                        emoji: _getEmojiForCategory(category),
                        isSelected: selectedCategory == category,
                        onTap: () => setState(() => selectedCategory = category),
                      );
                    },
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms),
              
              // Popular Now Grid mapped to active category
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(0), // flush with tabs
                    bottom: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular in $selectedCategory',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('See All'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Builder(
                      builder: (context) {
                        final showTwoRows = itemsToDisplay.length > 3;
                        final midPoint = showTwoRows ? (itemsToDisplay.length / 2).ceil() : itemsToDisplay.length;
                        final topRowItems = itemsToDisplay.take(midPoint).toList();
                        final bottomRowItems = showTwoRows ? itemsToDisplay.skip(midPoint).toList() : [];

                        return Column(
                          children: [
                            SizedBox(
                              height: 210, // Increased height for compact card to avoid overflow
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                itemCount: topRowItems.length,
                                itemBuilder: (context, index) {
                                  final item = topRowItems[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: SizedBox(
                                      width: 160,
                                      child: FoodCard(
                                        item: item,
                                        isCompact: true,
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            builder: (context) => ItemDetailSheet(item: item),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (bottomRowItems.isNotEmpty) const SizedBox(height: 16),
                            if (bottomRowItems.isNotEmpty)
                              SizedBox(
                                height: 210,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  itemCount: bottomRowItems.length,
                                  itemBuilder: (context, index) {
                                    final item = bottomRowItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: SizedBox(
                                        width: 160,
                                        child: FoodCard(
                                          item: item,
                                          isCompact: true,
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor: Colors.transparent,
                                              builder: (context) => ItemDetailSheet(item: item),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms).slideX(begin: 0.1),
              
              const SizedBox(height: 32),
              
              // Recommendation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Recommended For You',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final item = MockData.foodItems[(index * 2 + 1) % MockData.foodItems.length];
                  return _buildListTile(context, item);
                },
              ).animate().fadeIn(delay: 800.ms),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const SharedBottomNav(currentIndex: 0),
    );
  }

  Widget _buildCouponCard(BuildContext context, String title, String code, String badgeText, Color badgeColor) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  code,
                  style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, FoodItem item) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => ItemDetailSheet(item: item),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  item.category,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  '₹${item.price.toInt()}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final cartItems = ref.watch(cartProvider);
              final cartNotifier = ref.read(cartProvider.notifier);
              final cartItemIndex = cartItems.indexWhere((element) => element.foodItem.id == item.id);
              final isInCart = cartItemIndex != -1;
              final quantity = isInCart ? cartItems[cartItemIndex].quantity : 0;

              if (isInCart) {
                return Container(
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
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                      Text(
                        quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 16),
                        onPressed: () => cartNotifier.updateQuantity(item.id, quantity + 1),
                        color: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ],
                  ),
                );
              }

              return GestureDetector(
                onTap: () {
                  cartNotifier.addToCart(item);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              );
            },
          ),
        ],
      ),
    ),
    );
  }
}
