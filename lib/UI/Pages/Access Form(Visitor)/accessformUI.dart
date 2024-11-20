import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Access From)/apiserviceconnection.dart';
import '../../../Data/Models/connectionmodel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/CustomTextField.dart';
import '../../Widgets/dropdownfield.dart';
import '../../Widgets/labelText.dart';
import '../../Widgets/labelTextTemplate.dart';
import '../Visitor Dashboard/visitordashboardUI.dart';

/// The [AccessFormUI] class is a StatefulWidget that represents
/// the user interface for the access request form. It manages
/// user input related to access requests, including personal
/// details, device information, and appointment scheduling.
///
/// **Variables:**
/// - [_scaffoldKey]: A key to control the Scaffold widget.
/// - [_Clockcontroller]: Controller for the appointment time input.
/// - [_Datecontroller]: Controller for the appointment date input.
/// - [_fullnamecontroller]: Controller for the full name input.
/// - [_NIDcontroller]: Controller for the NID or Passport number input.
/// - [_organizationnamecontroller]: Controller for the organization name input.
/// - [_designationcontroller]: Controller for the designation input.
/// - [_phonecontroller]: Controller for the mobile number input.
/// - [_emailcontroller]: Controller for the email address input.
/// - [_commentcontroller]: Controller for the purpose of the visit input.
/// - [_personnelcontroller]: Controller for the names of personnel input.
/// - [_belongscontroller]: Controller for the belongings input.
/// - [_devicemodelcontroller]: Controller for the device model input.
/// - [_deviceserialcontroller]: Controller for the device serial number input.
/// - [_devicedescriptioncontroller]: Controller for the device description input.
/// - [_connectionRequest]: Model for the connection request data.
/// - [appointmentDate]: Stores the selected appointment date.
/// - [appointmentTime]: Stores the selected appointment time.
/// - [_selectedSector]: Holds the selected visiting sector.
/// - [_isVisible]: Controls the visibility of the loading indicator.
///
/// **Actions:**
/// - [loadUserType]: Loads the user type from SharedPreferences.
/// The [connectionRequestForm] method handles the submission of the form data.
class AccessFormUI extends StatefulWidget {
  const AccessFormUI({super.key});

  @override
  State<AccessFormUI> createState() => _AccessFormUIState();
}

class _AccessFormUIState extends State<AccessFormUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _ClockStartTimeController =
      TextEditingController();
  late TextEditingController _ClockEndTimeController = TextEditingController();
  late TextEditingController _DateStartTimeController = TextEditingController();
  late TextEditingController _DateEndTimeController = TextEditingController();
  late TextEditingController _fullnamecontroller;
  late TextEditingController _NIDcontroller;
  late TextEditingController _organizationnamecontroller;
  late TextEditingController _designationcontroller;
  late TextEditingController _phonecontroller;
  late TextEditingController _emailcontroller;
  late TextEditingController _commentcontroller;
  late TextEditingController _belongscontroller;
  late TextEditingController _appointmentwithcontroller;
  late TextEditingController _devicemodelcontroller;
  late TextEditingController _deviceserialcontroller;
  late TextEditingController _devicedescriptioncontroller;
  late AppointmentRequestModel _connectionRequest;
  late String appointmentStartDate = '';
  late String appointmentEndDate = '';
  late String appointmentStartTime = '';
  late String appointmentEndTime = '';
  bool _isButtonClicked = false;
  String _selectedSector = '';
  bool _isVisible = true;
  GlobalKey<FormState> globalformpart1key = GlobalKey<FormState>();
  GlobalKey<FormState> globalformpart2key = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(
        child: Text("Physical Security & Infrastructure"),
        value: "Physical Security & Infrastructure"),
    DropdownMenuItem(child: Text("Network"), value: "Network"),
    DropdownMenuItem(child: Text("Co Location"), value: "Co Location"),
    DropdownMenuItem(child: Text("Server & Cloud"), value: "Server & Cloud"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];

  late String? userType = '';
  String sector = 'Physical Security & Infrastructure';

  Future<void> loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('user');
    print('UserType :: $userType');
  }

  @override
  void initState() {
    super.initState();
    _fullnamecontroller = TextEditingController();
    _NIDcontroller = TextEditingController();
    _organizationnamecontroller = TextEditingController();
    _designationcontroller = TextEditingController();
    _phonecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _commentcontroller = TextEditingController();
    _belongscontroller = TextEditingController();
    _devicemodelcontroller = TextEditingController();
    _deviceserialcontroller = TextEditingController();
    _devicedescriptioncontroller = TextEditingController();
    _appointmentwithcontroller = TextEditingController();
    loadUserType();
    Future.delayed(Duration(seconds: 2), () {
      _connectionRequest = AppointmentRequestModel(
          FullName: '',
          NID: '',
          OrganizationName: '',
          Designation: '',
          Mobile: '',
          Email: '',
          Purpose: '',
          Belongs: '',
          Sector: '',
          DeviceModel: '',
          DeviceSerial: '',
          DeviceDescription: '',
          AppointmentStartDate: '',
          AppointmentStartTime: '',
          AppointmentEndTime: '',
          AppointmentEndDate: '');
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _ClockStartTimeController.dispose();
    _ClockEndTimeController.dispose();
    _DateStartTimeController.dispose();
    _DateEndTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    print('Got UserType: $userType');
    return _isVisible
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                userType = userProfile.user;
                return InternetConnectionChecker(
                  child: PopScope(
                    /*  canPop: false,*/
                    child: Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                        backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
                        leading: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Colors.white,
                            )),
                        title: const Text(
                          'Access Request Form',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'default',
                          ),
                        ),
                        centerTitle: true,
                      ),
                      body: SafeArea(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: Text('Access Request Form',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default')),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                      'Please provide correct details in access request form.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(143, 150, 158, 1),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default')),
                                ),
                                SizedBox(height: 20),
                                Form(
                                    key: globalformpart1key,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LabeledTextWithAsterisk(
                                          text: 'Your Full Name',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _fullnamecontroller,
                                          labelText: 'Full Name',
                                          validator: (input) {
                                            if (input == null ||
                                                input.isEmpty) {
                                              return 'Please enter your full name';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your NID or Passport Number',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _NIDcontroller,
                                          labelText: 'NID or Passport Number',
                                          validator: (input) {
                                            if (input == null ||
                                                input.isEmpty) {
                                              return 'Please enter your NID or Passport Number';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Organization',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller:
                                              _organizationnamecontroller,
                                          labelText: 'Organization',
                                          validator: (input) {
                                            if (input == null ||
                                                input.isEmpty) {
                                              return 'Please enter the organization yor are representing';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Designation',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _designationcontroller,
                                          labelText: 'Designation',
                                          validator: (input) {
                                            if (input == null ||
                                                input.isEmpty) {
                                              return 'Please enter your designation';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Phone Number',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _phonecontroller,
                                          labelText: 'Mobile Number',
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(
                                                11),
                                          ],
                                          validator: (input) {
                                            if (input == null ||
                                                input.isEmpty) {
                                              return 'Please enter your mobile number';
                                            }
                                            if (input.length != 11) {
                                              return 'Mobile number must be 11 digits';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Email Address',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _emailcontroller,
                                          keyboardType:
                                              TextInputType.emailAddress,
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
                                          labelText: 'Email address',
                                        ),
                                        SizedBox(height: 10),
                                        LabeledTextWithAsterisk(
                                          text: 'Select Visiting Sector',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if (userProfile.user == 'ndc_vendor' ||
                                            userProfile.user ==
                                                'ndc_customer') ...[
                                          DropdownFormField(
                                            hintText: 'Select Visiting Sector',
                                            dropdownItems: dropdownItems,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedSector = value ?? '';
                                              });
                                            },
                                          ),
                                        ],
                                        if (userProfile.user ==
                                            'ndc_internal') ...[
                                          Container(
                                            width: screenWidth * 0.9,
                                            height: screenHeight * 0.075,
                                            child: TextFormField(
                                              initialValue: sector,
                                              readOnly: true,
                                              style: const TextStyle(
                                                color: Color.fromRGBO(
                                                    143, 150, 158, 1),
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'default',
                                              ),
                                              decoration: InputDecoration(
                                                labelText: 'Visiting Sector',
                                                labelStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  fontFamily: 'default',
                                                ),
                                                alignLabelWithHint: true,
                                                border:
                                                    const OutlineInputBorder(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        SizedBox(height: 10),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Purpose of the Visit',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          height: true,
                                          controller: _commentcontroller,
                                          labelText: 'Purpose of the Visit',
                                          validator: (input) {
                                            if (input == null ||
                                                input.isEmpty) {
                                              return 'Please enter your purpose of your visit';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Belongings',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _belongscontroller,
                                          labelText: 'Belongings',
                                          validator: (input) {
                                            if (input == null ||
                                                input.isEmpty) {
                                              return 'Please enter belongings';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                LabeledTextWithoutAsterisk(
                                  text: 'Your device Model',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CustomTextFormField(
                                  controller: _devicemodelcontroller,
                                  labelText: 'Device Model (If any)',
                                  validator: (value) {
                                    // Optional field, no validation needed
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabeledTextWithoutAsterisk(
                                  text: 'Your device serial number',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CustomTextFormField(
                                  controller: _deviceserialcontroller,
                                  labelText: 'Device Serial Number(If any)',
                                  validator: (value) {
                                    // Optional field, no validation needed
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                LabeledTextWithoutAsterisk(
                                  text: 'Your device description',
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                CustomTextFormField(
                                  controller: _devicedescriptioncontroller,
                                  labelText: 'Device Description (If any)',
                                  validator: (value) {
                                    // Optional field, no validation needed
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Form(
                                    key: globalformpart2key,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LabeledTextWithAsterisk(
                                          text: 'Your Appointment Start Date',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _DateStartTimeController,
                                          labelText: 'Appointment Start Date',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a date';
                                            }
                                            return null;
                                          },
                                          readOnly: true,
                                          // Makes the field non-editable
                                          icon: 'Date',
                                          // Icon for the date field
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2100),
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                final formattedDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDate);
                                                _DateStartTimeController.text =
                                                    formattedDate;
                                                print(formattedDate);
                                                appointmentStartDate =
                                                    formattedDate;
                                                print(appointmentStartDate);
                                              } else {
                                                print('No date selected');
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Appointment Start Time',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          icon: 'Clock',
                                          controller: _ClockStartTimeController,
                                          labelText: 'Appointment Start Time',
                                          readOnly: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a time';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((selectedTime) {
                                              if (selectedTime != null) {
                                                String formattedTime =
                                                    DateFormat('h:mm a').format(
                                                  DateTime(
                                                    2020,
                                                    1,
                                                    1,
                                                    selectedTime.hour,
                                                    selectedTime.minute,
                                                  ),
                                                );
                                                _ClockStartTimeController.text =
                                                    formattedTime;
                                                print(formattedTime);
                                                appointmentStartTime =
                                                    formattedTime;
                                              } else {
                                                print('No time selected');
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Appointment End Date',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          controller: _DateEndTimeController,
                                          labelText: 'Appointment End Date',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a date';
                                            }
                                            return null;
                                          },
                                          readOnly: true,
                                          // Makes the field non-editable
                                          icon: 'Date',
                                          // Icon for the date field
                                          onTap: () {
                                            showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2020),
                                              lastDate: DateTime(2100),
                                            ).then((selectedDate) {
                                              if (selectedDate != null) {
                                                final formattedDate =
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(selectedDate);
                                                _DateEndTimeController.text =
                                                    formattedDate;
                                                print(formattedDate);
                                                appointmentEndDate =
                                                    formattedDate;
                                                print(appointmentEndDate);
                                              } else {
                                                print('No date selected');
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        LabeledTextWithAsterisk(
                                          text: 'Your Appointment End Time',
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        CustomTextFormField(
                                          icon: 'Clock',
                                          controller: _ClockEndTimeController,
                                          labelText: 'Appointment End Time',
                                          readOnly: true,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please select a time';
                                            }
                                            return null;
                                          },
                                          onTap: () {
                                            showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            ).then((selectedTime) {
                                              if (selectedTime != null) {
                                                String formattedTime =
                                                    DateFormat('h:mm a').format(
                                                  DateTime(
                                                    2020,
                                                    1,
                                                    1,
                                                    selectedTime.hour,
                                                    selectedTime.minute,
                                                  ),
                                                );
                                                _ClockEndTimeController.text =
                                                    formattedTime;
                                                print(formattedTime);
                                                appointmentEndTime =
                                                    formattedTime;
                                              } else {
                                                print('No time selected');
                                              }
                                            });
                                          },
                                        ),
                                      ],
                                    )),
                                SizedBox(
                                  height: 60,
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(13, 70, 127, 1),
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              0.9,
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () {
                                      _connectionRequestForm();

                                    },
                                    child: _isButtonClicked
                                        ? CircularProgressIndicator()
                                        : const Text('Submit',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
  }

  void _connectionRequestForm() {
    setState(() {
      _isButtonClicked = true;
    });
    if (userType == 'ndc_internal') {
      _selectedSector = 'Physical Security & Infrastructure';
    }
    print(_selectedSector);
    print('device: ${_devicemodelcontroller.text}');
    print('serial: ${_deviceserialcontroller.text}');
    print('description: ${_devicedescriptioncontroller.text}');
    print('Purpose: ${_commentcontroller.text}');
    print('Belongings: ${_belongscontroller.text}');
    print('Appointment Start Date: $appointmentStartDate');
    print('Appointment Start Time: $appointmentStartTime');
    print('Appointment End Date: $appointmentEndDate');
    print('Appointment End Time: $appointmentEndTime');

    if (_validateAndSave()) {
      print('triggered Validation');

      const snackBar = SnackBar(
        content: Text('Processing. Please wait a moment ...'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _connectionRequest = AppointmentRequestModel(
          FullName: _fullnamecontroller.text,
          NID: _NIDcontroller.text,
          OrganizationName: _organizationnamecontroller.text,
          Designation: _designationcontroller.text,
          Mobile: _phonecontroller.text,
          Email: _emailcontroller.text,
          Purpose: _commentcontroller.text,
          Belongs: _belongscontroller.text,
          Sector: _selectedSector,
          DeviceModel: _devicemodelcontroller.text,
          DeviceSerial: _deviceserialcontroller.text,
          DeviceDescription: _devicedescriptioncontroller.text,
          AppointmentStartDate: appointmentStartDate,
          AppointmentStartTime: appointmentStartTime,
          AppointmentEndTime: appointmentEndTime,
          AppointmentEndDate: appointmentEndDate);

      AppointmentRequestAPIService()
          .postConnectionRequest(_connectionRequest)
          .then((response) {
        setState(() {
          _isButtonClicked = false;
        });
        print('Visitor request sent successfully!!');
        if (response == 'Visitor Request Already Exist') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => VisitorDashboardUI(
                      shouldRefresh: true,
                    )),
            (route) => false,
          );
          const snackBar = SnackBar(
            content: Text(
                'Request already Sumbitted, please wait for it to be reviewed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (response == 'Something is error') {
          const snackBar = SnackBar(
            content: Text('Request is not submitted, please try again!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (response != null &&
            response == "Appointment Request Successfully") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => VisitorDashboardUI()),
            (route) => false,
          );
          const snackBar = SnackBar(
            content: Text('Appointment Request Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          const snackBar = SnackBar(
            content: Text('Request is not submitted, please try again!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        const snackBar = SnackBar(
          content: Text('Request is not submitted, please try again!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Error sending connection request: $error');
      });
    } else {
      setState(() {
        _isButtonClicked = false;
      });
      const snackBar = SnackBar(
        content: Text('Please fill up all fields properly'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  bool _validateAndSave() {
    bool check = globalformpart1key.currentState!.validate() &&
        globalformpart2key.currentState!.validate();
    if (check) {
      final NameIsValid = _fullnamecontroller.text.isNotEmpty;
      final NIDIsValid = _NIDcontroller.text.isNotEmpty;
      final OrganizationIsValid = _organizationnamecontroller.text.isNotEmpty;
      final DesignationIsValid = _designationcontroller.text.isNotEmpty;
      final PhoneIsValid = _phonecontroller.text.isNotEmpty;
      final EmailIsValid = _emailcontroller.text.isNotEmpty;
      final PurposeIsValid = _commentcontroller.text.isNotEmpty;
      final BelongingsIsValid = _belongscontroller.text.isNotEmpty;
      final SectorIsValid = _selectedSector.isNotEmpty;
      final AppointmentDateIsValid = appointmentStartDate.isNotEmpty;
      final AppointmentFromTimeValid = appointmentStartTime.isNotEmpty;
      final AppointmentToDateIsValid = appointmentEndDate.isNotEmpty;
      final AppointmentToTimeValid = appointmentEndTime.isNotEmpty;

      final allFieldsAreValid = NameIsValid &&
          NIDIsValid &&
          OrganizationIsValid &&
          DesignationIsValid &&
          PhoneIsValid &&
          EmailIsValid &&
          PurposeIsValid &&
          BelongingsIsValid &&
          SectorIsValid &&
          AppointmentDateIsValid &&
          AppointmentFromTimeValid &&
          AppointmentToDateIsValid &&
          AppointmentToTimeValid;

      return allFieldsAreValid;
    } else {
      return false;
    }
  }
}
