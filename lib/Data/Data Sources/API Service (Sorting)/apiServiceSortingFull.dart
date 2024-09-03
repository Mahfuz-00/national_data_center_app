import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for handling full data filtering through the API.
///
/// This class provides functionality to filter full data based on specified
/// criteria such as date, time, sector, and a specific URL for the request.
///
/// **Actions:**
/// - [filterFullData]: Sends a POST request to the specified [url] with the
///   provided [date], [time], and [sector], returning the filtered data as a
///   map if successful.
///
/// **Variables:**
/// - [authToken]: The authentication token required for making API requests.
/// - [response]: The HTTP response received from the API after sending the
///   filter request.
/// - [jsonData]: The decoded JSON response body containing the filtered data
///   returned by the API.
class SortingFullAPIService {
  late final String authToken;

  SortingFullAPIService._();

  static Future<SortingFullAPIService> create() async {
    var apiService = SortingFullAPIService._();
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

  Future<Map<String, dynamic>> filterFullData(String date, String time, String sector, String url) async {
    print(date);
    print(time);
    print(sector);
    print(url);
    try {
      if (authToken.isEmpty) {
        throw Exception('Authentication token is empty.');
      }

      final response = await http.post(
        Uri.parse(url),
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
