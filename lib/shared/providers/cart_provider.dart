import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/mock_data.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({required this.foodItem, this.quantity = 1});
}

class CartNotifier extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() {
    return [];
  }

  void addToCart(FoodItem item) {
    final existingIndex = state.indexWhere((element) => element.foodItem.id == item.id);
    if (existingIndex != -1) {
      state[existingIndex].quantity++;
      state = [...state];
    } else {
      state = [...state, CartItem(foodItem: item)];
    }
  }

  void removeFromCart(String itemId) {
    state = state.where((element) => element.foodItem.id != itemId).toList();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(itemId);
      return;
    }
    state = [
      for (final item in state)
        if (item.foodItem.id == itemId)
          CartItem(foodItem: item.foodItem, quantity: quantity)
        else
          item
    ];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + (item.foodItem.price * item.quantity));
  double get gst => subtotal * 0.05; // 5% GST
  double get discount => subtotal > 500 ? 50.0 : 0.0; // Mock discount
  double get total => subtotal + gst - discount;
  
  void clear() => state = [];
}

final cartProvider = NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
