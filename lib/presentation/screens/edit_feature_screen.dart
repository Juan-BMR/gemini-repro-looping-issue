import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart'; // Add uuid package to pubspec.yaml
import '../providers/feature_providers.dart';
import '../../domain/entities/feature_entity.dart';

class EditFeatureScreen extends ConsumerStatefulWidget {
  final FeatureEntity? feature; // Null if adding new, non-null if editing

  const EditFeatureScreen({this.feature, super.key});

  @override
  ConsumerState<EditFeatureScreen> createState() => _EditFeatureScreenState();
}

class _EditFeatureScreenState extends ConsumerState<EditFeatureScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  // Labels are managed on the detail screen in this setup
  // late List<String> _labels;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.feature?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.feature?.description ?? '');
    // Initialize labels based on existing feature or empty list
    // _labels = List<String>.from(widget.feature?.labels ?? []);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveFeature() {
    // Ensure form is valid before proceeding
    if (_formKey.currentState?.validate() ?? false) {
      final String id = widget.feature?.id ??
          const Uuid().v4(); // Use existing ID or generate new
      // Use labels from the original feature if editing, or empty list if new
      final List<String> currentLabels = widget.feature?.labels ?? [];

      final updatedFeature = FeatureEntity(
        id: id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        labels: currentLabels, // Preserve existing labels
      );

      // Call the updater provider
      ref.read(featureUpdaterProvider)(updatedFeature).then((_) {
        // Check if the widget is still mounted before popping
        if (!mounted) return;
        // Pop back to the previous screen (either home or detail)
        Navigator.pop(context);
        // If coming from DetailScreen, it might have been replaced,
        // so popping once should be sufficient.

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Feature "${updatedFeature.name}" saved.')));
      }).catchError((e, s) {
        // Show error message if saving fails
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error saving feature: $e')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.feature == null ? 'Add New Feature' : 'Edit Feature'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save Feature', // Add tooltip
            onPressed: _saveFeature, // Call save method
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associate form key
          child: SingleChildScrollView(
            // Allow scrolling for smaller screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Feature Name',
                    hintText: 'Enter a concise name',
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe the feature',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4, // Allow more lines for description
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Indication that labels are managed elsewhere
                Card(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.5),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(
                                'Labels are managed on the Feature Details screen after saving.')),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
