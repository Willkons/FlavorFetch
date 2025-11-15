import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/pet.dart';
import '../../providers/pet_provider.dart';
import '../../widgets/photo_picker.dart';
import '../../../data/services/photo_service.dart';

/// Screen for adding or editing a pet.
class PetFormScreen extends StatefulWidget {
  final Pet? pet;

  const PetFormScreen({super.key, this.pet});

  @override
  State<PetFormScreen> createState() => _PetFormScreenState();
}

class _PetFormScreenState extends State<PetFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _photoService = PhotoService();

  PetType _selectedType = PetType.dog;
  DateTime? _birthDate;
  String? _photoPath;
  bool _isModified = false;
  bool _isSaving = false;

  bool get _isEditMode => widget.pet != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _nameController.text = widget.pet!.name;
      _breedController.text = widget.pet!.breed ?? '';
      _selectedType = widget.pet!.type;
      _birthDate = widget.pet!.birthDate;
      _photoPath = widget.pet!.photoPath;
    }

    // Track modifications
    _nameController.addListener(() => _isModified = true);
    _breedController.addListener(() => _isModified = true);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEditMode ? 'Edit Pet' : 'Add Pet'),
          actions: [
            if (_isSaving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Photo Picker
              Center(
                child: PhotoPicker(
                  photoPath: _photoPath,
                  onCamera: _pickPhotoFromCamera,
                  onGallery: _pickPhotoFromGallery,
                  onRemove: () {
                    setState(() {
                      _photoPath = null;
                      _isModified = true;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  hintText: 'Enter pet name',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  if (value.trim().length > 50) {
                    return 'Name must be 50 characters or less';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pet Type dropdown
              DropdownButtonFormField<PetType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type *',
                  border: OutlineInputBorder(),
                ),
                items: PetType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        const Icon(Icons.pets),
                        const SizedBox(width: 8),
                        Text(type.displayName),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                    _isModified = true;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Breed field
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(
                  labelText: 'Breed',
                  hintText: 'Enter breed (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLength: 50,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),

              // Birth Date picker
              InkWell(
                onTap: _pickBirthDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Birth Date',
                    hintText: 'Select birth date (optional)',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    _birthDate == null
                        ? ''
                        : DateFormat('MMM dd, yyyy').format(_birthDate!),
                    style: _birthDate == null
                        ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              ElevatedButton(
                onPressed: _isSaving ? null : _savePet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(_isEditMode ? 'Save Changes' : 'Add Pet'),
              ),
              const SizedBox(height: 8),

              // Cancel button
              OutlinedButton(
                onPressed: _isSaving ? null : () => _onCancel(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickPhotoFromCamera() async {
    try {
      final path = await _photoService.pickFromCamera();
      if (path != null) {
        setState(() {
          _photoPath = path;
          _isModified = true;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to capture photo: $e');
    }
  }

  Future<void> _pickPhotoFromGallery() async {
    try {
      final path = await _photoService.pickFromGallery();
      if (path != null) {
        setState(() {
          _photoPath = path;
          _isModified = true;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select photo: $e');
    }
  }

  Future<void> _pickBirthDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (date != null) {
      setState(() {
        _birthDate = date;
        _isModified = true;
      });
    }
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final now = DateTime.now();
    final pet = Pet(
      id: _isEditMode ? widget.pet!.id : const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      breed: _breedController.text.trim().isEmpty
          ? null
          : _breedController.text.trim(),
      birthDate: _birthDate,
      photoPath: _photoPath,
      createdAt: _isEditMode ? widget.pet!.createdAt : now,
      updatedAt: now,
    );

    final petProvider = context.read<PetProvider>();
    final success =
        _isEditMode ? await petProvider.updatePet(pet) : await petProvider.createPet(pet);

    setState(() {
      _isSaving = false;
    });

    if (!mounted) return;

    if (success) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditMode
                ? 'Pet updated successfully'
                : 'Pet added successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      _showErrorSnackBar(petProvider.error ?? 'Failed to save pet');
    }
  }

  Future<bool> _onWillPop() async {
    if (!_isModified) return true;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Continue Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  void _onCancel(BuildContext context) async {
    if (_isModified) {
      final shouldCancel = await _onWillPop();
      if (shouldCancel && mounted) {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
