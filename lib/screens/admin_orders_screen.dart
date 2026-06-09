import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final orders = cartState.orders.reversed.toList(); // Show newest orders first

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Screen Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Log'.toUpperCase(),
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
                    'All Orders Manager',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: CaffeineTheme.offWhite,
                    ),
                  ),
                ],
              ),
            ),

            // Orders List
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_rounded,
                            size: 64,
                            color: CaffeineTheme.outline.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No customer orders yet',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: CaffeineTheme.outline.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 120),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];

                        Color statusColor = CaffeineTheme.outline;
                        IconData statusIcon = Icons.info_outline;

                        if (order.status == 'Pending') {
                          statusColor = CaffeineTheme.amber;
                          statusIcon = Icons.hourglass_empty_rounded;
                        } else if (order.status == 'Brewing') {
                          statusColor = Colors.orangeAccent;
                          statusIcon = Icons.local_cafe_rounded;
                        } else if (order.status == 'Completed') {
                          statusColor = Colors.greenAccent;
                          statusIcon = Icons.check_circle_rounded;
                        } else if (order.status == 'Cancelled') {
                          statusColor = Colors.redAccent;
                          statusIcon = Icons.cancel_rounded;
                        }

                        return Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: CaffeineTheme.surface.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CaffeineTheme.cream.withOpacity(0.05),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Order title row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order ${order.id}',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: CaffeineTheme.cream,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Customer: ${order.customerEmail}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          color: CaffeineTheme.outline.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(statusIcon, color: statusColor, size: 12),
                                        const SizedBox(width: 4),
                                        Text(
                                          order.status,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(height: 1, color: Colors.white.withOpacity(0.04)),
                              const SizedBox(height: 12),

                              // Items list
                              const Text(
                                'Items Ordered:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: CaffeineTheme.outline,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ...order.items.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item.quantity}x ${item.product.title} (${item.size})',
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: CaffeineTheme.offWhite,
                                        ),
                                      ),
                                      Text(
                                        '\$${item.totalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 13,
                                          color: CaffeineTheme.offWhite.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              const SizedBox(height: 12),
                              Container(height: 1, color: Colors.white.withOpacity(0.04)),
                              const SizedBox(height: 12),

                              // Delivery Details
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.delivery_dining_rounded, color: CaffeineTheme.outline, size: 14),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Recipient: ${order.deliveryName} (${order.deliveryPhone})',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            color: CaffeineTheme.offWhite.withOpacity(0.6),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Address: ${order.deliveryAddress}',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 11,
                                            color: CaffeineTheme.offWhite.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Order Total & Action buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: \$${order.total.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: CaffeineTheme.secondary,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      // Status action button
                                      if (order.status == 'Pending')
                                        ElevatedButton(
                                          onPressed: () {
                                            cartState.updateOrderStatus(order.id, 'Brewing');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.orangeAccent,
                                            foregroundColor: CaffeineTheme.espresso,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          ),
                                          child: const Text('Start Brewing', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold)),
                                        ),
                                      if (order.status == 'Brewing')
                                        ElevatedButton(
                                          onPressed: () {
                                            cartState.updateOrderStatus(order.id, 'Completed');
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.greenAccent,
                                            foregroundColor: CaffeineTheme.espresso,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          ),
                                          child: const Text('Mark Ready', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold)),
                                        ),
                                      
                                      const SizedBox(width: 8),

                                      // Cancel order button
                                      if (order.status == 'Pending' || order.status == 'Brewing')
                                        OutlinedButton(
                                          onPressed: () {
                                            cartState.cancelOrder(order.id);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Colors.redAccent),
                                            foregroundColor: Colors.redAccent,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          ),
                                          child: const Text('Void', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                ],
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
    );
  }
}
