import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';

class UserOrdersScreen extends StatelessWidget {
  const UserOrdersScreen({super.key});

  void _showChangeQuantityDialog(BuildContext context, CoffeeOrder order, int itemIndex, CartItem item) {
    int localQty = item.quantity;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AlertDialog(
                backgroundColor: CaffeineTheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: CaffeineTheme.cream.withOpacity(0.08)),
                ),
                title: Text(
                  'Change Quantity',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                    color: CaffeineTheme.cream,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.product.title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: CaffeineTheme.offWhite,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Adjust quantities for this brew. Setting it to 0 removes the item.',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: CaffeineTheme.outline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (localQty > 0) {
                              setDialogState(() {
                                localQty--;
                              });
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: CaffeineTheme.outline.withOpacity(0.3)),
                            ),
                            child: const Icon(Icons.remove, size: 18, color: CaffeineTheme.cream),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          '$localQty',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CaffeineTheme.cream,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              localQty++;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: CaffeineTheme.outline.withOpacity(0.3)),
                            ),
                            child: const Icon(Icons.add, size: 18, color: CaffeineTheme.cream),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: CaffeineTheme.outline)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartState>().changeOrderQuantity(order.id, itemIndex, localQty);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Order quantity updated!'),
                          backgroundColor: CaffeineTheme.amber,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CaffeineTheme.amber,
                      foregroundColor: CaffeineTheme.espresso,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartState>();
    final currentUser = cartState.currentUser;
    
    // Filter orders to show only current user's orders
    final userOrders = cartState.orders
        .where((o) => o.customerEmail.toLowerCase() == (currentUser?.email ?? '').toLowerCase())
        .toList()
        .reversed // Show newest first
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Track Rituals',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            color: CaffeineTheme.offWhite,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: CaffeineTheme.cream),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: userOrders.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 64,
                      color: CaffeineTheme.outline.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No orders placed yet',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: CaffeineTheme.outline.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your order history will appear here once brewed.',
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                itemCount: userOrders.length,
                itemBuilder: (context, index) {
                  final order = userOrders[index];
                  final isModifiable = order.status == 'Pending';
                  final isCancellable = order.status == 'Pending' || order.status == 'Brewing';

                  // Status colors and styling helpers
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
                        color: isModifiable ? statusColor.withOpacity(0.3) : CaffeineTheme.cream.withOpacity(0.05),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Order Header (ID & Status Badge)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          'Items:',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: CaffeineTheme.outline,
                          ),
                        ),
                        const SizedBox(height: 6),
                        ...List.generate(order.items.length, (itemIdx) {
                          final item = order.items[itemIdx];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.product.title} (${item.size})',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: CaffeineTheme.offWhite,
                                    ),
                                  ),
                                ),
                                if (isModifiable)
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: CaffeineTheme.amber, size: 16),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () => _showChangeQuantityDialog(context, order, itemIdx, item),
                                  )
                                else
                                  Text(
                                    '\$${item.totalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: CaffeineTheme.offWhite.withOpacity(0.8),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 12),
                        Container(height: 1, color: Colors.white.withOpacity(0.04)),
                        const SizedBox(height: 12),

                        // Delivery location details
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.location_on_rounded, color: CaffeineTheme.outline, size: 14),
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

                        // Order totals & Cancel Action button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Paid: \$${order.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: CaffeineTheme.secondary,
                              ),
                            ),
                            if (isCancellable)
                              OutlinedButton(
                                onPressed: () {
                                  context.read<CartState>().cancelOrder(order.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Order has been cancelled.'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.redAccent, width: 1),
                                  foregroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                child: const Text(
                                  'Cancel Order',
                                  style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
