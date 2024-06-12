import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/API Service (Access From)/apiserviceconnection.dart';
import '../../Data/Models/connectionmodel.dart';
import '../Widgets/dropdownfield.dart';
import '../Visitor Dashboard/visitordashboardUI.dart';
import '../Widgets/Connection Checker/internetconnectioncheck.dart';

class AccessForm extends StatefulWidget {
  const AccessForm({super.key});

  @override
  State<AccessForm> createState() => _AccessFormState();
}

class _AccessFormState extends State<AccessForm> {
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
  late TextEditingController _personnelcontroller;
  late TextEditingController _belongscontroller;
  late TextEditingController _appointmentwithcontroller;
  late TextEditingController _devicemodelcontroller;
  late TextEditingController _deviceserialcontroller;
  late TextEditingController _devicedescriptioncontroller;
  late AppointmentRequestModel _connectionRequest;
  late String appointmentDate;
  late String appointmentTime;
  String _selectedSector = '';
  bool _isVisible = true;

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
   // super.initState();
    _fullnamecontroller = TextEditingController();
    _NIDcontroller = TextEditingController();
    _organizationnamecontroller = TextEditingController();
    _designationcontroller = TextEditingController();
    _phonecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _commentcontroller = TextEditingController();
    _personnelcontroller = TextEditingController();
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
          Personnel: '',
          Belongs: '',
          Sector: '',
          DeviceModel: '',
          DeviceSerial: '',
          DeviceDescription: '',
          AppointmentDate: '',
          AppointmentTime: '');
      setState(() {
        // After 2 seconds, set _isVisible to true to trigger rebuild
        _isVisible = false;
      });
    });
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
    print('Got UserType: $userType');
    return _isVisible
        ? Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Show circular loading indicator while waiting
        child: CircularProgressIndicator(),
      ),
    )
        : InternetChecker(
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
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.075,
                        child: TextFormField(
                          controller: _fullnamecontroller,
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
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                          controller: _NIDcontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your NID number of your passport number';
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
                            labelText: 'NID or Passport Number',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                          controller: _organizationnamecontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter the organization yor are representing';
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
                            labelText: 'Organization Name',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                          controller: _designationcontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter your designation in your organization';
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
                            labelText: 'Designation',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                          controller: _phonecontroller,
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
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                          controller: _emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          validator: (input) {
                            if (input!.isEmpty) {
                              return 'Please enter your email address';
                            }
                            final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
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
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (userType == 'ndc_vendor' || userType == 'ndc_customer') ... [
                        DropdownFormField(
                          hintText: 'Select Visiting Sector',
                          dropdownItems: dropdownItems,
                          onChanged: (value) {
                            setState(() {
                              _selectedSector = value ?? '';
                              //print('New: $_selectedUserType');
                            });
                          },
                        ),
                      ],
                      if (userType == 'ndc_internal') ...[
                        Container(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.075,
                          child: TextFormField(
                            initialValue: sector,
                            readOnly: true,
                            style: const TextStyle(
                              color: Color.fromRGBO(143, 150, 158, 1),
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
                              //contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: screenHeight * 0.15),
                              border: const OutlineInputBorder(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                              ),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.15,
                        child: TextFormField(
                          controller: _commentcontroller,
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
                            labelText:
                                'Purpose of the Visit',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: screenHeight * 0.18),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.15,
                        child: TextFormField(
                          controller: _personnelcontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter the name(s) of the accompanying personnel';
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
                            labelText:
                            'Name(s) of Personnel',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: screenHeight * 0.18),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                            labelText: 'Belongings',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),
                      /*  SizedBox(
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
                                    const BorderRadius.all(Radius.circular(5))),
                          ),
                        ),
                      ),*/
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
                          controller: _devicemodelcontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter device model';
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
                            labelText: 'Device Model (If any)',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                          controller: _deviceserialcontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter device serial number';
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
                            labelText: 'Device Serial Number(If any)',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                          controller: _devicedescriptioncontroller,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return 'Please enter the device description';
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
                            labelText: 'Device Description (If any)',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'default',
                            ),
                            border: const OutlineInputBorder(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
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
                                            DateFormat('dd-MM-yyyy')
                                                .format(selectedDate);
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5))),
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
                                        /*String formattedTime =
                                            selectedTime.hour.toString().padLeft(2, '0') +
                                                ':' +
                                                selectedTime.minute.toString().padLeft(2, '0');*/
                                        String formattedTime =
                                            DateFormat('h:mm a').format(
                                          DateTime(
                                              2020,
                                              1,
                                              1,
                                              selectedTime.hour,
                                              selectedTime.minute),
                                        );
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
                      SizedBox(height: 20,)
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
    if(userType == 'ndc_internal'){
      _selectedSector = 'Physical Security & Infrastructure';
    }
    print(_selectedSector);
    print('device: ${_devicemodelcontroller.text}');
    print('serial: ${_deviceserialcontroller.text}');
    print('description: ${_devicedescriptioncontroller.text}');
    print('Purpose: ${_commentcontroller.text}');
    print('Belongings: ${_belongscontroller.text}');
    print('Appoinment Date: $appointmentDate');
    print('Appointment Time: $appointmentTime');

    // Validate and save form data
    if (_validateAndSave()) {
      print('triggered Validation');

      const snackBar = SnackBar(
        content: Text(
            'Processing'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      // Initialize connection request model
      _connectionRequest = AppointmentRequestModel(
          FullName: _fullnamecontroller.text,
          NID: _NIDcontroller.text,
          OrganizationName: _organizationnamecontroller.text,
          Designation: _designationcontroller.text,
          Mobile: _phonecontroller.text,
          Email: _emailcontroller.text,
          Purpose: _commentcontroller.text,
          Personnel: _personnelcontroller.text,
          Belongs: _belongscontroller.text,
          Sector: _selectedSector,
          DeviceModel: _devicemodelcontroller.text,
          DeviceSerial: _deviceserialcontroller.text,
          DeviceDescription: _devicedescriptioncontroller.text,
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
            MaterialPageRoute(builder: (context) => VisitorDashboard(shouldRefresh: true,)),
            (route) => false, // This will remove all routes from the stack
          );
          const snackBar = SnackBar(
            content: Text(
                'Request already Sumbitted, please wait for it to be reviewed!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        else if (response == 'Something is error') {
          const snackBar = SnackBar(
            content: Text(
                'Request is not submitted, please try again!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        else if (response != null &&
            response == "Appointment Request Successfully") {
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
        else{
          const snackBar = SnackBar(
            content: Text(
                'Request is not submitted, please try again!'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }).catchError((error) {
        const snackBar = SnackBar(
          content: Text(
              'Request is not submitted, please try again!'),
        );
        // Handle error
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
    final PersonnelIsValid = _personnelcontroller.text.isNotEmpty;
    final BelongingsIsValid = _belongscontroller.text.isNotEmpty;
    final SectorIsValid = _selectedSector.isNotEmpty;
    final AppointmentDateIsValid = appointmentDate.isNotEmpty;
    final AppointmentTimeValid = appointmentTime.isNotEmpty;

    // Perform any additional validation logic if needed

    // Check if all fields are valid
    final allFieldsAreValid = NameIsValid &&
        NIDIsValid &&
        OrganizationIsValid &&
        DesignationIsValid &&
        PhoneIsValid &&
        EmailIsValid && PurposeIsValid && PersonnelIsValid && BelongingsIsValid &&
        SectorIsValid &&
        AppointmentDateIsValid &&
        AppointmentTimeValid;

    return allFieldsAreValid;
  }
}
