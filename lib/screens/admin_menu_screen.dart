import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';
import '../models/product.dart';

class AdminMenuScreen extends StatelessWidget {
  const AdminMenuScreen({super.key});

  void _showProductForm(BuildContext context, {Product? product}) {
    final titleController = TextEditingController(text: product?.title ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final priceController = TextEditingController(text: product?.basePrice.toString() ?? '');
    final imageUrlController = TextEditingController(text: product?.imageUrl ?? 'https://lh3.googleusercontent.com/aida-public/AB6AXuCz5vdvsjhgCo11mMzCJEl4tMjtd7wQp6fEJiRp2xR5MO7GfZVzMAfQD_av1_qF7cXi6dEK5mYUSA7As0FLadaTCkWmWX063ptDidT1lDJl0r3y9scIFQ_qRsXyHlmCwHIwMVWVYuu9UqDPgNMuA0hstTaynhUfJKfvUsYCwP1PM7nzwzSagQQu018jdoX3TrLxLowCNF8f8x_GaEBfCBQSH2Rs44AtuqgCGptXUUqIixpooQsAwrXx0HZZx3cqaee6MBLazEsEHT9E');
    
    String selectedCategory = product?.category ?? 'Coffee';
    final categories = ['Coffee', 'Frappe', 'Latte', 'Desserts'];
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: true,
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
                  product == null ? 'Add New Brew' : 'Edit Coffee Details',
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontWeight: FontWeight.bold,
                    color: CaffeineTheme.cream,
                  ),
                ),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title Input
                        TextFormField(
                          controller: titleController,
                          style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 14),
                          decoration: const InputDecoration(
                            labelText: 'Drink Title',
                            labelStyle: TextStyle(color: CaffeineTheme.outline),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter a title' : null,
                        ),
                        const SizedBox(height: 12),

                        // Description Input
                        TextFormField(
                          controller: descriptionController,
                          style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 14),
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: CaffeineTheme.outline),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter description' : null,
                        ),
                        const SizedBox(height: 12),

                        // Price Input
                        TextFormField(
                          controller: priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 14),
                          decoration: const InputDecoration(
                            labelText: 'Base Price (\$)',
                            labelStyle: TextStyle(color: CaffeineTheme.outline),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Enter a price';
                            if (double.tryParse(val) == null) return 'Enter a valid decimal';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Image URL Input
                        TextFormField(
                          controller: imageUrlController,
                          style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 13),
                          decoration: const InputDecoration(
                            labelText: 'Image URL',
                            labelStyle: TextStyle(color: CaffeineTheme.outline),
                          ),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Enter image URL' : null,
                        ),
                        const SizedBox(height: 16),

                        // Category Dropdown
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          dropdownColor: CaffeineTheme.surface,
                          style: const TextStyle(color: CaffeineTheme.cream, fontFamily: 'Inter'),
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            labelStyle: TextStyle(color: CaffeineTheme.outline),
                          ),
                          items: categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedCategory = val;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: CaffeineTheme.outline)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final title = titleController.text.trim();
                        final description = descriptionController.text.trim();
                        final price = double.parse(priceController.text);
                        final imageUrl = imageUrlController.text.trim();

                        if (product == null) {
                          // ADD PRODUCT
                          final newId = title.toLowerCase().replaceAll(' ', '_') + '_${DateTime.now().millisecondsSinceEpoch}';
                          final newProduct = Product(
                            id: newId,
                            title: title,
                            description: description,
                            category: selectedCategory,
                            basePrice: price,
                            rating: 4.8,
                            reviewsCount: 1,
                            imageUrl: imageUrl,
                          );
                          context.read<CartState>().addProduct(newProduct);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$title added to menu!'), backgroundColor: CaffeineTheme.amber),
                          );
                        } else {
                          // EDIT PRODUCT
                          final updatedProduct = product.copyWith(
                            title: title,
                            description: description,
                            basePrice: price,
                            category: selectedCategory,
                            imageUrl: imageUrl,
                          );
                          context.read<CartState>().editProduct(updatedProduct);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('$title updated!'), backgroundColor: CaffeineTheme.amber),
                          );
                        }
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CaffeineTheme.amber,
                      foregroundColor: CaffeineTheme.espresso,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(product == null ? 'Add' : 'Save', style: const TextStyle(fontWeight: FontWeight.bold)),
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
    final products = cartState.products;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coffee Catalog'.toUpperCase(),
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
                        'Menu Manager',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: CaffeineTheme.offWhite,
                        ),
                      ),
                    ],
                  ),
                  // Floating Action Button Styled Inline
                  GestureDetector(
                    onTap: () => _showProductForm(context),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: CaffeineTheme.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: CaffeineTheme.espresso, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            // Product catalogue listing
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Text(
                        'No products. Add a new brew!',
                        style: TextStyle(color: CaffeineTheme.outline.withOpacity(0.6), fontFamily: 'Inter'),
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 120),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: CaffeineTheme.surface.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CaffeineTheme.cream.withOpacity(0.04),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Product Image
                              Container(
                                width: 72,
                                height: 72,
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

                              // Text details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontFamily: 'Playfair Display',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: CaffeineTheme.offWhite,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${product.category} • \$${product.basePrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        color: CaffeineTheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      product.description,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: CaffeineTheme.offWhite.withOpacity(0.5),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Action icons (Edit & Delete)
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: CaffeineTheme.amber, size: 20),
                                    onPressed: () => _showProductForm(context, product: product),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          backgroundColor: CaffeineTheme.surface,
                                          title: const Text('Delete Drink', style: TextStyle(fontFamily: 'Playfair Display', color: CaffeineTheme.cream)),
                                          content: Text('Are you sure you want to delete ${product.title} from the menu?', style: const TextStyle(fontFamily: 'Inter', color: CaffeineTheme.offWhite)),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: const Text('Cancel', style: TextStyle(color: CaffeineTheme.outline)),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context.read<CartState>().deleteProduct(product.id);
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text('${product.title} deleted.'), backgroundColor: Colors.redAccent),
                                                );
                                              },
                                              child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
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
