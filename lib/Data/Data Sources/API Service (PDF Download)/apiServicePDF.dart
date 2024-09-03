import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for generating PDF documents via the API.
///
/// This class manages the authentication token and provides a method
/// to generate PDFs based on the provided parameters.
///
/// **Actions:**
/// - [create]: Initializes the service and loads the authentication token.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [generatePDF]: Sends a request to the API to generate a PDF with the given
///   [id] and [time], returning the response data as a map.
///
/// **Variables:**
/// - [baseURL]: The base URL for the PDF generation API endpoint.
/// - [authToken]: The authentication token required for authorized API requests.
/// - [token]: The authentication token used for making requests.
/// - [response]: The HTTP response received from the API after sending the PDF generation request.
/// - [responseData]: The decoded JSON response body containing the result of the PDF generation request.
class PDFGenerateAPIService {
  static const String baseURL = 'https://bcc.touchandsolve.com/api/ndc/pdf';
  late final String authToken;

  PDFGenerateAPIService._();

  static Future<PDFGenerateAPIService> create() async {
    var apiService = PDFGenerateAPIService._();
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
        final responseData = jsonDecode(response.body);
        return responseData;
      } else {
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
      throw Exception('Failed to generate PDF: $e');
    }
  }
}
