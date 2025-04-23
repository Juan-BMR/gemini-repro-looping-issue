import 'package:equatable/equatable.dart';

class FeatureEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> labels;

  const FeatureEntity({
    required this.id,
    required this.name,
    required this.description,
    this.labels = const [],
  });

  @override
  List<Object?> get props => [id, name, description, labels];
}
