import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Coffee', 'Frappe', 'Latte', 'Desserts'];

  late PageController _pageController;
  double _currentPageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.72);
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPageOffset = _pageController.page ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final products = cartState.products;
    final loyaltyPoints = cartState.loyaltyPoints;
    final currentUser = cartState.currentUser;
    final favorites = cartState.favorites;

    // Filter products based on selected category tab
    final filteredProducts = products.where((p) {
      if (_selectedCategory == 'All') return true;
      return p.category.toLowerCase() == _selectedCategory.toLowerCase();
    }).toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Top App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.coffee_rounded,
                          color: CaffeineTheme.amber,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Caffeine',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontFamily: 'Playfair Display',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Points Tracker Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: CaffeineTheme.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: CaffeineTheme.amber.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            color: CaffeineTheme.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$loyaltyPoints pts',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: CaffeineTheme.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Greeting Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Morning Ritual'.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: CaffeineTheme.outline,
                        letterSpacing: 1.8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Good morning, ${currentUser?.name.split(' ').first ?? 'Alex'} ☕',
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: CaffeineTheme.offWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Category Selector
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = cat;
                              // Reset page index if category changes to avoid index issues
                              if (_pageController.hasClients) {
                                _pageController.jumpToPage(0);
                              }
                            });
                          },
                          labelStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? CaffeineTheme.espresso : CaffeineTheme.cream,
                          ),
                          selectedColor: CaffeineTheme.amber,
                          backgroundColor: CaffeineTheme.surface.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? Colors.transparent : CaffeineTheme.cream.withOpacity(0.1),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),

            // Circular Wheel Menu Heading
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Specialty Wheel',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Playfair Display',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'Swipe brews',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: CaffeineTheme.amber.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // horizontal 3D Circular menu slider
            SliverToBoxAdapter(
              child: Container(
                height: 380,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(
                          'No items in this category yet.',
                          style: TextStyle(color: CaffeineTheme.outline.withOpacity(0.7)),
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final isFav = favorites.contains(product.id);

                          // Calculate page offset difference
                          double difference = index - _currentPageOffset;
                          
                          // 3D perspective computations
                          double rotateY = difference * -0.25; // 3D Tilt Y-axis
                          double translateCurve = difference.abs() * difference.abs() * 12.0; // Curves cards downward in circle
                          double scale = (1.0 - (difference.abs() * 0.15)).clamp(0.82, 1.0);
                          double opacity = (1.0 - (difference.abs() * 0.45)).clamp(0.35, 1.0);

                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001) // 3D Perspective index
                              ..rotateY(rotateY)
                              ..translate(0.0, translateCurve, 0.0),
                            alignment: Alignment.center,
                            child: Opacity(
                              opacity: opacity,
                              child: Transform.scale(
                                scale: scale,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: CaffeineTheme.surface.withOpacity(0.65),
                                    borderRadius: BorderRadius.circular(28),
                                    border: Border.all(
                                      color: CaffeineTheme.cream.withOpacity(0.08),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Product Image
                                        Image.network(
                                          product.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: CaffeineTheme.surface,
                                            child: const Center(
                                              child: Icon(Icons.coffee, size: 72, color: CaffeineTheme.amber),
                                            ),
                                          ),
                                        ),
                                        
                                        // Dark fading overlay gradient
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                CaffeineTheme.espresso.withOpacity(0.3),
                                                CaffeineTheme.espresso.withOpacity(0.95),
                                              ],
                                              stops: const [0.35, 0.6, 0.95],
                                            ),
                                          ),
                                        ),

                                        // Item content details
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      product.title,
                                                      style: const TextStyle(
                                                        fontFamily: 'Playfair Display',
                                                        fontSize: 22,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      cartState.toggleFavorite(product.id);
                                                    },
                                                    child: Icon(
                                                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                                      color: isFav ? CaffeineTheme.amber : CaffeineTheme.outline,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                product.description,
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 12,
                                                  color: CaffeineTheme.offWhite.withOpacity(0.7),
                                                  height: 1.35,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    '\$${product.basePrice.toStringAsFixed(2)}',
                                                    style: const TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold,
                                                      color: CaffeineTheme.secondary,
                                                    ),
                                                  ),
                                                  
                                                  // Experience details button
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pushNamed(
                                                        '/detail',
                                                        arguments: {'product': product},
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: CaffeineTheme.amber,
                                                      foregroundColor: CaffeineTheme.espresso,
                                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(16),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    child: const Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          'Customize',
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                        SizedBox(width: 4),
                                                        Icon(Icons.arrow_forward_ios_rounded, size: 10),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            // House Favorites Grid Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Text(
                  'Quick Ordering List',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
            ),

            // House Favorites grid listing
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.78,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // Preloaded house favorites
                    final houseFavorites = products.where((p) => p.id == 'classic_espresso' || p.id == 'caramel_macchiato' || p.id == 'cappuccino').toList();
                    if (index >= houseFavorites.length) return const SizedBox.shrink();
                    final product = houseFavorites[index];
                    
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/detail',
                          arguments: {'product': product},
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: CaffeineTheme.surface.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: CaffeineTheme.cream.withOpacity(0.06),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          color: CaffeineTheme.surface,
                                          child: const Center(
                                            child: Icon(Icons.coffee, size: 40, color: CaffeineTheme.amber),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Quick add action circle
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        final cartItem = CartItem(
                                          product: product,
                                          size: 'Medium',
                                          milk: 'Whole',
                                          hasExtraShot: false,
                                          hasWhippedCream: false,
                                          hasCaramelDrizzle: false,
                                        );
                                        cartState.addToCart(cartItem);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${product.title} added to cart!'),
                                            duration: const Duration(seconds: 1),
                                            backgroundColor: CaffeineTheme.amber,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: const BoxDecoration(
                                          color: CaffeineTheme.amber,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          color: CaffeineTheme.espresso,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.title,
                                    style: const TextStyle(
                                      fontFamily: 'Playfair Display',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: CaffeineTheme.offWhite,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\$${product.basePrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: CaffeineTheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: math.min(2, products.length),
                ),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }
}
