import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/pet.dart';
import '../../providers/pet_provider.dart';
import '../pet_form/pet_form_screen.dart';
import '../../../data/services/photo_service.dart';

/// Screen displaying detailed information about a pet.
class PetDetailScreen extends StatefulWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late Pet _currentPet;

  @override
  void initState() {
    super.initState();
    _currentPet = widget.pet;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentPet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editPet,
            tooltip: 'Edit Pet',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _deletePet();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Pet', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero photo
            _buildPhotoSection(),

            // Pet information
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and type
                  Row(
                    children: [
                      Icon(
                        Icons.pets,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _currentPet.type.displayName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Breed
                  if (_currentPet.breed != null) ...[
                    _buildInfoRow('Breed', _currentPet.breed!),
                    const SizedBox(height: 12),
                  ],

                  // Age
                  _buildInfoRow('Age', _currentPet.ageDisplayString),
                  const SizedBox(height: 12),

                  // Birth date
                  if (_currentPet.birthDate != null) ...[
                    _buildInfoRow(
                      'Birth Date',
                      DateFormat('MMM dd, yyyy').format(_currentPet.birthDate!),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Member since
                  _buildInfoRow(
                    'Added',
                    DateFormat('MMM dd, yyyy').format(_currentPet.createdAt),
                  ),
                  const SizedBox(height: 24),

                  // Quick stats section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Stats',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow('Feeding Sessions', '0'),
                          const Divider(),
                          _buildStatRow('Favorite Foods', 'Not available yet'),
                          const Divider(),
                          _buildStatRow('Most Recent Feeding', 'Never'),
                          const SizedBox(height: 8),
                          Text(
                            'Start logging feeding sessions to see statistics',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    return Hero(
      tag: 'pet_photo_${_currentPet.id}',
      child: Container(
        height: 300,
        color: Colors.grey[200],
        child: _currentPet.photoPath != null
            ? Image.file(
                File(_currentPet.photoPath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(
        Icons.pets,
        size: 120,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Future<void> _editPet() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetFormScreen(pet: _currentPet),
      ),
    );

    if (result == true && mounted) {
      // Reload the pet from the provider
      final provider = context.read<PetProvider>();
      await provider.loadPetById(_currentPet.id);
      if (provider.selectedPet != null) {
        setState(() {
          _currentPet = provider.selectedPet!;
        });
      }
    }
  }

  Future<void> _deletePet() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete ${_currentPet.name}?'),
            const SizedBox(height: 16),
            const Text(
              'This will permanently delete:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Pet profile'),
            const Text('• All feeding logs'),
            const Text('• Pet photo'),
            const SizedBox(height: 16),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Delete photo if it exists
    if (_currentPet.photoPath != null) {
      try {
        final photoService = PhotoService();
        await photoService.deletePhoto(_currentPet.photoPath!);
      } catch (e) {
        // Ignore photo deletion errors
      }
    }

    // Delete the pet
    final provider = context.read<PetProvider>();
    final success = await provider.deletePet(_currentPet.id);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context); // Return to pet list
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pet deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'Failed to delete pet'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
