class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final String prepTime;
  final bool isVeg;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.prepTime,
    required this.isVeg,
  });
}

class MockData {
  static final List<String> categories = [
    'Starters',
    'Biryani',
    'Main Course',
    'Beverages',
    'Desserts'
  ];

  static final List<FoodItem> foodItems = [
    FoodItem(
      id: '1',
      name: 'Special Chicken Biryani',
      description: 'Slow-cooked aromatic basmati rice with tender chicken and authentic spices.',
      price: 350.0,
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21bc4a4f8?q=80&w=800&auto=format&fit=crop',
      category: 'Biryani',
      rating: 4.8,
      prepTime: '25 min',
      isVeg: false,
    ),
    FoodItem(
      id: '2',
      name: 'Paneer Butter Masala',
      description: 'Rich and creamy tomato-based gravy with soft paneer cubes.',
      price: 280.0,
      imageUrl: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?q=80&w=800&auto=format&fit=crop',
      category: 'Main Course',
      rating: 4.5,
      prepTime: '20 min',
      isVeg: true,
    ),
    FoodItem(
      id: '3',
      name: 'Chicken 65',
      description: 'Spicy, deep-fried chicken pieces with curry leaves and green chilies.',
      price: 220.0,
      imageUrl: 'https://images.unsplash.com/photo-1610057099443-fde8c4d50f91?q=80&w=800&auto=format&fit=crop',
      category: 'Starters',
      rating: 4.7,
      prepTime: '15 min',
      isVeg: false,
    ),
    FoodItem(
      id: '4',
      name: 'Gulab Jamun',
      description: 'Soft milk solids dumplings dipped in cardamom-flavored sugar syrup.',
      price: 120.0,
      imageUrl: 'https://images.unsplash.com/photo-1589119908995-c6837fa14848?q=80&w=800&auto=format&fit=crop',
      category: 'Desserts',
      rating: 4.9,
      prepTime: '10 min',
      isVeg: true,
    ),
  ];
}
