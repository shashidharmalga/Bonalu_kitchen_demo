import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final DateTime date;
  final String status; // 'Preparing', 'Ready', 'Delivered'

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.date,
    this.status = 'Preparing',
  });
}

class OrdersNotifier extends Notifier<List<Order>> {
  @override
  List<Order> build() {
    return [];
  }

  void addOrder(List<CartItem> items, double total) {
    final order = Order(
      id: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(items), // Make a copy
      totalAmount: total,
      date: DateTime.now(),
      status: 'Preparing',
    );
    state = [order, ...state];
  }
}

final ordersProvider = NotifierProvider<OrdersNotifier, List<Order>>(() {
  return OrdersNotifier();
});
