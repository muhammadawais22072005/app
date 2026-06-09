import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final Product product;
  final String size; // Small, Medium, Large
  final String milk; // Whole, Oat, Almond
  final bool hasExtraShot;
  final bool hasWhippedCream;
  final bool hasCaramelDrizzle;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    required this.milk,
    required this.hasExtraShot,
    required this.hasWhippedCream,
    required this.hasCaramelDrizzle,
    this.quantity = 1,
  });

  double get unitPrice {
    double price = product.basePrice;
    if (size == 'Medium') price += 0.50;
    if (size == 'Large') price += 1.00;
    if (hasExtraShot) price += 1.00;
    if (milk == 'Oat' || milk == 'Almond') price += 0.50;
    if (hasCaramelDrizzle) price += 0.50;
    return price;
  }

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({
    Product? product,
    String? size,
    String? milk,
    bool? hasExtraShot,
    bool? hasWhippedCream,
    bool? hasCaramelDrizzle,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      size: size ?? this.size,
      milk: milk ?? this.milk,
      hasExtraShot: hasExtraShot ?? this.hasExtraShot,
      hasWhippedCream: hasWhippedCream ?? this.hasWhippedCream,
      hasCaramelDrizzle: hasCaramelDrizzle ?? this.hasCaramelDrizzle,
      quantity: quantity ?? this.quantity,
    );
  }
}

class UserModel {
  final String name;
  final String email;
  final String password;
  final String role; // 'user' or 'admin'
  int loyaltyPoints;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.loyaltyPoints = 450,
  });
}

class CoffeeOrder {
  final String id;
  final String customerEmail;
  final List<CartItem> items;
  final double total;
  String status; // 'Pending', 'Brewing', 'Completed', 'Cancelled'
  final DateTime timestamp;
  
  // Delivery details
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;

  CoffeeOrder({
    required this.id,
    required this.customerEmail,
    required this.items,
    required this.total,
    required this.status,
    required this.timestamp,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryAddress,
  });
}

class CartState with ChangeNotifier {
  final List<CartItem> _items = [];
  final Set<String> _favorites = {'classic_espresso', 'cappuccino'};
  
  // Dynamic lists for products, users and orders
  late final List<Product> _products;
  final List<UserModel> _users = [
    UserModel(name: 'Admin User', email: 'admin@caffeine.com', password: 'admin123', role: 'admin'),
    UserModel(name: 'Alex Rivers', email: 'alex@gmail.com', password: 'alex123', role: 'user', loyaltyPoints: 450),
  ];
  final List<CoffeeOrder> _orders = [];
  
  UserModel? _currentUser;
  
  CartState() {
    _products = List.from(Product.mockProducts);
  }

  // Getters
  List<CartItem> get items => List.unmodifiable(_items);
  Set<String> get favorites => _favorites;
  List<Product> get products => _products;
  List<UserModel> get registeredUsers => _users;
  List<CoffeeOrder> get orders => _orders;
  UserModel? get currentUser => _currentUser;
  
  int get loyaltyPoints => _currentUser?.loyaltyPoints ?? 0;
  int get cartCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => _items.isEmpty ? 0.0 : 1.50;
  double get tax => subtotal * 0.08;
  double get total => subtotal + deliveryFee + tax;

  // Authentication methods
  bool login(String email, String password, String role) {
    for (var u in _users) {
      if (u.email.toLowerCase() == email.toLowerCase() && 
          u.password == password && 
          u.role == role) {
        _currentUser = u;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  bool signup(String name, String email, String password, String role) {
    // Check if email already registered
    if (_users.any((u) => u.email.toLowerCase() == email.toLowerCase())) {
      return false;
    }
    final newUser = UserModel(
      name: name,
      email: email,
      password: password,
      role: role,
      loyaltyPoints: role == 'user' ? 100 : 0, // 100 points welcome bonus for customers
    );
    _users.add(newUser);
    _currentUser = newUser;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    _items.clear();
    notifyListeners();
  }

  // Cart Management
  void addToCart(CartItem item) {
    for (var existing in _items) {
      if (existing.product.id == item.product.id &&
          existing.size == item.size &&
          existing.milk == item.milk &&
          existing.hasExtraShot == item.hasExtraShot &&
          existing.hasWhippedCream == item.hasWhippedCream &&
          existing.hasCaramelDrizzle == item.hasCaramelDrizzle) {
        existing.quantity += item.quantity;
        notifyListeners();
        return;
      }
    }
    _items.add(item);
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    notifyListeners();
  }

  // Order Placement
  String placeOrder({
    required String name,
    required String phone,
    required String address,
  }) {
    final orderId = 'CAF-${1000 + _orders.length + 1}';
    final newOrder = CoffeeOrder(
      id: orderId,
      customerEmail: _currentUser?.email ?? 'anonymous@gmail.com',
      items: List.from(_items),
      total: total,
      status: 'Pending',
      timestamp: DateTime.now(),
      deliveryName: name,
      deliveryPhone: phone,
      deliveryAddress: address,
    );
    
    _orders.add(newOrder);

    // Add loyalty points if logged in as user ($1 = 10 points)
    if (_currentUser != null && _currentUser!.role == 'user') {
      _currentUser!.loyaltyPoints += (total * 10).toInt();
    }

    _items.clear();
    notifyListeners();
    return orderId;
  }

  // Order Management
  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      notifyListeners();
    }
  }

  void cancelOrder(String orderId) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = 'Cancelled';
      notifyListeners();
    }
  }

  void changeOrderQuantity(String orderId, int itemIndex, int newQty) {
    final orderIndex = _orders.indexWhere((o) => o.id == orderId);
    if (orderIndex != -1) {
      final order = _orders[orderIndex];
      if (itemIndex >= 0 && itemIndex < order.items.length) {
        if (newQty <= 0) {
          order.items.removeAt(itemIndex);
        } else {
          order.items[itemIndex].quantity = newQty;
        }

        // Recalculate total price
        double newSubtotal = order.items.fold(0.0, (sum, item) => sum + item.totalPrice);
        if (order.items.isEmpty) {
          order.status = 'Cancelled';
        }
        // Update the order with recalculated details (delivery fee and tax)
        double newTotal = newSubtotal > 0 ? newSubtotal + 1.50 + (newSubtotal * 0.08) : 0.0;
        
        // Replace order object to reflect changes
        _orders[orderIndex] = CoffeeOrder(
          id: order.id,
          customerEmail: order.customerEmail,
          items: order.items,
          total: newTotal,
          status: order.status,
          timestamp: order.timestamp,
          deliveryName: order.deliveryName,
          deliveryPhone: order.deliveryPhone,
          deliveryAddress: order.deliveryAddress,
        );
        notifyListeners();
      }
    }
  }

  // Product Management (Admin Menu Manager)
  void addProduct(Product product) {
    _products.add(product);
    notifyListeners();
  }

  void editProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }
}
