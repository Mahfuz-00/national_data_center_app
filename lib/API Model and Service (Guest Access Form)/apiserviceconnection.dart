import 'dart:convert';
import 'dart:io'; // Add this import for handling files
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'connectionmodel.dart';
import 'package:path/path.dart'; // Add this import for getting the file name

class APIServiceGuestAppointmentRequest {
  final String URL = 'https://bcc.touchandsolve.com/api';
  late final Future<String> authToken;

  APIServiceGuestAppointmentRequest._();

  static Future<APIServiceGuestAppointmentRequest> create() async {
    var apiService = APIServiceGuestAppointmentRequest._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  APIServiceGuestAppointmentRequest() {
    authToken = _loadAuthToken(); // Assigning the future here
    print('triggered');
  }

  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }

  Future<String> postConnectionRequest(GuestAppointmentRequestModel request, File? documentFile) async {
    final String token = await authToken; // Wait for the authToken to complete
    try {
      if (token.isEmpty) {
        // Wait for authToken to be initialized
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }

      var uri = Uri.parse('$URL/ndc/guest/appointment');
      var requestMultipart = http.MultipartRequest('POST', uri);

      requestMultipart.headers['Authorization'] = 'Bearer $token';
      requestMultipart.headers['Content-Type'] = 'multipart/form-data';

      // Add text fields
      request.toJson().forEach((key, value) {
        requestMultipart.fields[key] = value.toString();
      });

      // Add file
      requestMultipart.files.add(await http.MultipartFile.fromPath(
        'document_file', // The field name for the file parameter
        documentFile!.path,
        filename: basename(documentFile.path), // Optional: you can specify the file name
      ));

      var streamedResponse = await requestMultipart.send();
      var response = await http.Response.fromStream(streamedResponse);

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
