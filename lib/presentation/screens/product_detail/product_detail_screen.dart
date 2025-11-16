import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/product.dart';
import '../../providers/product_provider.dart';

/// Screen for displaying detailed product information
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshProduct(context),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareProduct(context),
            tooltip: 'Share',
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final displayProduct = provider.currentProduct ?? product;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                _ProductImage(imageUrl: displayProduct.imageUrl),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product name and brand
                      Text(
                        displayProduct.displayName,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),

                      // Barcode
                      _InfoChip(
                        icon: Icons.qr_code,
                        label: 'Barcode: ${displayProduct.barcode}',
                      ),
                      const SizedBox(height: 8),

                      // Manual entry indicator
                      if (displayProduct.isManualEntry)
                        const _InfoChip(
                          icon: Icons.edit,
                          label: 'Manual Entry',
                          color: Colors.orange,
                        ),
                      const SizedBox(height: 16),

                      // Categories
                      if (displayProduct.categories.isNotEmpty)
                        _Section(
                          title: 'Categories',
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: displayProduct.categories
                                .map((cat) => Chip(label: Text(cat)))
                                .toList(),
                          ),
                        ),

                      // Ingredients
                      if (displayProduct.ingredients != null)
                        _Section(
                          title: 'Ingredients',
                          child: Text(displayProduct.ingredients!),
                        ),

                      // Nutrition facts
                      if (displayProduct.nutritionFacts != null)
                        _Section(
                          title: 'Nutrition Facts',
                          child: _NutritionFactsTable(
                            facts: displayProduct.nutritionFacts!,
                          ),
                        ),

                      // Cache info
                      if (displayProduct.lastUpdated != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Last updated: ${_formatDate(displayProduct.lastUpdated!)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _logFeeding(context),
        icon: const Icon(Icons.restaurant),
        label: const Text('Log Feeding'),
      ),
    );
  }

  void _refreshProduct(BuildContext context) async {
    final provider = context.read<ProductProvider>();
    await provider.getProductByBarcode(product.barcode, forceRefresh: true);

    if (context.mounted && provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  void _shareProduct(BuildContext context) {
    final text = 'Check out this pet food: ${product.displayName}\n'
        'Barcode: ${product.barcode}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product info copied to clipboard')),
    );
  }

  void _logFeeding(BuildContext context) {
    // TODO: Navigate to feeding log screen (Sprint 3)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feeding log feature coming in Sprint 3'),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

/// Widget for displaying product image
class _ProductImage extends StatelessWidget {
  final String? imageUrl;

  const _ProductImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[200],
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => _PlaceholderImage(),
            )
          : _PlaceholderImage(),
    );
  }
}

/// Placeholder image widget
class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
    );
  }
}

/// Info chip widget
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}

/// Section widget with title
class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

/// Nutrition facts table widget
class _NutritionFactsTable extends StatelessWidget {
  final NutritionFacts facts;

  const _NutritionFactsTable({required this.facts});

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      children: [
        _buildRow('Serving Size', facts.servingSize),
        if (facts.energyKcal != null)
          _buildRow('Energy', '${facts.energyKcal} kcal'),
        if (facts.proteins != null) _buildRow('Proteins', '${facts.proteins}g'),
        if (facts.carbohydrates != null)
          _buildRow('Carbohydrates', '${facts.carbohydrates}g'),
        if (facts.fat != null) _buildRow('Fat', '${facts.fat}g'),
        if (facts.fiber != null) _buildRow('Fiber', '${facts.fiber}g'),
      ],
    );
  }

  TableRow _buildRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(value, textAlign: TextAlign.right),
        ),
      ],
    );
  }
}
