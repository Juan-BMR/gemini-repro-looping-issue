import 'package:flutter_clean_app/data/models/feature_model.dart';

abstract class FeatureRemoteDataSource {
  /// Calls the http://example.com/feature/{id} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<FeatureModel> getFeature(String id);

  /// Calls the http://example.com/features endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<FeatureModel>> getAllFeatures();

  /// Calls the http://example.com/feature endpoint with POST.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> saveFeature(FeatureModel feature);

  /// Calls the http://example.com/feature/{id} endpoint with DELETE.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<void> deleteFeature(String id);
}

// Define ServerException if not defined elsewhere
class ServerException implements Exception {}
