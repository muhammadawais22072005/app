import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String _selectedSize = 'Medium';
  String _selectedMilk = 'Whole';
  bool _hasExtraShot = false;
  bool _hasWhippedCream = false;
  bool _hasCaramelDrizzle = false;
  int _quantity = 1;

  double get _currentUnitPrice {
    double price = widget.product.basePrice;
    if (_selectedSize == 'Medium') price += 0.50;
    if (_selectedSize == 'Large') price += 1.00;
    if (_hasExtraShot) price += 1.00;
    if (_selectedMilk == 'Oat' || _selectedMilk == 'Almond') price += 0.50;
    if (_hasCaramelDrizzle) price += 0.50;
    return price;
  }

  double get _totalPrice => _currentUnitPrice * _quantity;

  @override
  Widget build(BuildContext context) {
    final cartState = context.read<CartState>();
    final isFav = context.watch<CartState>().favorites.contains(widget.product.id);

    return Scaffold(
      body: Stack(
        children: [
          // Hero Parallax Scroll
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 180), // Clear sticky actions bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Hero Image (approx 45% of standard screen height)
                  Stack(
                    children: [
                      SizedBox(
                        height: 420,
                        width: double.infinity,
                        child: Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: CaffeineTheme.espresso,
                            child: const Center(
                              child: Icon(Icons.coffee, size: 84, color: CaffeineTheme.amber),
                            ),
                          ),
                        ),
                      ),
                      // Ambient bottom darkening overlay
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                CaffeineTheme.espresso,
                              ],
                              stops: [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Content Body
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.product.title,
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: CaffeineTheme.offWhite,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Ratings & Reviews count
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                final isHalf = index == 4; // Mock 4.8
                                return Icon(
                                  isHalf ? Icons.star_half_rounded : Icons.star_rounded,
                                  color: CaffeineTheme.secondary,
                                  size: 16,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.product.rating} (${widget.product.reviewsCount} reviews)',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                color: CaffeineTheme.offWhite.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: CaffeineTheme.offWhite.withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Size Selection
                        const Text(
                          'Select Size',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: CaffeineTheme.amber,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildSizeButton('Small', '+\$0.00'),
                            const SizedBox(width: 12),
                            _buildSizeButton('Medium', '+\$0.50'),
                            const SizedBox(width: 12),
                            _buildSizeButton('Large', '+\$1.00'),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Customize Add-ons Toggles
                        const Text(
                          'Customize Options',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: CaffeineTheme.amber,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          children: [
                            // Milk Choice Selector Row
                            _buildSelectionRow(
                              icon: Icons.water_drop_rounded,
                              title: 'Milk Choice',
                              trailing: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedMilk,
                                  dropdownColor: CaffeineTheme.surface,
                                  icon: const Icon(Icons.arrow_drop_down, color: CaffeineTheme.amber),
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    color: CaffeineTheme.cream,
                                    fontSize: 14,
                                  ),
                                  items: ['Whole', 'Oat', 'Almond'].map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(val == 'Whole' ? 'Whole' : '$val (+\$0.50)'),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        _selectedMilk = val;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Extra shot
                            _buildToggleRow(
                              icon: Icons.add_circle_rounded,
                              title: 'Extra espresso shot (+\$1.00)',
                              value: _hasExtraShot,
                              onChanged: (val) => setState(() => _hasExtraShot = val),
                            ),
                            const SizedBox(height: 12),

                            // Whipped cream
                            _buildToggleRow(
                              icon: Icons.cloud_rounded,
                              title: 'Whipped cream',
                              value: _hasWhippedCream,
                              onChanged: (val) => setState(() => _hasWhippedCream = val),
                            ),
                            const SizedBox(height: 12),

                            // Caramel Drizzle
                            _buildToggleRow(
                              icon: Icons.format_color_fill_rounded,
                              title: 'Caramel drizzle (+\$0.50)',
                              value: _hasCaramelDrizzle,
                              onChanged: (val) => setState(() => _hasCaramelDrizzle = val),
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

          // Custom Header (Floating back & heart buttons)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: CaffeineTheme.offWhite,
                      size: 20,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    cartState.toggleFavorite(widget.product.id);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? CaffeineTheme.amber : CaffeineTheme.offWhite,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sticky Bottom Actions Drawer panel (representing iOS style drawer)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 32),
              decoration: BoxDecoration(
                color: CaffeineTheme.surface.withOpacity(0.95),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(
                    color: CaffeineTheme.cream.withOpacity(0.06),
                    width: 1,
                  ),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 40,
                    offset: Offset(0, -10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantity controls
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_quantity > 1) {
                                  setState(() => _quantity--);
                                }
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.remove, color: CaffeineTheme.amber, size: 18),
                              ),
                            ),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '$_quantity',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: CaffeineTheme.cream,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _quantity++),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.add, color: CaffeineTheme.amber, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Dynamic total price
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Total Price',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 10,
                              color: CaffeineTheme.outline,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${_totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: CaffeineTheme.amber,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Add to Cart primary CTA
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        final item = CartItem(
                          product: widget.product,
                          size: _selectedSize,
                          milk: _selectedMilk,
                          hasExtraShot: _hasExtraShot,
                          hasWhippedCream: _hasWhippedCream,
                          hasCaramelDrizzle: _hasCaramelDrizzle,
                          quantity: _quantity,
                        );
                        cartState.addToCart(item);
                        
                        // Close product details and return
                        Navigator.of(context).pop();
                        
                        // Show snackbar feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.product.title} added to cart'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: CaffeineTheme.amber,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: CaffeineTheme.amberButtonStyle,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_rounded, color: CaffeineTheme.espresso),
                          SizedBox(width: 8),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: CaffeineTheme.espresso,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Size pill helper
  Widget _buildSizeButton(String sizeName, String priceDiffLabel) {
    final isSelected = _selectedSize == sizeName;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSize = sizeName;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? CaffeineTheme.amber.withOpacity(0.12) : CaffeineTheme.surface.withOpacity(0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? CaffeineTheme.amber : CaffeineTheme.cream.withOpacity(0.08),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                sizeName,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? CaffeineTheme.amber : CaffeineTheme.cream,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                priceDiffLabel,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  color: isSelected ? CaffeineTheme.amber.withOpacity(0.7) : CaffeineTheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Dropdown Custom selector row
  Widget _buildSelectionRow({required IconData icon, required String title, required Widget trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: CaffeineTheme.secondary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: CaffeineTheme.cream,
                ),
              ),
            ],
          ),
          trailing,
        ],
      ),
    );
  }

  // Custom switches row
  Widget _buildToggleRow({required IconData icon, required String title, required bool value, required ValueChanged<bool> onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: CaffeineTheme.secondary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: CaffeineTheme.cream,
                ),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: CaffeineTheme.espresso,
            activeTrackColor: CaffeineTheme.amber,
            inactiveTrackColor: Colors.white.withOpacity(0.08),
            inactiveThumbColor: CaffeineTheme.outline,
          ),
        ],
      ),
    );
  }
}
