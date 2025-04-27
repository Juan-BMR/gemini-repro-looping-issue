import 'dart:convert';
import 'package:http/http.dart' as http; // Placeholder HTTP client

import '../models/feature_model.dart';
import 'feature_remote_datasource.dart'; // Import the abstract class
// Assume ServerException is defined, e.g., in the abstract class file or core/error

// NOTE: Replace 'http://example.com' with your actual API endpoint
const String _baseUrl = 'http://example.com';

class FeatureRemoteDataSourceImpl implements FeatureRemoteDataSource {
  final http.Client client;

  FeatureRemoteDataSourceImpl({required this.client});

  @override
  Future<FeatureModel> getFeature(String id) async {
    final response = await client.get(
      Uri.parse('$_baseUrl/feature/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return FeatureModel.fromJson(json.decode(response.body));
    } else {
      // TODO: Handle different error status codes appropriately
      throw ServerException();
    }
  }

  // Implement getAllFeatures to handle optional labels
  @override
  Future<List<FeatureModel>> getAllFeatures({List<String>? labels}) async {
    // Build query parameters for labels if provided
    final Map<String, dynamic> queryParameters = {};
    if (labels != null && labels.isNotEmpty) {
      // Assuming the API expects labels as a comma-separated string or repeated query param
      // Adjust 'labels': labels.join(',') based on your API spec
      queryParameters['labels'] = labels.join(',');
    }

    final uri = Uri.parse('$_baseUrl/features')
        .replace(queryParameters: queryParameters);

    final response = await client.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList
          .map((jsonItem) => FeatureModel.fromJson(jsonItem))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> saveFeature(FeatureModel feature) async {
    // Determine if it's an update (PUT/PATCH) or create (POST) based on ID or API design
    // This example assumes POST for create, PUT for update (if ID exists)
    // Adjust logic and endpoint as needed.

    final url = feature.id.isNotEmpty
        ? '$_baseUrl/feature/${feature.id}' // Assuming PUT for update
        : '$_baseUrl/feature'; // Assuming POST for create

    final method = feature.id.isNotEmpty ? client.put : client.post;

    final response = await method(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body:
          json.encode(feature.toJson()), // Send the full model including labels
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      // 201 for created
      throw ServerException();
    }
  }

  @override
  Future<void> deleteFeature(String id) async {
    final response = await client.delete(
      Uri.parse('$_baseUrl/feature/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      // 204 for no content
      throw ServerException();
    }
  }

  // Implement getAllUniqueLabels (assuming an API endpoint exists)
  @override
  Future<List<String>> getAllUniqueLabels() async {
    // Adjust the endpoint '/labels' based on your API design
    final response = await client.get(
      Uri.parse('$_baseUrl/labels'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      // Assuming the API returns a list of strings
      return jsonList.map((label) => label.toString()).toList();
    } else {
      throw ServerException();
    }
  }
}
