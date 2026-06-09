import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  // Beautiful Specialty Brew Loader Animation Trigger
  void _triggerCheckout(BuildContext context, String name, String phone, String address) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SpecialtyBrewLoader();
      },
    );

    // After 3.5 seconds of "brewing", finalize checkout state and push confirmation screen
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        // Finalize state
        context.read<CartState>().placeOrder(
          name: name,
          phone: phone,
          address: address,
        );
        
        // Pop loader dialog
        Navigator.of(context).pop();
        
        // Push order confirmation screen
        Navigator.of(context).pushReplacementNamed('/confirmation');
      }
    });
  }

  // Display checkout form in a glassmorphic bottom sheet
  void _showCheckoutForm(BuildContext context) {
    final currentUser = context.read<CartState>().currentUser;
    final nameController = TextEditingController(text: currentUser?.name ?? '');
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: CaffeineTheme.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              border: Border(
                top: BorderSide(color: Colors.white12, width: 1),
              ),
            ),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.delivery_dining_rounded, color: CaffeineTheme.amber, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Delivery Details',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: CaffeineTheme.offWhite,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Provide contact and location info for your brewing ritual.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: CaffeineTheme.outline.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Name Field
                    TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Recipient Name',
                        labelStyle: const TextStyle(color: CaffeineTheme.outline, fontSize: 13),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: CaffeineTheme.amber),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: CaffeineTheme.outline.withOpacity(0.2)),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter recipient name' : null,
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Contact Phone Number',
                        labelStyle: const TextStyle(color: CaffeineTheme.outline, fontSize: 13),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: CaffeineTheme.amber),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: CaffeineTheme.outline.withOpacity(0.2)),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a contact phone number' : null,
                    ),
                    const SizedBox(height: 16),

                    // Address Field
                    TextFormField(
                      controller: addressController,
                      style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Delivery Address / Table No.',
                        labelStyle: const TextStyle(color: CaffeineTheme.outline, fontSize: 13),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: CaffeineTheme.amber),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: CaffeineTheme.outline.withOpacity(0.2)),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter delivery location' : null,
                    ),
                    const SizedBox(height: 28),

                    // Confirm Order Button
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.of(context).pop(); // Close sheet
                            _triggerCheckout(
                              context,
                              nameController.text.trim(),
                              phoneController.text.trim(),
                              addressController.text.trim(),
                            );
                          }
                        },
                        style: CaffeineTheme.amberButtonStyle,
                        child: const Text(
                          'Confirm & Place Order',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: CaffeineTheme.espresso,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final cartItems = cartState.items;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Order',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.loyalty_rounded,
                    color: CaffeineTheme.amber,
                    size: 24,
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: cartItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 72,
                            color: CaffeineTheme.outline.withOpacity(0.3),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CaffeineTheme.outline.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Looks like you haven\'t added any ritual brews yet.',
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
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pickup Time Badge
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: CaffeineTheme.secondary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: CaffeineTheme.secondary.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    color: CaffeineTheme.secondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Estimated Ready: 10-15 mins',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: CaffeineTheme.secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Order Items Title
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: CaffeineTheme.offWhite,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Cart Items list
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: cartItems.length,
                            itemBuilder: (context, index) {
                              final item = cartItems[index];
                              
                              // Build description subtitle string dynamically
                              final List<String> details = [item.size];
                              if (item.milk != 'Whole') details.add('${item.milk} Milk');
                              if (item.hasExtraShot) details.add('+1 Shot');
                              if (item.hasWhippedCream) details.add('+Cream');
                              if (item.hasCaramelDrizzle) details.add('+Drizzle');
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: CaffeineTheme.surface.withOpacity(0.35),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: CaffeineTheme.cream.withOpacity(0.05),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Left - Image
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: CaffeineTheme.cream.withOpacity(0.05),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          item.product.imageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Container(
                                            color: CaffeineTheme.surface,
                                            child: const Center(
                                              child: Icon(Icons.coffee, size: 24, color: CaffeineTheme.amber),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),

                                    // Center - Title, description, calculations
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item.product.title,
                                                  style: const TextStyle(
                                                    fontFamily: 'Playfair Display',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: CaffeineTheme.offWhite,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                '\$${item.totalPrice.toStringAsFixed(2)}',
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: CaffeineTheme.amber,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            details.join(', '),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 11,
                                              color: CaffeineTheme.outline,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          
                                          // Count editor
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  cartState.decrementQuantity(item);
                                                },
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: CaffeineTheme.outline.withOpacity(0.3)),
                                                  ),
                                                  child: const Icon(Icons.remove, size: 14, color: CaffeineTheme.cream),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Text(
                                                '${item.quantity}',
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: CaffeineTheme.cream,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              GestureDetector(
                                                onTap: () {
                                                  cartState.incrementQuantity(item);
                                                },
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: CaffeineTheme.outline.withOpacity(0.3)),
                                                  ),
                                                  child: const Icon(Icons.add, size: 14, color: CaffeineTheme.cream),
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
                          const SizedBox(height: 24),

                          // Discount input
                          const Text(
                            'Discount Code',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: CaffeineTheme.outline,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: TextField(
                                    controller: _promoController,
                                    style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 14),
                                    decoration: InputDecoration(
                                      hintText: 'Enter promo code',
                                      hintStyle: TextStyle(color: CaffeineTheme.outline.withOpacity(0.6), fontSize: 14),
                                      filled: true,
                                      fillColor: CaffeineTheme.surface.withOpacity(0.4),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: CaffeineTheme.outline.withOpacity(0.2)),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: CaffeineTheme.amber),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Invalid code'),
                                        backgroundColor: Colors.redAccent,
                                      ),
                                    );
                                  },
                                  style: CaffeineTheme.creamOutlineButtonStyle,
                                  child: const Text(
                                    'Apply',
                                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Totals Card summary
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: CaffeineTheme.surface.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: CaffeineTheme.cream.withOpacity(0.06),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Subtotal', style: TextStyle(color: CaffeineTheme.outline)),
                                    Text('\$${cartState.subtotal.toStringAsFixed(2)}', style: const TextStyle(color: CaffeineTheme.offWhite)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Delivery Fee', style: TextStyle(color: CaffeineTheme.outline)),
                                    Text('\$${cartState.deliveryFee.toStringAsFixed(2)}', style: const TextStyle(color: CaffeineTheme.offWhite)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Estimated Tax (8%)', style: TextStyle(color: CaffeineTheme.outline)),
                                    Text('\$${cartState.tax.toStringAsFixed(2)}', style: const TextStyle(color: CaffeineTheme.offWhite)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(height: 1, color: Colors.white.withOpacity(0.08)),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Price',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: CaffeineTheme.offWhite,
                                      ),
                                    ),
                                    Text(
                                      '\$${cartState.total.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontFamily: 'Playfair Display',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: CaffeineTheme.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Checkout primary CTA button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () => _showCheckoutForm(context),
                              style: CaffeineTheme.amberButtonStyle,
                              child: const Text(
                                'Place Order',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: CaffeineTheme.espresso,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Specialty Coffee Brewing Micro-Animation Overlay
class SpecialtyBrewLoader extends StatefulWidget {
  const SpecialtyBrewLoader({super.key});

  @override
  State<SpecialtyBrewLoader> createState() => _SpecialtyBrewLoaderState();
}

class _SpecialtyBrewLoaderState extends State<SpecialtyBrewLoader> with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Spinning amber ring with coffee mug pulsing
              Stack(
                alignment: Alignment.center,
                children: [
                  RotationTransition(
                    turns: _animController,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CaffeineTheme.amber.withOpacity(0.12),
                          width: 4,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: CaffeineTheme.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0.9, end: 1.1),
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(scale: scale, child: child);
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CaffeineTheme.espresso,
                        border: Border.all(color: CaffeineTheme.cream.withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: CaffeineTheme.amber.withOpacity(0.25),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.local_cafe_rounded,
                          color: CaffeineTheme.amber,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Loading subtitle
              Text(
                'Brewing Specialty Roast...'.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: CaffeineTheme.cream,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Baristas are heating the espresso crema.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: CaffeineTheme.offWhite.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
