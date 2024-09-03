import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class for managing access acceptance and rejection requests.
///
/// This class handles accepting or rejecting connection requests through the API.
/// It manages the authentication token required for authorized requests.
///
/// **Actions:**
/// - [create]: Initializes the service and loads the authentication token.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [acceptOrRejectConnection]: Sends a request to accept or reject a connection
///   based on the specified type and application ID.
///
/// **Variables:**
/// - [URL]: The base URL for the API.
/// - [authToken]: The authentication token used for authorized API requests.
/// - [type]: The type of action being performed (accepted or rejected).
/// - [ApplicationId]: The ID of the application being accepted or rejected.
/// - [url]: The endpoint URL for accepting or rejecting appointments.
/// - [response]: The HTTP response received from the API after processing the request.
class AccessAcceptRejectAPIService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  AccessAcceptRejectAPIService._();

  static Future<AccessAcceptRejectAPIService> create() async {
    var apiService = AccessAcceptRejectAPIService._();
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

  Future<void> acceptOrRejectConnection({required String type, required int ApplicationId,}) async {
    final String url = '$URL/ndc/appointment/accept/or/reject';

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final Map<String, dynamic> body = {
      "type": type,
      "appointment_id": ApplicationId,
    };

    print(body);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Application accepted/rejected successfully');
        if (type.toLowerCase() == 'accepted') {
          print('Application accepted');
        } else if (type.toLowerCase() == 'rejected') {
          print('Application declined');
        }
      } else {
        print('Failed to accept/reject Application. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error accepting/rejecting Application: $e');
    }
  }
}
