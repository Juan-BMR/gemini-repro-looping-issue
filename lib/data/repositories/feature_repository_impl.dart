import 'package:flutter_clean_app/data/datasources/feature_remote_datasource.dart';
import 'package:flutter_clean_app/data/models/feature_model.dart';
import 'package:flutter_clean_app/domain/entities/feature_entity.dart';
import 'package:flutter_clean_app/domain/repositories/feature_repository.dart';
// Import ServerException if needed, assume it's handled/defined elsewhere
// Import NetworkInfo or similar for connectivity check if needed

class FeatureRepositoryImpl implements FeatureRepository {
  final FeatureRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // Optional: Add connectivity check

  FeatureRepositoryImpl(
      {required this.remoteDataSource /*, required this.networkInfo */});

  @override
  Future<List<FeatureEntity>> getFeatures({List<String>? labels}) async {
    // Optional: Check connectivity
    // if (await networkInfo.isConnected) {
    try {
      // Call the datasource method that now accepts labels
      final List<FeatureModel> featureModels =
          await remoteDataSource.getAllFeatures(labels: labels);
      // Convert models to entities (direct mapping since model extends entity)
      return featureModels.map((model) => model as FeatureEntity).toList();
    } on ServerException {
      // Handle server errors, maybe return cached data or specific error entity
      // For now, rethrow or return empty list/error
      rethrow; // Or handle appropriately
    }
    // } else {
    // Handle no connection: throw NoConnectionException() or return cached data
    // throw NoConnectionException();
    // }
  }

  @override
  Future<FeatureEntity?> getFeatureById(String id) async {
    try {
      final FeatureModel featureModel = await remoteDataSource.getFeature(id);
      return featureModel as FeatureEntity; // Direct cast
    } on ServerException {
      // Handle appropriately
      return null; // Or rethrow
    }
    // Handle connectivity etc. as above
  }

  @override
  Future<void> saveFeature(FeatureEntity feature) async {
    try {
      // Convert entity to model
      // If FeatureModel constructor requires all fields, ensure they are present
      final featureModel = FeatureModel(
        id: feature.id,
        name: feature.name,
        description: feature.description,
        labels: feature.labels,
      );
      await remoteDataSource.saveFeature(featureModel);
    } on ServerException {
      rethrow;
    }
    // Handle connectivity etc. as above
  }

  @override
  Future<void> deleteFeature(String id) async {
    try {
      await remoteDataSource.deleteFeature(id);
    } on ServerException {
      rethrow;
    }
    // Handle connectivity etc. as above
  }

  @override
  Future<List<String>> getAllUniqueLabels() async {
    try {
      return await remoteDataSource.getAllUniqueLabels();
    } on ServerException {
      rethrow;
    }
    // Handle connectivity etc. as above
  }
}
