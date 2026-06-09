import 'package:flutter/material.dart';
import '../theme/caffeine_theme.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _steamController;

  @override
  void initState() {
    super.initState();
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _steamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ambient back radial shadows
          Positioned.fill(
            child: Container(
              color: CaffeineTheme.espresso,
            ),
          ),
          
          // Custom glowing light center background
          Center(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CaffeineTheme.amber.withOpacity(0.02),
                boxShadow: [
                  BoxShadow(
                    color: CaffeineTheme.amber.withOpacity(0.04),
                    blurRadius: 100,
                    spreadRadius: 20,
                  )
                ],
              ),
            ),
          ),

          // Core details
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Success badge graphics
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Large glassmorphic background circle
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CaffeineTheme.surface.withOpacity(0.5),
                            border: Border.all(
                              color: CaffeineTheme.cream.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.local_cafe_rounded,
                              color: CaffeineTheme.amber,
                              size: 72,
                            ),
                          ),
                        ),

                        // Checkmark Badge (Bottom Right overlay)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: CaffeineTheme.amber,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: CaffeineTheme.amber.withOpacity(0.35),
                                  blurRadius: 15,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                              weight: 900,
                            ),
                          ),
                        ),

                        // Floating Steam particles mockup using simple translations
                        AnimatedBuilder(
                          animation: _steamController,
                          builder: (context, child) {
                            final val = _steamController.value;
                            return Positioned(
                              top: -24 - (val * 12),
                              left: 36,
                              child: Opacity(
                                opacity: (1.0 - val).clamp(0.0, 1.0),
                                child: Icon(
                                  Icons.air,
                                  color: CaffeineTheme.amber.withOpacity(0.4),
                                  size: 24,
                                ),
                              ),
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: _steamController,
                          builder: (context, child) {
                            final val = (_steamController.value + 0.5) % 1.0;
                            return Positioned(
                              top: -28 - (val * 16),
                              left: 72,
                              child: Opacity(
                                opacity: (1.0 - val).clamp(0.0, 1.0),
                                child: Icon(
                                  Icons.air,
                                  color: CaffeineTheme.amber.withOpacity(0.3),
                                  size: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Message headers
                  const Text(
                    'Your order is being prepared!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: CaffeineTheme.offWhite,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sit back and relax. Our baristas are crafting your perfect specialty cup right now.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: CaffeineTheme.offWhite.withOpacity(0.6),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Order Info Card
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: CaffeineTheme.surface.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: CaffeineTheme.cream.withOpacity(0.06),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.outline,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '#CAF-9821',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.cream,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 32,
                          color: Colors.white.withOpacity(0.08),
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Ready in',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.outline,
                                letterSpacing: 1.0,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.schedule_rounded, color: CaffeineTheme.secondary, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  '12 mins',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: CaffeineTheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),

                  // Bottom action buttons CTAs
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order tracking coming soon!'),
                            backgroundColor: CaffeineTheme.amber,
                          ),
                        );
                      },
                      style: CaffeineTheme.amberButtonStyle,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_rounded, color: CaffeineTheme.espresso),
                          SizedBox(width: 8),
                          Text(
                            'Track Order',
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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/shell');
                      },
                      style: CaffeineTheme.creamOutlineButtonStyle,
                      child: const Text(
                        'Back to Home',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: CaffeineTheme.cream,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
