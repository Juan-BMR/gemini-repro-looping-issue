import 'package:equatable/equatable.dart';

class FeatureEntity extends Equatable {
  final String id;
  final String name;
  final String description;

  const FeatureEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, description];
}
