import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIServiceNDCPDF {
  static const String baseURL = 'https://bcc.touchandsolve.com/api/ndc/pdf';
  late final String authToken;

  APIServiceNDCPDF._();

  static Future<APIServiceNDCPDF> create() async {
    var apiService = APIServiceNDCPDF._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

/*  APIService() {
    _loadAuthToken();
    print('triggered');
  }*/

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
    print('Load Token');
    print(prefs.getString('token'));
  }

  Future<Map<String, dynamic>> generatePDF({
    required int id,
    required String time,
  }) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        throw Exception('Authentication token is empty.');
      }
      final response = await http.post(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(<String, String>{
          'id': id.toString(),
          'time': time,
        }),
      );

      if (response.statusCode == 200) {
        // Request successful, parse response data if needed
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Request failed
        throw Exception('Failed to generate PDF: ${response.reasonPhrase}');
      }
    } catch (e) {
      final response = await http.post(
        Uri.parse(baseURL),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(<String, String>{
          'id': id.toString(),
          'time': time,
        }),
      );
      print(response.statusCode);
      print(response.body);
      // Error during HTTP request
      throw Exception('Failed to generate PDF: $e');
    }
  }
}
