import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footer/footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity/connectivity.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Sign Up)/apiserviceregister.dart';
import '../../../Data/Models/registermodels.dart';
import '../../Widgets/dropdownfield.dart';
import '../Login UI/loginUI.dart';

class SignupUI extends StatefulWidget {
  const SignupUI({super.key});

  @override
  State<SignupUI> createState() => _SignupUIState();
}

class _SignupUIState extends State<SignupUI> {
  bool _isObscuredPassword = true;
  bool _isObscuredConfirmPassword = true;
  late RegisterRequestmodel _registerRequest;
  late TextEditingController _fullNameController;
  late TextEditingController _organizationController;
  late TextEditingController _designationController;
  late TextEditingController _NIDController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String _selectedVisitorType = '';
  File? _imageFile;
  var globalKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalfromkey = GlobalKey<FormState>();
  double _imageHeight = 0;
  double _imageWidth = 0;
  bool _isButtonLoading = false;

  // Function to load image dimensions
  Future<void> _getImageDimensions() async {
    if (_imageFile != null) {
      final data = await _imageFile!.readAsBytes();
      final image = await decodeImageFromList(data);
      setState(() {
        _imageHeight = image.height.toDouble();
        _imageWidth = image.width.toDouble();
      });
    }
  }

  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(child: Text("ndc_internal"), value: "BCC Staff"),
    DropdownMenuItem(child: Text("ndc_customer"), value: "Customer"),
    DropdownMenuItem(child: Text("ndc_vendor"), value: "Vendor"),
  ];

  IconData _getIconPassword() {
    return _isObscuredPassword ? Icons.visibility_off : Icons.visibility;
  }

  IconData _getIconConfirmPassword() {
    return _isObscuredConfirmPassword ? Icons.visibility_off : Icons.visibility;
  }

  @override
  void initState() {
    super.initState();
    _registerRequest = RegisterRequestmodel(
      fullName: '',
      organization: '',
      designation: '',
      NID: '',
      email: '',
      phone: '',
      password: '',
      confirmPassword: '',
      userType: '',
    );
    _fullNameController = TextEditingController();
    _organizationController = TextEditingController();
    _designationController = TextEditingController();
    _NIDController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return InternetConnectionChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Column(children: [
                        const Text(
                          'Hello! Register to get started!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(13, 70, 127, 1),
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Sign in to see how we manage',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 50),
                        Form(
                          key: globalfromkey,
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _fullNameController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your full name';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Full Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _organizationController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your organization name';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Organization Name',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _designationController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your designation';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Designation',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _NIDController,
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your NID number or your passport number';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'NID or Passport Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (input) {
                                    if (input!.isEmpty) {
                                      return 'Please enter your email address';
                                    }
                                    final emailRegex = RegExp(
                                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(input)) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    // Only allow digits
                                    LengthLimitingTextInputFormatter(11),
                                  ],
                                  validator: (input) {
                                    if (input == null || input.isEmpty) {
                                      return 'Please enter your mobile number name';
                                    }
                                    if (input.length != 11) {
                                      return 'Mobile number must be 11 digits';
                                    }
                                    return null; // Return null if the input is valid
                                  },
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Mobile Number',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input)=> _registerRequest.Password = input!,
                                  validator: (input) => input!.length < 8
                                      ? "Password should be more than 7 characters"
                                      : null,
                                  controller: _passwordController,
                                  obscureText: _isObscuredPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredPassword =
                                              !_isObscuredPassword;
                                          _passwordController.text =
                                              _passwordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: screenWidth * 0.9,
                                height: 70,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  //onSaved: (input)=> _registerRequest.Password = input!,
                                  validator: (input) => input!.length < 8
                                      ? "Password should be more than 7 characters"
                                      : null,
                                  controller: _confirmPasswordController,
                                  obscureText: _isObscuredConfirmPassword,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(),
                                    labelText: 'Confirm Password',
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'default',
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_getIconConfirmPassword()),
                                      onPressed: () {
                                        setState(() {
                                          _isObscuredConfirmPassword =
                                              !_isObscuredConfirmPassword;
                                          _confirmPasswordController.text =
                                              _confirmPasswordController.text;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              //const SizedBox(height: 5),
                              DropdownFormField(
                                hintText: 'Visitor Type',
                                dropdownItems: dropdownItems,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == 'BCC Staff') {
                                      _selectedVisitorType =
                                          'ndc_internal' ?? '';
                                    }
                                    if (value == 'Customer') {
                                      _selectedVisitorType =
                                          'ndc_customer' ?? '';
                                    }
                                    if (value == 'Vendor') {
                                      _selectedVisitorType = 'ndc_vendor' ?? '';
                                    }
                                    //print('New: $_selectedUserType');
                                  });
                                },
                              ),
                              const SizedBox(height: 15),
                              Container(
                                width: (_imageWidth != 0
                                    ? (_imageWidth + 10)
                                        .clamp(0, screenWidth * 0.9)
                                    : screenWidth * 0.9),
                                height: (_imageHeight != 0
                                    ? (_imageHeight + 10).clamp(0, 200)
                                    : 80),
                                child: InkWell(
                                  onTap: _selectImage,
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderSide: Divider.createBorderSide(
                                              context)),
                                      labelText: 'Add Profile Picture',
                                      labelStyle: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'default',
                                      ),
                                      errorMaxLines: null,
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .red), // Customize error border color
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _imageFile != null
                                              ? Image.file(
                                                  _imageFile!,
                                                  width: null,
                                                  height: null,
                                                  fit: BoxFit.contain,
                                                )
                                              : Icon(Icons.image,
                                                  size: 60, color: Colors.grey),
                                        ),
                                        SizedBox(width: 8),
                                        VerticalDivider(
                                          thickness: 5,
                                        ),
                                        Text(
                                          'Upload',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(13, 70, 127, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            fontFamily: 'default',
                                          ),
                                        ),
                                        // Customize upload text style
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(13, 70, 127, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              fixedSize: Size(screenWidth * 0.9, 70),
                            ),
                            child: _isButtonLoading
                                ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                : const Text('Register',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'default',
                                    ))),
                      ])),
                      Footer(
                        backgroundColor: Color.fromRGBO(246, 246, 246, 255),
                        alignment: Alignment.bottomCenter,
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?  ',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromRGBO(143, 150, 158, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => LoginUI()));
                                  },
                                  child: const Text(
                                    'Login now',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color.fromRGBO(13, 70, 127, 1),
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _registerUser() {
    setState(() {
      _isButtonLoading =
      true; // Validation complete, hide circular progress indicator
    });
    if (validateAndSave() && checkConfirmPassword()) {
      const snackBar = SnackBar(
        content: Text('Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      final registerRequest = RegisterRequestmodel(
        fullName: _fullNameController.text,
        organization: _organizationController.text,
        designation: _designationController.text,
        NID: _NIDController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        userType: _selectedVisitorType,
      );

      final apiService = UserRegistrationAPIService();
      // Call register method passing registerRequestModel, _imageFile, and authToken
      apiService.register(registerRequest, _imageFile).then((response) {
        print("Submitted");
        if (response != null &&
            response ==
                "User Registration Successfully.") {
          setState(() {
            _isButtonLoading =
                false; // Validation complete, hide circular progress indicator
          });
          clearForm();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginUI()),
          );
          const snackBar = SnackBar(
            content: Text('Registration Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (response != null &&
            response == "The email has already been taken.") {
          setState(() {
            _isButtonLoading = false;
          });
          const snackBar = SnackBar(
            content: Text(
                'The Email is Taken!, Please Try entering a different Email'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (response != null &&
            response == "The phone has already been taken.") {
          setState(() {
            _isButtonLoading = false;
          });
          const snackBar = SnackBar(
            content: Text(
                'The Phone Number is Taken!, Please Try a different Number'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }else if (response != null &&
            response == "The identification number has already been taken.") {
          setState(() {
            _isButtonLoading = false;
          });
          const snackBar = SnackBar(
            content: Text(
                'The NID or Passport Number is Taken!, Please Try a different Number'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          setState(() {
            _isButtonLoading = false;
          });
          const snackBar = SnackBar(
            content: Text('Registration Failed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        setState(() {
          _isButtonLoading = false;
        });
        // Handle registration error
        print(error);
        const snackBar = SnackBar(
          content: Text('Registration failed!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else {
      setState(() {
        _isButtonLoading =
            false; // Validation complete, hide circular progress indicator
      });
      if(_passwordController.text != _confirmPasswordController.text){
        const snackBar = SnackBar(
          content: Text('Passwords do not match'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        const snackBar = SnackBar(
          content: Text('Fill all Fields'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  bool validateAndSave() {
    final form = globalfromkey.currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool checkConfirmPassword() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _getImageDimensions();
    }
  }

  void clearForm() {
    _fullNameController.clear();
    _organizationController.clear();
    _designationController.clear();
    _NIDController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
    setState(() {
      _selectedVisitorType = '';
      _imageFile = null;
    });
  }
}
