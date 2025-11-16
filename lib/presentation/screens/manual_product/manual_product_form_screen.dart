import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/product.dart';
import '../../providers/product_provider.dart';

/// Screen for manually entering product information
class ManualProductFormScreen extends StatefulWidget {
  const ManualProductFormScreen({super.key});

  @override
  State<ManualProductFormScreen> createState() =>
      _ManualProductFormScreenState();
}

class _ManualProductFormScreenState extends State<ManualProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedType = 'Dry Food';
  final List<String> _productTypes = [
    'Dry Food',
    'Wet Food',
    'Treats',
    'Supplements',
  ];

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _barcodeController.dispose();
    _ingredientsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    // Generate barcode if not provided
    final barcode = _barcodeController.text.trim().isEmpty
        ? 'MANUAL_${DateTime.now().millisecondsSinceEpoch}'
        : _barcodeController.text.trim();

    // Create product
    final product = Product(
      barcode: barcode,
      name: _nameController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      ingredients: _ingredientsController.text.trim().isEmpty
          ? null
          : _ingredientsController.text.trim(),
      categories: [_selectedType],
      isManualEntry: true,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    // Save via provider
    final provider = context.read<ProductProvider>();
    await provider.createManualProduct(product);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${provider.errorMessage}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully')),
      );

      // Navigate to product detail
      Navigator.pushReplacementNamed(
        context,
        '/product-detail',
        arguments: product,
      );
    }
  }

  Future<bool> _onWillPop() async {
    // Check if form has unsaved changes
    final hasChanges = _nameController.text.isNotEmpty ||
        _brandController.text.isNotEmpty ||
        _barcodeController.text.isNotEmpty ||
        _ingredientsController.text.isNotEmpty ||
        _notesController.text.isNotEmpty;

    if (!hasChanges) return true;

    // Show confirmation dialog
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text('You have unsaved changes. Are you sure you want '
            'to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product Manually'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info message
                Card(
                  color: Colors.blue[50],
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Use this form for products not found in the '
                            'database.',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Product name (required)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Product Name *',
                    hintText: 'e.g., Chicken & Rice Formula',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Product name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Brand name (optional)
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name',
                    hintText: 'e.g., Purina, Royal Canin',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 50,
                ),
                const SizedBox(height: 16),

                // Barcode (optional)
                TextFormField(
                  controller: _barcodeController,
                  decoration: const InputDecoration(
                    labelText: 'Barcode',
                    hintText: 'Optional - leave blank to auto-generate',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Barcode must be numeric';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Product type dropdown
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Product Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _productTypes
                      .map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _selectedType = value!);
                  },
                ),
                const SizedBox(height: 16),

                // Ingredients (optional)
                TextFormField(
                  controller: _ingredientsController,
                  decoration: const InputDecoration(
                    labelText: 'Ingredients',
                    hintText: 'List main ingredients...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),

                // Notes (optional)
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes',
                    hintText: 'Any additional notes...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Save button
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
