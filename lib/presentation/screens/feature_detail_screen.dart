import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feature_providers.dart';
import '../../domain/entities/feature_entity.dart';
import 'edit_feature_screen.dart'; // Import edit screen

class FeatureDetailScreen extends ConsumerStatefulWidget {
  final String featureId;
  const FeatureDetailScreen({required this.featureId, super.key});

  @override
  ConsumerState<FeatureDetailScreen> createState() =>
      _FeatureDetailScreenState();
}

class _FeatureDetailScreenState extends ConsumerState<FeatureDetailScreen> {
  final TextEditingController _labelController = TextEditingController();

  void _addLabel(FeatureEntity feature) {
    final labelText = _labelController.text.trim();
    if (labelText.isNotEmpty) {
      // Convert both to lowercase for case-insensitive comparison
      final existingLabelsLower =
          feature.labels.map((l) => l.toLowerCase()).toSet();
      if (!existingLabelsLower.contains(labelText.toLowerCase())) {
        final updatedLabels = List<String>.from(feature.labels)..add(labelText);
        final updatedFeature = FeatureEntity(
          id: feature.id,
          name: feature.name,
          description: feature.description,
          labels: updatedLabels,
        );
        // Use the updater provider to save
        ref.read(featureUpdaterProvider)(updatedFeature).catchError((e, s) {
          // Add error handling
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Error adding label: $e')));
        });
        _labelController.clear(); // Clear input field
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Label "$labelText" already exists.')));
      }
    }
  }

  void _removeLabel(FeatureEntity feature, String labelToRemove) {
    final updatedLabels = List<String>.from(feature.labels)
      ..remove(labelToRemove);
    final updatedFeature = FeatureEntity(
      id: feature.id,
      name: feature.name,
      description: feature.description,
      labels: updatedLabels,
    );
    // Use the updater provider to save
    ref.read(featureUpdaterProvider)(updatedFeature).catchError((e, s) {
      // Add error handling
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error removing label: $e')));
    });
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the specific feature provider
    final featureAsyncValue = ref.watch(featureProvider(widget.featureId));

    return Scaffold(
      appBar: AppBar(
        // Update title dynamically based on feature loading state
        title: featureAsyncValue.when(
          data: (feature) => Text(
              feature?.name ?? 'Feature Details'), // Handle null case better
          loading: () => const Text('Loading...'),
          error: (err, stack) => const Text('Error'),
        ),
        actions: [
          // Navigate to Edit screen using the fetched feature data
          featureAsyncValue
                  .whenData((feature) => feature != null
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit Feature', // Add tooltip
                          onPressed: () {
                            // Navigate to edit screen, passing the current feature data
                            Navigator.pushReplacement(
                              // Use pushReplacement if edit saves & pops back here
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      EditFeatureScreen(feature: feature)),
                            );
                          },
                        )
                      : null)
                  .valueOrNull ??
              const SizedBox
                  .shrink(), // Handle loading/error/null states gracefully
        ],
      ),
      body: featureAsyncValue.when(
        data: (feature) {
          if (feature == null) {
            // If feature becomes null after loading (e.g., deleted elsewhere), show message
            return const Center(
                child: Text('Feature not found or has been deleted.'));
          }
          // Main content when feature data is available
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              // Make content scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feature.name,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(feature.description,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 20),
                  const Divider(),
                  Text('Labels',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  // Display Labels or a message if none exist
                  feature.labels.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No labels added yet.',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        )
                      : Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: feature.labels
                              .map((label) => Chip(
                                    label: Text(label),
                                    onDeleted: () => _removeLabel(
                                        feature, label), // Call remove function
                                  ))
                              .toList(),
                        ),
                  const SizedBox(height: 16),
                  const Divider(), // Divider before add section
                  const SizedBox(height: 16),
                  // Add Label Input
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align items to top
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _labelController,
                          decoration: const InputDecoration(
                            labelText:
                                'Add New Label', // More descriptive label
                            hintText: 'Enter label name',
                            border: OutlineInputBorder(),
                            // Optional: Add clear button
                            // suffixIcon: _labelController.text.isNotEmpty
                            //     ? IconButton(
                            //         icon: const Icon(Icons.clear),
                            //         onPressed: () => _labelController.clear(),
                            //       )
                            //     : null,
                          ),
                          textInputAction:
                              TextInputAction.done, // Change action button
                          onSubmitted: (_) =>
                              _addLabel(feature), // Add on keyboard submit
                          // Update suffix icon visibility on change
                          // onChanged: (text) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 8), // Add spacing
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0), // Align button slightly better
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                          onPressed: () => _addLabel(feature),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12), // Adjust padding
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
            child: Text('Error loading feature details: $err',
                style: TextStyle(color: Theme.of(context).colorScheme.error))),
      ),
    );
  }
}
