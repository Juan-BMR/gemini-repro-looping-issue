import '../entities/feature_entity.dart';

abstract class FeatureRepository {
  Future<List<FeatureEntity>> getFeatures({List<String>? labels});
  Future<FeatureEntity?> getFeatureById(String id);
  Future<void> saveFeature(FeatureEntity feature);
  Future<void> deleteFeature(String id);
  Future<List<String>> getAllUniqueLabels(); // New method for labels
}
