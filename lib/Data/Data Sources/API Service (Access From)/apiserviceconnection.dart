import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/connectionmodel.dart';

/// A service class for managing appointment connection requests.
///
/// This class handles sending appointment connection requests through the API.
/// It manages the authentication token required for authorized requests.
///
/// **Actions:**
/// - [create]: Initializes the service and loads the authentication token.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [postConnectionRequest]: Sends a request to create a new appointment connection
///   using the provided appointment request model.
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: A future that resolves to the authentication token used for authorized API requests.
/// - [token]: The authentication token retrieved from shared preferences.
/// - [request]: The appointment request model containing the necessary data for the connection request.
/// - [response]: The HTTP response received from the API after processing the request.
/// - [jsonResponse]: The decoded JSON response body from the API containing the message.
class AppointmentRequestAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final Future<String> authToken;

  AppointmentRequestAPIService._();

  static Future<AppointmentRequestAPIService> create() async {
    var apiService = AppointmentRequestAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  AppointmentRequestAPIService() {
    authToken = _loadAuthToken();
    print('triggered');
  }

  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }

  Future<String> postConnectionRequest(AppointmentRequestModel request) async {
    final String token = await authToken;
    try {
      if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final http.Response response = await http.post(
        Uri.parse('$URL/ndc/appointment'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(request.toJson()),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Connection request sent successfully.');
        return jsonResponse['message'];
      } else {
        print('Failed to send connection request. Status code: ${response.statusCode}');
        return 'Failed to send connection request';
      }
    } catch (e) {
      print('Error sending connection request: $e');
      return 'Error sending connection request';
    }
  }
}
