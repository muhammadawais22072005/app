import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';
import '../models/product.dart';

class MenuScreen extends StatefulWidget {
  final bool showOnlyFavorites;

  const MenuScreen({super.key, this.showOnlyFavorites = false});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Coffee';
  final List<String> _categories = ['Coffee', 'Frappe', 'Latte', 'Desserts'];

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final favorites = cartState.favorites;

    // Filter list based on choices
    final List<Product> filteredProducts = cartState.products.where((product) {
      // 1. Filter by favorites if showOnlyFavorites is true
      if (widget.showOnlyFavorites && !favorites.contains(product.id)) {
        return false;
      }
      // 2. Filter by category tab if not showing only favorites
      if (!widget.showOnlyFavorites && product.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Top Title
              Text(
                widget.showOnlyFavorites ? 'Your Favorites' : 'Our Menu',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontFamily: 'Playfair Display',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.showOnlyFavorites
                    ? 'Brews that found a warm place in your heart.'
                    : 'Handcrafted excellence in every single drop.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: CaffeineTheme.offWhite.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),

              // Category scroll tabs (Hide if we are showing only favorites)
              if (!widget.showOnlyFavorites) ...[
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final isSelected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? CaffeineTheme.amber : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? Colors.transparent : CaffeineTheme.cream.withOpacity(0.12),
                                width: 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: CaffeineTheme.amber.withOpacity(0.2),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                            child: Text(
                              cat,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? CaffeineTheme.espresso : CaffeineTheme.cream,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Product list
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              widget.showOnlyFavorites
                                  ? Icons.favorite_border_rounded
                                  : Icons.coffee_rounded,
                              size: 64,
                              color: CaffeineTheme.outline.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.showOnlyFavorites
                                  ? 'No favorites yet'
                                  : 'Coming soon',
                              style: TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.outline.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.showOnlyFavorites
                                  ? 'Tap the heart icon on your favorite drinks to keep them here.'
                                  : 'We are expanding our menu roasts currently.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: CaffeineTheme.outline.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 120), // Clear floating navigation bar
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          final isFav = favorites.contains(product.id);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: CaffeineTheme.surface.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: CaffeineTheme.cream.withOpacity(0.04),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Left side - Image
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: CaffeineTheme.cream.withOpacity(0.05),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: CaffeineTheme.surface,
                                        child: const Center(
                                          child: Icon(Icons.coffee, size: 28, color: CaffeineTheme.amber),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Center side - Title, Description, Price
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              product.title,
                                              style: const TextStyle(
                                                fontFamily: 'Playfair Display',
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: CaffeineTheme.offWhite,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          // Favorite Toggle Button
                                          GestureDetector(
                                            onTap: () {
                                              cartState.toggleFavorite(product.id);
                                            },
                                            child: Icon(
                                              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                              color: isFav ? CaffeineTheme.amber : CaffeineTheme.outline,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        product.description,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                          color: CaffeineTheme.offWhite.withOpacity(0.6),
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '\$${product.basePrice.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: CaffeineTheme.secondary,
                                            ),
                                          ),
                                          // Plus/Details Action
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                '/detail',
                                                arguments: {'product': product},
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: CaffeineTheme.cream.withOpacity(0.08),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Row(
                                                children: [
                                                  Text(
                                                    'Customize',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.bold,
                                                      color: CaffeineTheme.cream,
                                                    ),
                                                  ),
                                                  SizedBox(width: 4),
                                                  Icon(
                                                    Icons.arrow_forward_ios_rounded,
                                                    size: 8,
                                                    color: CaffeineTheme.cream,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
