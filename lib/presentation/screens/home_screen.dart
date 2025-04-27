import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/feature_providers.dart';
import 'edit_feature_screen.dart';
import 'feature_detail_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuresAsyncValue = ref.watch(featureListProvider);
    final allLabelsAsyncValue = ref.watch(allUniqueLabelsProvider);
    final selectedLabels = ref.watch(selectedLabelsFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Features'),
        actions: [
          if (selectedLabels.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.filter_list_off),
              tooltip: 'Clear Filters',
              onPressed: () =>
                  ref.read(selectedLabelsFilterProvider.notifier).state = {},
            ),
        ],
      ),
      body: Column(
        children: [
          allLabelsAsyncValue.when(
            data: (labels) => labels.isEmpty && selectedLabels.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: [
                        if (labels.isEmpty && selectedLabels.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Chip(
                              label: Text(
                                  'Filtering by: ${selectedLabels.join(', ')}'),
                              avatar: Icon(Icons.warning_amber_rounded,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ...labels.map((label) {
                          final isSelected = selectedLabels.contains(label);
                          return FilterChip(
                            label: Text(label),
                            selected: isSelected,
                            onSelected: (selected) {
                              ref
                                  .read(selectedLabelsFilterProvider.notifier)
                                  .update((state) {
                                final newState = Set<String>.from(state);
                                selected
                                    ? newState.add(label)
                                    : newState.remove(label);
                                return newState;
                              });
                            },
                          );
                        }),
                      ],
                    ),
                  ),
            loading: () => const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(child: Text("Loading labels...")),
            ),
            error: (err, stack) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Error loading labels: $err',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          ),
          if (allLabelsAsyncValue.hasValue &&
              (allLabelsAsyncValue.value!.isNotEmpty ||
                  selectedLabels.isNotEmpty))
            const Divider(height: 1),
          Expanded(
            child: featuresAsyncValue.when(
              data: (features) => features.isEmpty
                  ? Center(
                      child: Text(selectedLabels.isNotEmpty
                          ? 'No features match the selected labels.'
                          : 'No features yet. Tap + to add one!'),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(featureListProvider);
                        ref.invalidate(allUniqueLabelsProvider);
                        await Future.delayed(const Duration(milliseconds: 500));
                      },
                      child: ListView.builder(
                        itemCount: features.length,
                        itemBuilder: (context, index) {
                          final feature = features[index];
                          return _FeatureListItem(feature: feature);
                        },
                      ),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                  child: Text('Error loading features: $err',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error))),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Add Feature',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditFeatureScreen()),
          );
        },
      ),
    );
  }
}

class _FeatureListItem extends StatelessWidget {
  final dynamic feature;

  const _FeatureListItem({required this.feature});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Tooltip(
        message: feature.priority.toString().split('.').last,
        child: Chip(
          label: Text(
            feature.priority.toString().split('.').last[0].toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          visualDensity: VisualDensity.compact,
        ),
      ),
      title: Text(feature.name),
      subtitle: Text(feature.description,
          maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: feature.labels.isNotEmpty
          ? Wrap(
              spacing: 4.0,
              runSpacing: 2.0,
              children: feature.labels
                  .take(3)
                  .map((l) => Chip(
                      label: Text(l),
                      padding: EdgeInsets.zero,
                      labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      visualDensity: VisualDensity.compact))
                  .toList(),
            )
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FeatureDetailScreen(featureId: feature.id),
          ),
        );
      },
    );
  }
}
