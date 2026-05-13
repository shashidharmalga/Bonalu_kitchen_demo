import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/mock_data.dart';
import '../providers/cart_provider.dart';
import 'package:shimmer/shimmer.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;
  final bool isCompact;

  const FoodCard({
    super.key,
    required this.item,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).cardTheme.shadowColor ?? Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: item.imageUrl,
                    height: isCompact ? 100 : 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[800]!,
                      highlightColor: Colors.grey[700]!,
                      child: Container(color: Colors.white, height: isCompact ? 100 : 140),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item.rating.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: item.isVeg ? Colors.green : Colors.red, width: 2),
                      ),
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: item.isVeg ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content Section
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: isCompact ? 14 : 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.prepTime,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.price.toInt()}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: isCompact ? 14 : null,
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
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 32),
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
                                    constraints: const BoxConstraints(minWidth: 32),
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
                              padding: EdgeInsets.symmetric(
                                horizontal: isCompact ? 12 : 16, 
                                vertical: isCompact ? 6 : 8
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                              ),
                              child: Text(
                                'ADD',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isCompact ? 12 : 14,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
