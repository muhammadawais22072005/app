import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final orders = cartState.orders;
    final registeredUsers = cartState.registeredUsers;

    // Analytics computation
    final double totalSales = orders.where((o) => o.status != 'Cancelled').fold(0.0, (sum, o) => sum + o.total);
    final int ordersCount = orders.length;

    // Compute sales by category
    int coffeeCount = 0;
    int latteCount = 0;
    int frappeCount = 0;
    int dessertCount = 0;

    for (var order in orders) {
      if (order.status == 'Cancelled') continue;
      for (var item in order.items) {
        final category = item.product.category.toLowerCase();
        if (category == 'coffee') {
          coffeeCount += item.quantity;
        } else if (category == 'latte') {
          latteCount += item.quantity;
        } else if (category == 'frappe') {
          frappeCount += item.quantity;
        } else if (category == 'desserts') {
          dessertCount += item.quantity;
        }
      }
    }

    final int totalCount = coffeeCount + latteCount + frappeCount + dessertCount;

    // Percentages
    final double coffeePct = totalCount == 0 ? 0.0 : coffeeCount / totalCount;
    final double lattePct = totalCount == 0 ? 0.0 : latteCount / totalCount;
    final double frappePct = totalCount == 0 ? 0.0 : frappeCount / totalCount;
    final double dessertPct = totalCount == 0 ? 0.0 : dessertCount / totalCount;

    // Member points stats
    final double avgLoyalty = registeredUsers.isEmpty
        ? 0.0
        : registeredUsers.fold(0, (sum, u) => sum + u.loyaltyPoints) / registeredUsers.length;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              const SizedBox(height: 16),
              Text(
                'Store Metrics'.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: CaffeineTheme.outline,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Analytics & Stats',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: CaffeineTheme.offWhite,
                ),
              ),
              const SizedBox(height: 24),

              // Gross Income Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CaffeineTheme.surface.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: CaffeineTheme.cream.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'TOTAL REVENUE',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: CaffeineTheme.outline,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${totalSales.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: CaffeineTheme.amber,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aggregated from $ordersCount lifetime customer checkouts.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: CaffeineTheme.offWhite.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Category Breakdown Title
              const Text(
                'Sales by Category',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: CaffeineTheme.offWhite,
                ),
              ),
              const SizedBox(height: 16),

              // Category Progress Bar Chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: CaffeineTheme.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: CaffeineTheme.cream.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    _buildProgressBar('Classic Coffee', coffeeCount, coffeePct, CaffeineTheme.amber),
                    const SizedBox(height: 16),
                    _buildProgressBar('Specialty Lattes', latteCount, lattePct, CaffeineTheme.secondary),
                    const SizedBox(height: 16),
                    _buildProgressBar('Ice Frappes', frappeCount, frappePct, Colors.orangeAccent),
                    const SizedBox(height: 16),
                    _buildProgressBar('Artisanal Desserts', dessertCount, dessertPct, Colors.greenAccent),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Peak Ordering & Loyalty Info Grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Peak Ordering hours
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      height: 130,
                      decoration: BoxDecoration(
                        color: CaffeineTheme.surface.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: CaffeineTheme.cream.withOpacity(0.04)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PEAK HOURS',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: CaffeineTheme.outline.withOpacity(0.8),
                                ),
                              ),
                              const Icon(Icons.schedule_rounded, color: Colors.orangeAccent, size: 16),
                            ],
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '08:00 - 10:30',
                                style: TextStyle(
                                  fontFamily: 'Playfair Display',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: CaffeineTheme.offWhite,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Morning rush period',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: CaffeineTheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Loyalty Points metrics
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      height: 130,
                      decoration: BoxDecoration(
                        color: CaffeineTheme.surface.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: CaffeineTheme.cream.withOpacity(0.04)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'AVG REWARDS',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: CaffeineTheme.outline.withOpacity(0.8),
                                ),
                              ),
                              const Icon(Icons.stars_rounded, color: CaffeineTheme.amber, size: 16),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${avgLoyalty.toStringAsFixed(0)} pts',
                                style: const TextStyle(
                                  fontFamily: 'Playfair Display',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: CaffeineTheme.offWhite,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Per registered member',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  color: CaffeineTheme.outline.withOpacity(0.8),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildProgressBar(String title, int count, double fraction, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: CaffeineTheme.cream,
              ),
            ),
            Text(
              '$count sold (${(fraction * 100).toStringAsFixed(0)}%)',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: CaffeineTheme.offWhite.withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fraction.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
