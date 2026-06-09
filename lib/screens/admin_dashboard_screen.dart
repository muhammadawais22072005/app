import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final orders = cartState.orders;
    final products = cartState.products;
    final currentUser = cartState.currentUser;

    // Metrics calculations
    final double totalRevenue = orders
        .where((o) => o.status != 'Cancelled')
        .fold(0.0, (sum, o) => sum + o.total);
    final int totalOrders = orders.length;
    final int activeBrews = orders.where((o) => o.status == 'Brewing' || o.status == 'Pending').length;
    final int menuCount = products.length;

    // Get latest 4 orders
    final recentOrders = orders.reversed.take(4).toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              
              // Top Title & User Session Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Control Panel'.toUpperCase(),
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
                        'Admin Dashboard',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: CaffeineTheme.offWhite,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read<CartState>().logout();
                      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.08),
                        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.logout_rounded, color: Colors.redAccent, size: 14),
                          SizedBox(width: 6),
                          Text(
                            'Exit',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
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
              const SizedBox(height: 24),

              // Welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      CaffeineTheme.amber.withOpacity(0.15),
                      CaffeineTheme.espresso,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: CaffeineTheme.amber.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back, ${currentUser?.name ?? 'Admin'} 👋',
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CaffeineTheme.cream,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Store sync state is currently live. Real-time updates from customers will appear immediately below.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              color: CaffeineTheme.offWhite.withOpacity(0.6),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CaffeineTheme.amber.withOpacity(0.1),
                      ),
                      child: const Icon(Icons.admin_panel_settings_rounded, color: CaffeineTheme.amber, size: 28),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Metrics Grid (2x2)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.35,
                children: [
                  _buildMetricCard(
                    context,
                    'Total Sales',
                    '\$${totalRevenue.toStringAsFixed(2)}',
                    Icons.payments_rounded,
                    CaffeineTheme.amber,
                  ),
                  _buildMetricCard(
                    context,
                    'Orders Count',
                    '$totalOrders',
                    Icons.shopping_bag_rounded,
                    CaffeineTheme.secondary,
                  ),
                  _buildMetricCard(
                    context,
                    'Active Brews',
                    '$activeBrews',
                    Icons.local_cafe_rounded,
                    Colors.orangeAccent,
                  ),
                  _buildMetricCard(
                    context,
                    'Menu Catalog',
                    '$menuCount items',
                    Icons.restaurant_menu_rounded,
                    Colors.greenAccent,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Recent Orders Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Store Orders',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: CaffeineTheme.offWhite,
                    ),
                  ),
                  Text(
                    'Latest 4',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: CaffeineTheme.outline.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Recent Orders list
              recentOrders.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          'No orders received yet.',
                          style: TextStyle(color: CaffeineTheme.outline.withOpacity(0.5), fontFamily: 'Inter'),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentOrders.length,
                      itemBuilder: (context, index) {
                        final order = recentOrders[index];

                        Color statusColor = CaffeineTheme.outline;
                        if (order.status == 'Pending') statusColor = CaffeineTheme.amber;
                        if (order.status == 'Brewing') statusColor = Colors.orangeAccent;
                        if (order.status == 'Completed') statusColor = Colors.greenAccent;
                        if (order.status == 'Cancelled') statusColor = Colors.redAccent;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: CaffeineTheme.surface.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: CaffeineTheme.cream.withOpacity(0.04)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order ${order.id}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: CaffeineTheme.cream,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${order.items.length} items • \$${order.total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      color: CaffeineTheme.outline.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: statusColor.withOpacity(0.2)),
                                ),
                                child: Text(
                                  order.status,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: statusColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              const SizedBox(height: 20),

              // Customer Mode Portal Shortcut
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Log in as test customer alex dynamically for testing convenience
                    cartState.login('alex@gmail.com', 'alex123', 'user');
                    Navigator.of(context).pushReplacementNamed('/shell');
                  },
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text(
                    'Switch to Customer View',
                    style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: CaffeineTheme.creamOutlineButtonStyle.copyWith(
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
                label,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: CaffeineTheme.outline.withOpacity(0.8),
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CaffeineTheme.offWhite,
            ),
          ),
        ],
      ),
    );
  }
}
