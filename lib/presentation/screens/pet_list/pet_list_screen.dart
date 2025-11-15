import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/pet.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/pet_card.dart';
import '../../widgets/empty_state.dart';
import '../pet_form/pet_form_screen.dart';
import '../pet_detail/pet_detail_screen.dart';

/// Screen displaying a list of all pets.
///
/// Supports both grid and list views, pull-to-refresh,
/// and navigation to add/edit/detail screens.
class PetListScreen extends StatefulWidget {
  const PetListScreen({super.key});

  @override
  State<PetListScreen> createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    // Load pets when the screen is first displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PetProvider>().loadPets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Pets'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
        ],
      ),
      body: Consumer<PetProvider>(
        builder: (context, petProvider, child) {
          // Show loading indicator
          if (petProvider.isLoading && petProvider.pets.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Show error if there is one
          if (petProvider.error != null && petProvider.pets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    petProvider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => petProvider.loadPets(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Show empty state
          if (!petProvider.hasPets) {
            return EmptyState(
              icon: Icons.pets,
              title: 'No Pets Yet',
              message: 'Add your first pet to start tracking their food preferences!',
              actionLabel: 'Add Your First Pet',
              onAction: () => _navigateToAddPet(context),
            );
          }

          // Show pet list
          return RefreshIndicator(
            onRefresh: () => petProvider.refresh(),
            child: _isGridView
                ? _buildGridView(petProvider.pets)
                : _buildListView(petProvider.pets),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddPet(context),
        tooltip: 'Add Pet',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGridView(List<Pet> pets) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          pet: pet,
          isGridView: true,
          onTap: () => _navigateToPetDetail(context, pet),
        );
      },
    );
  }

  Widget _buildListView(List<Pet> pets) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return PetCard(
          pet: pet,
          isGridView: false,
          onTap: () => _navigateToPetDetail(context, pet),
        );
      },
    );
  }

  void _navigateToAddPet(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetFormScreen(),
      ),
    );
  }

  void _navigateToPetDetail(BuildContext context, Pet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PetDetailScreen(pet: pet),
      ),
    );
  }
}
