import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';

class SharedBottomNav extends ConsumerWidget {
  final int currentIndex;

  const SharedBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsCount = ref.watch(cartProvider).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, Icons.home_rounded, currentIndex == 0, () => context.go('/home')),
          _buildNavItem(context, Icons.restaurant_menu_rounded, currentIndex == 1, () => context.go('/menu')),
          _buildCartNavItem(context, currentIndex == 2, () => context.push('/cart'), cartItemsCount),
          _buildNavItem(context, Icons.person_rounded, currentIndex == 3, () => context.push('/profile')),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white38,
          size: isSelected ? 32 : 28,
        ),
      ),
    );
  }

  Widget _buildCartNavItem(BuildContext context, bool isSelected, VoidCallback onTap, int itemCount) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8.0),
        child: Badge(
          label: Text(itemCount.toString()),
          isLabelVisible: itemCount > 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.shopping_cart_rounded,
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.white38,
            size: isSelected ? 32 : 28,
          ),
        ),
      ),
    );
  }
}
