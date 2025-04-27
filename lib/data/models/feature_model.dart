import 'package:flutter_clean_app/domain/entities/feature_entity.dart';

class FeatureModel extends FeatureEntity {
  const FeatureModel({
    required String id,
    required String name,
    required String description,
    required List<String> labels,
  }) : super(id: id, name: name, description: description, labels: labels);

  // Example factory constructor for JSON deserialization
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    // Basic validation example
    if (json['id'] == null ||
        json['name'] == null ||
        json['description'] == null) {
      throw ArgumentError('Missing required fields in FeatureModel JSON');
    }
    // Handle potentially missing labels field gracefully
    final List<dynamic>? labelsFromJson = json['labels'] as List<dynamic>?;
    final List<String> labelsList = labelsFromJson
            ?.map((label) => label.toString())
            .toList() ?? // Provide default empty list if null
        [];

    return FeatureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      labels: labelsList, // Assign parsed labels
    );
  }

  // Example method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'labels': labels, // Include labels in JSON
    };
  }
}
