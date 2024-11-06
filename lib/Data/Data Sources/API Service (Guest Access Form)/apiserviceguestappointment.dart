import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/ConnectionGuestModel.dart';
import 'package:path/path.dart';

/// A service class for handling guest appointment requests via API.
///
/// This class manages the authentication token and provides a method
/// to send guest appointment requests along with a document file.
///
/// **Actions:**
/// - [create]: Initializes the service and loads the authentication token.
/// - [_loadAuthToken]: Loads the authentication token from shared preferences.
/// - [postConnectionRequest]: Sends a guest appointment request to the API
///   with the provided request data and optional document file.
///
/// **Variables:**
/// - [URL]: The base URL for the API endpoint.
/// - [authToken]: The authentication token required for authorized API requests.
/// - [token]: The authentication token used for making requests.
/// - [uri]: The URI for the guest appointment API endpoint.
/// - [requestMultipart]: The multipart request object for sending data.
/// - [streamedResponse]: The streamed response received from the API after sending the request.
/// - [response]: The HTTP response received from the API after sending the appointment request.
/// - [jsonResponse]: The decoded JSON response body containing the result of the appointment request.
class GuestAppointmentRequestAPIService {
  final String URL = 'https://bcc.touchandsolve.com/api';
  //late final Future<String> authToken;

  GuestAppointmentRequestAPIService._();

  static Future<GuestAppointmentRequestAPIService> create() async {
    var apiService = GuestAppointmentRequestAPIService._();
    await apiService._loadAuthToken();
    print('triggered API');
    return apiService;
  }

  GuestAppointmentRequestAPIService() {
   // authToken = _loadAuthToken();
    print('triggered');
  }

  Future<String> _loadAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Load Token');
    print(token);
    return token;
  }

  Future<String> postConnectionRequest(GuestAppointmentModel request, File? documentFile) async {
   // final String token = await authToken;
    try {
     /* if (token.isEmpty) {
        await _loadAuthToken();
        throw Exception('Authentication token is empty.');
      }*/

      var uri = Uri.parse('$URL/ndc/guest/appointment');
      var requestMultipart = http.MultipartRequest('POST', uri);

      //requestMultipart.headers['Authorization'] = 'Bearer $token';
      requestMultipart.headers['Content-Type'] = 'multipart/form-data';

      request.toJson().forEach((key, value) {
        requestMultipart.fields[key] = value.toString();
      });

      if (documentFile != null) {
        requestMultipart.files.add(await http.MultipartFile.fromPath(
          'document_file',
          documentFile.path,
          filename: basename(documentFile.path),
        ));
      }

      var streamedResponse = await requestMultipart.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(response.body);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('Connection request sent successfully.');
        return jsonResponse['message'];
      } else {
        print('Failed to send connection request. Status code: ${response.statusCode}');
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('errors')) {
          var errors = jsonResponse['errors'];
          print(errors);
          var documentFileError = errors.containsKey('document_file') ? errors['document_file'][0] : '';

          var errorMessage = '';
          if (documentFileError.isNotEmpty) errorMessage = documentFileError;

          print(errorMessage);
          return errorMessage;}
        return 'Failed to send connection request';
      }
    } catch (e) {
      print('Error sending connection request: $e');
      return 'Error sending connection request';
    }
  }
}
