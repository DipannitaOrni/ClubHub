// lib/services/recommendation_service.dart
// Service to fetch recommendations from Python API

import 'dart:convert';
import 'package:http/http.dart' as http;

class RecommendationService {
  // IMPORTANT: Change this to your API URL
  // For local testing: 'http://localhost:5000'
  // For production: 'https://your-api-url.com'
  static const String baseUrl = 'http://localhost:5000';

  /// Get recommended events for a student
  ///
  /// [studentUid] - Firebase UID of the student
  /// [topN] - Number of recommendations to fetch (default: 10)
  ///
  /// Returns a list of event IDs or empty list if error
  static Future<List<String>> getRecommendations(
    String studentUid, {
    int topN = 10,
  }) async {
    try {
      final url =
          Uri.parse('$baseUrl/api/recommendations/$studentUid?top_n=$topN');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Extract recommendations array
        final recommendations = data['recommendations'] as List<dynamic>?;

        if (recommendations == null || recommendations.isEmpty) {
          print('No recommendations returned for student $studentUid');
          return [];
        }

        // Convert to event IDs
        final eventIds =
            recommendations.map((rec) => rec['eventId'] as String).toList();

        return eventIds;
      } else if (response.statusCode == 404) {
        print('Student not found: $studentUid');
        return [];
      } else {
        print('Error fetching recommendations: ${response.statusCode}');
        print('Response: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Exception while fetching recommendations: $e');
      return [];
    }
  }

  /// Get full recommendation response with metadata
  ///
  /// Returns complete response including student info and recommendation type
  static Future<Map<String, dynamic>?> getRecommendationsWithMetadata(
    String studentUid, {
    int topN = 10,
  }) async {
    try {
      final url =
          Uri.parse('$baseUrl/api/recommendations/$studentUid?top_n=$topN');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  /// Refresh the recommendation system (after adding new events)
  static Future<bool> refreshRecommendations() async {
    try {
      final url = Uri.parse('$baseUrl/api/refresh');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      return response.statusCode == 200;
    } catch (e) {
      print('Exception while refreshing: $e');
      return false;
    }
  }

  /// Get system statistics
  static Future<Map<String, dynamic>?> getStats() async {
    try {
      final url = Uri.parse('$baseUrl/api/stats');

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Exception while fetching stats: $e');
      return null;
    }
  }

  /// Check if recommendation API is available
  static Future<bool> isApiAvailable() async {
    try {
      final url = Uri.parse('$baseUrl/health');

      final response = await http.get(url).timeout(const Duration(seconds: 3));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
