import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../Models/registermodels.dart';

/// A service class for handling user registration via the API.
///
/// This class provides a method to register a new user by sending their
/// information along with an optional profile image to the API endpoint.
///
/// **Actions:**
/// - [register]: Sends a multipart request to the API to register a user with the provided
///   [registerRequestModel] and optional [imageFile], returning a success or error message.
///
/// **Variables:**
/// - [url]: The API endpoint URL for user registration.
/// - [request]: The multipart request object that contains user data and the image file if provided.
/// - [response]: The HTTP response received from the API after sending the registration request.
/// - [responseBody]: The raw response body returned by the API as a string.
/// - [jsonResponse]: The decoded JSON response body containing the result of the registration request.
/// - [errors]: A map of validation errors returned by the API, if any.
/// - [emailError]: The specific error message related to the email field.
/// - [phoneError]: The specific error message related to the phone field.
/// - [identificationError]: The specific error message related to the identification number field.
/// - [errorMessage]: The aggregated error message to be returned if there are validation errors.
class UserRegistrationAPIService {
  Future<String> register(
      RegisterRequestmodel registerRequestModel, File? imageFile) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/registration";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['app_name'] = 'ndc';
      request.fields['full_name'] = registerRequestModel.fullName;
      request.fields['organization'] = registerRequestModel.organization;
      request.fields['designation'] = registerRequestModel.designation;
      request.fields['identification_number'] = registerRequestModel.NID;
      request.fields['email'] = registerRequestModel.email;
      request.fields['phone'] = registerRequestModel.phone;
      request.fields['password'] = registerRequestModel.password;
      request.fields['password_confirmation'] = registerRequestModel.confirmPassword;
      request.fields['user_type'] = registerRequestModel.userType;

      if (imageFile != null) {
        var imageStream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('photo', imageStream, length,
            filename: imageFile.path.split('/').last);

        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print('User registered successfully!');
        print(jsonResponse['message']);
        return jsonResponse['message'];
      } else {
        var responseBody = await response.stream.bytesToString();
        print(responseBody);
        var jsonResponse = jsonDecode(responseBody);
        print('Failed to register user: $jsonResponse');

        if (jsonResponse.containsKey('errors')) {
          var errors = jsonResponse['errors'];
          print(errors);
          var emailError = errors.containsKey('email') ? errors['email'][0] : '';
          var phoneError = errors.containsKey('phone') ? errors['phone'][0] : '';
          var identificationError = errors.containsKey('identification_number') ? errors['identification_number'][0] : '';

          var errorMessage = '';
          if (emailError.isNotEmpty) errorMessage = emailError;
          if (phoneError.isNotEmpty) errorMessage = phoneError;
          if (identificationError.isNotEmpty) errorMessage = identificationError;

          print(errorMessage);
          return errorMessage;}
        else {
          print('Failed to register user: $responseBody');
          return 'Failed to register user. Please try again.';
        }
      }
    } catch (e) {
      print('Error occurred while registering user: $e');
      return 'Failed to register user. Please try again.';
    }
  }
}
