import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndc_app/Connection%20Checker/internetconnectioncheck.dart';

import '../API Model and Service (Access From)/apiserviceconnection.dart';
import '../API Model and Service (Access From)/connectionmodel.dart';
import '../Login UI/loginUI.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';
import '../Visitor Dashboard/visitordashboardUI.dart';

class AccessForm extends StatefulWidget {
  const AccessForm({super.key});

  @override
  State<AccessForm> createState() => _AccessFormState();
}

class _AccessFormState extends State<AccessForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _Clockcontroller = TextEditingController();
  late TextEditingController _Datecontroller = TextEditingController();
  late TextEditingController _purposecontroller;
  late TextEditingController _belongscontroller;
  late TextEditingController _appointmentwithcontroller;
  late AppointmentRequestModel _connectionRequest;
  late String appointmentDate;
  late String appointmentTime;

  @override
  void initState() {
    super.initState();
    _purposecontroller = TextEditingController();
    _belongscontroller = TextEditingController();
    _appointmentwithcontroller = TextEditingController();
    _connectionRequest = AppointmentRequestModel(
        Purpose: '',
        Belongs: '',
        AppointmentWith: '',
        AppointmentDate: '',
        AppointmentTime: '');
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

    return InternetChecker(
      child: PopScope(
        canPop: false,
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
              'Access Form',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
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
                      Text('Access Form',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default')),
                      SizedBox(height: 20),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.15,
                        child: TextFormField(
                          controller: _purposecontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your purpose of your visit';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Purpose of the Visit',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: screenHeight * 0.15),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        //padding: EdgeInsets.all(20),
                        /*decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),),*/
                        child: TextFormField(
                          controller: _belongscontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter belongings';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Belongs',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _appointmentwithcontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your appointee';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Color.fromRGBO(143, 150, 158, 1),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Appointment With',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: _Datecontroller,
                              validator: (value) {
                                // Check if the text field is empty or contains a valid date
                                if (value == null || value.isEmpty) {
                                  return 'Please select a date';
                                }
                                // You can add more complex validation logic if needed
                                return null;
                              },
                              readOnly: true,
                              // Make the text field readonly
                              enableInteractiveSelection: false,
                              // Disable interactive selection
                              style: const TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Appointment Date',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  // Adjust the padding as needed
                                  child: Icon(
                                    Icons.calendar_today_outlined,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Show the date picker dialog
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    ).then((selectedDate) {
                                      // Check if a date is selected
                                      if (selectedDate != null) {
                                        // Format the selected date as needed
                                        final formattedDate =
                                        DateFormat('yyyy-MM-dd').format(selectedDate);
                                        // Set the formatted date to the controller
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
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: Stack(
                          children: [
                            TextFormField(
                              controller: _Clockcontroller,
                              validator: (value) {
                                // Check if the text field is empty or contains a valid time
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                // You can add more complex validation logic if needed
                                return null;
                              },
                              readOnly: true,
                              // Make the text field readonly
                              enableInteractiveSelection: false,
                              // Disable interactive selection
                              style: const TextStyle(
                                color: Color.fromRGBO(143, 150, 158, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              ),
                              decoration: InputDecoration(
                                labelText: 'Appointment Time',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: 'default',
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  // Adjust the padding as needed
                                  child: Icon(
                                    Icons.schedule_rounded,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    // Show the time picker dialog
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((selectedTime) {
                                      // Check if a time is selected
                                      if (selectedTime != null) {
                                        // Convert selectedTime to a formatted string
                                        String formattedTime =
                                            selectedTime.hour.toString().padLeft(2, '0') +
                                                ':' +
                                                selectedTime.minute.toString().padLeft(2, '0');
                                        print(formattedTime);
                                        // Set the formatted time to the controller
                                        _Clockcontroller.text = formattedTime;
                                        appointmentTime = formattedTime;
                                        print(appointmentTime);
                                      } else {
                                        print('No time selected');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
                            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                                MediaQuery.of(context).size.height * 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _connectionRequestForm();
                          },
                          child: const Text('Submit',
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
      ),
    );
  }

  void _connectionRequestForm() {
    print('Purpose: ${_purposecontroller.text}');
    print('Belongings: ${_belongscontroller.text}');
    print('Appoinment With: ${_appointmentwithcontroller.text}');
    print('Appoinment Date: $appointmentDate');
    print('Appointment Time: $appointmentTime');

    // Validate and save form data
    if (_validateAndSave()) {
      print('triggered Validation');
      // Initialize connection request model
      _connectionRequest = AppointmentRequestModel(
          Purpose: _purposecontroller.text,
          Belongs: _belongscontroller.text,
          AppointmentWith: _appointmentwithcontroller.text,
          AppointmentDate: appointmentDate,
          AppointmentTime: appointmentTime);

      // Perform any additional actions before sending the request
      // Send the connection request using API service
      APIServiceAppointmentRequest()
          .postConnectionRequest(_connectionRequest)
          .then((response) {
        // Handle successful request
        print('Visitor request sent successfully!!');
        if (response == 'Visitor Request Already Exist') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => VisitorDashboard()),
            (route) => false, // This will remove all routes from the stack
          );
          const snackBar = SnackBar(
            content: Text(
                'Request already Sumbitted, please wait for it to be reviewed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (response != null && response == "Appointment Request Successfully") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => VisitorDashboard()),
            (route) => false, // This will remove all routes from the stack
          );
          const snackBar = SnackBar(
            content: Text('Appointment Request Submitted!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        // Handle error
        print('Error sending connection request: $error');
      });
    }
  }

  bool _validateAndSave() {
    final PurposeIsValid = _purposecontroller.text.isNotEmpty;
    final BelongingsIsValid = _belongscontroller.text.isNotEmpty;
    final AppoinmentwithIdIsValid = _appointmentwithcontroller.text.isNotEmpty;
    final AppointmentDateIsValid = appointmentDate.isNotEmpty;
    final AppointmentTimeValid = appointmentTime.isNotEmpty;

    // Perform any additional validation logic if needed

    // Check if all fields are valid
    final allFieldsAreValid = PurposeIsValid &&
        BelongingsIsValid &&
        AppoinmentwithIdIsValid &&
        AppointmentDateIsValid &&
        AppointmentTimeValid;

    return allFieldsAreValid;
  }
}
