import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../Models/registermodels.dart';

class APIService {
  Future<String> register(
      RegisterRequestmodel registerRequestModel, File? imageFile) async {
    try {
      String url = "https://bcc.touchandsolve.com/api/registration";

      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add user data fields to the request
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

      // Add the image file to the request if it is not null
      if (imageFile != null) {
        var imageStream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile('photo', imageStream, length,
            filename: imageFile.path.split('/').last);

        request.files.add(multipartFile);
      }

      // Send the request and await the response
      var response = await request.send();

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Successful registration
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        print('User registered successfully!');
        print(jsonResponse['message']);
        return jsonResponse['message'];
      } else {
        // Handle registration failure
        //print('Failed to register user: ${await response.stream.bytesToString()}');
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
      // Handle any exceptions
      print('Error occurred while registering user: $e');
      return 'Failed to register user. Please try again.';
    }
  }
}
