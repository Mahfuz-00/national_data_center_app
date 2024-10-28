import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Guest Access Form)/apiserviceguestappointment.dart';
import '../../../Data/Models/ConnectionGuestModel.dart';
import '../../Widgets/CustomTextField.dart';
import '../Splashscreen UI/splashscreenUI.dart';
import '../Visitor Dashboard/visitordashboardUI.dart';

/// [AccessFormGuestUI] is a StatefulWidget that represents the user interface for
/// a guest access request form.
///
/// This form collects various details from the guest, including:
/// - [fullnamecontroller]: Controller for the full name input field.
/// - [NIDcontroller]: Controller for the NID or passport number input field.
/// - [organizationnamecontroller]: Controller for the organization name input field.
/// - [designationcontroller]: Controller for the designation input field.
/// - [phonecontroller]: Controller for the mobile number input field.
/// - [emailcontroller]: Controller for the email address input field.
/// - [commentcontroller]: Controller for the purpose of the visit input field.
/// - [belongscontroller]: Controller for belongings input field.
/// - [devicemodelcontroller]: Controller for the device model input field.
/// - [deviceserialcontroller]: Controller for the device serial number input field.
/// - [devicedescriptioncontroller]: Controller for the device description input field.
/// - [Clockcontroller]: Controller for the appointment time input field.
/// - [Datecontroller]: Controller for the appointment date input field.
/// - [connectionRequest]: Instance of GuestAppointmentModel to hold the access request data.
/// - [appointmentDate]: String to store the formatted appointment date.
/// - [appointmentTime]: String to store the formatted appointment time.
/// - [selectedSector]: Currently selected sector for the request (default is 'Physical Security & Infrastructure').
/// - [result]: Result of the file picker to allow the guest to upload documents.
/// - [file]: The selected file from the file picker, if any.
///
/// The [connectionRequestForm] method handles the submission of the form data.
class AccessFormGuestUI extends StatefulWidget {
  const AccessFormGuestUI({super.key});

  @override
  State<AccessFormGuestUI> createState() => _AccessFormGuestUIState();
}

class _AccessFormGuestUIState extends State<AccessFormGuestUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _Clockcontroller = TextEditingController();
  late TextEditingController _Datecontroller = TextEditingController();
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
  late GuestAppointmentModel _connectionRequest;
  late String appointmentDate;
  late String appointmentTime;
  String _selectedSector = 'Physical Security & Infrastructure';
  FilePickerResult? result;
  bool _isButtonClicked = false;
  File? _file;

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
    _appointmentwithcontroller = TextEditingController();
    _devicemodelcontroller = TextEditingController();
    _deviceserialcontroller = TextEditingController();
    _devicedescriptioncontroller = TextEditingController();
    _connectionRequest = GuestAppointmentModel(
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
      AppointmentDate: '',
      AppointmentTime: '',
    );
  }

  @override
  void dispose() {
    _Clockcontroller.dispose();
    _Datecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return InternetConnectionChecker(
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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text('Access Request Form',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default')),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        'Please provide correct details in access request form.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default')),
                    SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _fullnamecontroller,
                      labelText: 'Full Name',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CustomTextFormField(
                      controller: _NIDcontroller,
                      labelText: 'NID or Passport Number',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter your NID or Passport Number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _organizationnamecontroller,
                      labelText: 'Organization',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter the organization yor are representing';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _designationcontroller,
                      labelText: 'Designation',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter your designation';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _phonecontroller,
                      labelText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: (input) {
                        if (input == null || input.isEmpty) {
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
                    CustomTextFormField(
                      controller: _emailcontroller,
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
                      labelText: 'Email address',
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      height: true,
                      controller: _commentcontroller,
                      labelText: 'Purpose of the Visit',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter your purpose of your visit';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _belongscontroller,
                      labelText: 'Belongings',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter belongings';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _devicemodelcontroller,
                      labelText: 'Device Model (If any)',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter device model';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _deviceserialcontroller,
                      labelText: 'Device Serial Number(If any)',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter device serial number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _devicedescriptioncontroller,
                      labelText: 'Device Description (If any)',
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please enter the device description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      controller: _Datecontroller,
                      labelText: 'Appointment Date',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                      readOnly: true,
                      icon: 'Date',
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            final formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
                            _Datecontroller.text = formattedDate;
                            print(formattedDate);
                            appointmentDate = formattedDate;
                            print(appointmentDate);
                          } else {
                            print('No date selected');
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      icon: 'Clock',
                      controller: _Clockcontroller,
                      labelText: 'Appointment Time',
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
                            String formattedTime = DateFormat('h:mm a').format(
                              DateTime(
                                2020,
                                1,
                                1,
                                selectedTime.hour,
                                selectedTime.minute,
                              ),
                            );
                            _Clockcontroller.text = formattedTime;
                            print(formattedTime);
                            appointmentTime = formattedTime;
                          }
                          else{
                            print('No time selected');
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromRGBO(13, 70, 127, 1),
                                fixedSize: Size(
                                    MediaQuery.of(context).size.width * 0.9,
                                    MediaQuery.of(context).size.height *
                                        0.075),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              onPressed: _pickFile,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_file == null) ...[
                                    Icon(Icons.document_scanner, color: Colors.white,),
                                    SizedBox(width: 10,),
                                    Text('Pick File',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        )),
                                  ],
                                  if (_file != null) ...[
                                    Text('File Picked',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        )),
                                  ]
                                ],
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(13, 70, 127, 1),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.9,
                              MediaQuery.of(context).size.height * 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isButtonClicked = true;
                          });
                          _connectionRequestForm();
                          setState(() {
                            _isButtonClicked = false;
                          });
                        },
                        child:  _isButtonClicked
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
      );

      if (result != null) {
        String? fileExtension = result.files.single.extension;

        List<String> allowedExtensions = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'];

        if (fileExtension != null && allowedExtensions.contains(fileExtension.toLowerCase())) {
          if (result.files.single.size <= 21000 * 1024) {
            setState(() {
              _file = File(result.files.single.path!);
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("File exceeds the maximum allowed size of 21 MB."),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invalid file extension. Allowed types: pdf, doc, docx, ppt, pptx, xls, xlsx."),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No file selected."),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }




  void _connectionRequestForm() {
    print('Full Name: ${_fullnamecontroller.text}');
    print('NID: ${_NIDcontroller.text}');
    print('Organization: ${_organizationnamecontroller.text}');
    print('Designation: ${_designationcontroller.text}');
    print('Mobile: ${_phonecontroller.text}');
    print('Email: ${_emailcontroller.text}');
    print('Purpose: ${_commentcontroller.text}');
    print('Belongings: ${_belongscontroller.text}');
    print('Appoinment Date: $appointmentDate');
    print('Appointment Time: $appointmentTime');

    if (_validateAndSave()) {
      print('triggered Validation');

      const snackBar = SnackBar(
        content: Text('Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _connectionRequest = GuestAppointmentModel(
          FullName: _fullnamecontroller.text,
          NID: _NIDcontroller.text,
          OrganizationName: _organizationnamecontroller.text,
          Designation: _designationcontroller.text,
          Mobile: _phonecontroller.text,
          Email: _emailcontroller.text,
          Purpose: _commentcontroller.text,
          Belongs: _belongscontroller.text,
          Sector: 'Physical Security & Infrastructure',
          DeviceModel: _devicemodelcontroller.text,
          DeviceSerial: _deviceserialcontroller.text,
          DeviceDescription: _devicedescriptioncontroller.text,
          AppointmentDate: appointmentDate,
          AppointmentTime: appointmentTime);

      GuestAppointmentRequestAPIService()
          .postConnectionRequest(_connectionRequest, _file)
          .then((response) {
            print(response);
        print('Visitor request sent successfully!!');
        if (response == 'Visitor Request Already Exist') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreenUI()),
            (route) => false,
          );
          const snackBar = SnackBar(
            content: Text(
                'Request already Sumbitted, please wait for it to be reviewed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (response != null &&
            response == "Appointment Request Successfully") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreenUI()),
            (route) => false,
          );
          const snackBar = SnackBar(
            content: Text('Appointment Request Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (response == "Something is error") {
          const snackBar = SnackBar(
            content: Text('Request is not submitted, please try again!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          final snackBar = SnackBar(
            content: Text('$response'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        print('Error sending connection request: $error');
      });
    }
  }

  bool _validateAndSave() {
    final NameIsValid = _fullnamecontroller.text.isNotEmpty;
    final NIDIsValid = _NIDcontroller.text.isNotEmpty;
    final OrganizationIsValid = _organizationnamecontroller.text.isNotEmpty;
    final DesignationIsValid = _designationcontroller.text.isNotEmpty;
    final PhoneIsValid = _phonecontroller.text.isNotEmpty;
    final EmailIsValid = _emailcontroller.text.isNotEmpty;
    final PurposeIsValid = _commentcontroller.text.isNotEmpty;
    final BelongingsIsValid = _belongscontroller.text.isNotEmpty;
    final AppointmentDateIsValid = appointmentDate.isNotEmpty;
    final AppointmentTimeValid = appointmentTime.isNotEmpty;

    final allFieldsAreValid = NameIsValid &&
        NIDIsValid &&
        OrganizationIsValid &&
        DesignationIsValid &&
        PhoneIsValid &&
        EmailIsValid &&
        PurposeIsValid &&
        BelongingsIsValid &&
        AppointmentDateIsValid &&
        AppointmentTimeValid;

    return allFieldsAreValid;
  }
}
