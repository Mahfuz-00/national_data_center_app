import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A service class that handles marking notifications as read by making an API request.
///
/// This class provides methods to mark a notification as read using the stored authentication token.
/// The token is used to authorize the API request.
///
/// **Variables:**
/// - [URL]: The base URL of the API endpoint.
/// - [authToken]: The authentication token used for authorization in the API request.
///
/// **Actions:**
/// - [create]: A factory method that initializes the [PopUpNotificationReadApiService] and loads the [authToken].
/// - [_loadAuthToken]: A private method to load the [authToken] from [SharedPreferences].
/// - [readNotification]: Sends a GET request to the API to mark a notification as read.
///   Accepts [id] to specify the notification. Returns `true` if successful, otherwise `false`.
class PopUpNotificationReadApiService {
  static const String URL = 'https://bcc.touchandsolve.com/api';
  late final String authToken;

  PopUpNotificationReadApiService._();

  static Future<PopUpNotificationReadApiService> create() async {
    var apiService = PopUpNotificationReadApiService._();
    await apiService._loadAuthToken();
    return apiService;
  }

  Future<void> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('token') ?? '';
  }

  /// Marks a specific notification as read by sending a GET request to the API.
  ///
  /// **Parameters:**
  /// - [id]: The ID of the notification to mark as read.
  ///
  /// **Returns:**
  /// - `true` if the request is successful, `false` otherwise.
  Future<bool> readNotification(var id) async {
    try {
      if (authToken.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      final response = await http.get(
        Uri.parse('$URL/ndc/notification/read/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        print('Notification Read!!');
        return true;
      } else {
        print(response.body);
        print('Failed to read Notification: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      final response = await http.post(
        Uri.parse('$URL/ndc/notification/read/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken'
        },
      );
      print(response.body);
      print('Exception While Reading Notification: $e');
      return false;
    }
  }
}
