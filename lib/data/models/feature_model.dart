import 'package:flutter_clean_app/domain/entities/feature_entity.dart';
import 'package:meta/meta.dart'; // Optional, for @required if using older SDKs

class FeatureModel extends FeatureEntity {
  const FeatureModel({
    required String id,
    required String name,
    required String description,
  }) : super(id: id, name: name, description: description);

  // Example factory constructor for JSON deserialization
  factory FeatureModel.fromJson(Map<String, dynamic> json) {
    // Basic validation example
    if (json['id'] == null ||
        json['name'] == null ||
        json['description'] == null) {
      throw ArgumentError('Missing required fields in FeatureModel JSON');
    }
    return FeatureModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  // Example method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
