import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final loyaltyPoints = cartState.loyaltyPoints;
    final currentUser = cartState.currentUser;
    
    // Calculates percentage to next free drink (500 points)
    final double progress = (loyaltyPoints / 500.0).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 120),
          child: Column(
            children: [
              const SizedBox(height: 16),
              
              // Page Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your Profile',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Avatar & Member Badge
              Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [CaffeineTheme.amber, CaffeineTheme.cream],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundColor: CaffeineTheme.espresso,
                          backgroundImage: const NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuCukFN3Nn1W8aeiKZYrgxQs_TNMuqOrdhVnou96SMSNT6vqH4JH7WRLXc7e2DuOVJXeXtpRscXbLPO01gkFG--qoRdlqN03xshsXwYVZukBJgYwYr_0D51notHfTfikLAlksNH3rye-NARK5OyvfycdwF4yG4pUIkzMEQKfSU4MXwKDvPDY2hXpXeQgNTmxmu-96mVYx2jXeXK54uax0uxmuFPaCVhTKCv7wJ7nKtdHsr4rf1PeoMUbDS3GMZWe-SJad1JRPS4IjvgI',
                          ),
                          onForegroundImageError: (error, stackTrace) {},
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: CaffeineTheme.amber,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: CaffeineTheme.espresso,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser?.name ?? 'Alex Rivers',
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: CaffeineTheme.offWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentUser?.role == 'admin' ? 'Administrator Portal' : 'Gold Member since 2022',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: CaffeineTheme.offWhite.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Expansive Gradient Loyalty points card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CaffeineTheme.surface.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: CaffeineTheme.amber.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CaffeineTheme.amber.withOpacity(0.04),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Caffeine Rewards'.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.amber,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Exclusive Member Card',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: CaffeineTheme.offWhite.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.stars_rounded,
                          color: CaffeineTheme.amber,
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Point levels with dynamic animation loader
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '$loyaltyPoints',
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.offWhite,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Points',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.amber,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '500 for free drink',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: CaffeineTheme.offWhite.withOpacity(0.4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress loading bar (Animated)
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: progress),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutCubic,
                      builder: (context, val, child) {
                        return Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: val,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CaffeineTheme.amber,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: CaffeineTheme.amber.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Redeem CTA actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Coffee icons representing progress
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.04),
                              ),
                              child: const Icon(Icons.coffee_rounded, size: 14, color: CaffeineTheme.amber),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.04),
                              ),
                              child: const Icon(Icons.coffee_rounded, size: 14, color: CaffeineTheme.amber),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.04),
                              ),
                              child: const Icon(Icons.add, size: 14, color: CaffeineTheme.outline),
                            ),
                          ],
                        ),
                        
                        // Redeem button
                        SizedBox(
                          height: 38,
                          child: OutlinedButton(
                            onPressed: () {
                              if (loyaltyPoints >= 500) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Free drink redeemed!'),
                                    backgroundColor: CaffeineTheme.amber,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Need 500 points to redeem.'),
                                    backgroundColor: Colors.orangeAccent,
                                  ),
                                );
                              }
                            },
                            style: CaffeineTheme.creamOutlineButtonStyle.copyWith(
                              padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 16)),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Redeem Now',
                              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              _buildMenuItem(Icons.receipt_long_rounded, 'My Orders', () {
                Navigator.of(context).pushNamed('/my_orders');
              }),
              const SizedBox(height: 12),
              _buildMenuItem(Icons.location_on_rounded, 'Saved Addresses', () {}),
              const SizedBox(height: 12),
              _buildMenuItem(Icons.credit_card_rounded, 'Payment Methods', () {}),
              const SizedBox(height: 12),
              _buildMenuItem(Icons.settings_rounded, 'Settings', () {}),
              const SizedBox(height: 12),
              
              // Logout (Highlight red option)
              GestureDetector(
                onTap: () {
                  context.read<CartState>().logout();
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.redAccent.withOpacity(0.12)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent.withOpacity(0.1),
                        ),
                        child: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Logout',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
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
    );
  }

  // Action row helper
  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: CaffeineTheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CaffeineTheme.cream.withOpacity(0.04)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CaffeineTheme.amber.withOpacity(0.08),
                  ),
                  child: Icon(icon, color: CaffeineTheme.amber, size: 18),
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CaffeineTheme.cream,
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right_rounded, color: CaffeineTheme.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
