import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for fetching full items from a specified API endpoint.
///
/// This class manages the authentication token and provides a method
/// to fetch full items from the given URL.
///
/// **Actions:**
/// - [create]: Initializes the service and loads the authentication token.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [fetchFullItems]: Fetches full items by making an API call to the specified URL.
///
/// **Variables:**
/// - [authToken]: The authentication token required for authorized API requests.
/// - [token]: The authentication token used for making requests.
/// - [response]: The HTTP response received from the API after fetching full items.
/// - [jsonData]: The decoded JSON response body containing the full items.
class FullDashboardAPIService {
  late final String authToken;

  FullDashboardAPIService._();

  static Future<FullDashboardAPIService> create() async {
    var apiService = FullDashboardAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> fetchFullItems(String url) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } else {
        throw Exception('Failed to load dashboard items');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard items: $e');
    }
  }
}
