import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling data filtering through the API.
///
/// This class provides functionality to filter data based on specified
/// criteria such as date, time, and sector.
///
/// **Actions:**
/// - [filterData]: Sends a POST request to the API with the specified
///   [date], [time], and [sector], returning the filtered data as a
///   map if successful.
///
/// **Variables:**
/// - [baseUrl]: The base URL for the API endpoint.
/// - [authToken]: The authentication token required for making API requests.
/// - [response]: The HTTP response received from the API after sending the filter request.
/// - [jsonData]: The decoded JSON response body containing the filtered data returned by the API.
class SortingAPIService {
  final String baseUrl = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  SortingAPIService._();

  static Future<SortingAPIService> create() async {
    var apiService = SortingAPIService._();
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

  Future<Map<String, dynamic>> filterData(String date, String time, String sector) async {
    try {
      if (authToken.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/ndc/filter/data'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'date': date,
          'time': time,
          'sector': sector,
        }),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('Filter Data Response: $jsonData');
        return jsonData;
      } else {
        throw Exception('Failed to filter data');
      }
    } catch (e) {
      throw Exception('Error filtering data: $e');
    }
  }
}
