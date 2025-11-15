import 'package:flutter/material.dart';

/// Home screen - placeholder for future navigation
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlavorFetch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to FlavorFetch!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Track your pet\'s food preferences',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 48),
            _buildPlaceholderButton(context, 'Pet Management', Icons.pets),
            const SizedBox(height: 16),
            _buildPlaceholderButton(context, 'Scan Barcode', Icons.qr_code_scanner),
            const SizedBox(height: 16),
            _buildPlaceholderButton(context, 'Feeding Logs', Icons.restaurant),
            const SizedBox(height: 16),
            _buildPlaceholderButton(context, 'Analytics', Icons.analytics),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderButton(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label - Coming in future sprints'),
          ),
        );
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(250, 48),
      ),
    );
  }
}
