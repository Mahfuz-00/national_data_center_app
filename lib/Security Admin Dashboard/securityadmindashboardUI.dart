import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndc_app/Connection%20Checker/internetconnectioncheck.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API Model And Service (Dashboard)/apiserviceDashboard.dart';
import '../API Model and Service (Sorting)/apiServiceSorting.dart';
import '../API Service (Notification)/apiServiceNotificationRead.dart';
import '../API Service (PDF Download)/apiServicePDF.dart';
import '../Analytics UI/analyticsUI.dart';
import '../Graph/graphs.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Sign Up UI/dropdownfield.dart';
import '../Template Models/templateerrorcontainer.dart';
import '../Template Models/userinfo.dart';
import '../Template Models/visitorRequestInfoCardSecurityAdmin.dart';

class SecurityAdminDashboard extends StatefulWidget {
  final bool shouldRefresh;

  const SecurityAdminDashboard({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<SecurityAdminDashboard> createState() => _SecurityAdminDashboardState();
}

class _SecurityAdminDashboardState extends State<SecurityAdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _Clockcontroller = TextEditingController();
  late TextEditingController _Datecontroller = TextEditingController();
  late TextEditingController _EntryTimeClockcontroller =
      TextEditingController();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  List<Widget> SortedpendingRequests = [];
  List<Widget> SortedacceptedRequests = [];
  bool _isFetched = false;
  bool _isFetchedSorted = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  late Map<String, dynamic> monthlyData;
  late Map<String, dynamic> dailyData;
  late String appointmentDate;
  late String appointmentTime;

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  List<String> notifications = [];
  String _selectedSector = '';
  bool issearchbuttonclicked = false;

  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(
        child: Text("Physical Security & Infrastructure"),
        value: "Physical Security & Infrastructure"),
    DropdownMenuItem(child: Text("Network"), value: "Network"),
    DropdownMenuItem(child: Text("Co Location"), value: "Co Location"),
    DropdownMenuItem(child: Text("Server & Cloud"), value: "Server & Cloud"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      organizationName = prefs.getString('organizationName') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      photoUrl = 'https://bcc.touchandsolve.com' + photoUrl;
      print('User Name: $userName');
      print('Organization Name: $organizationName');
      print('Photo URL: $photoUrl');
      print('User profile got it!!!!');
    });
  }

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await DashboardAPIService.create();

      // Fetch dashboard data
      final Map<String, dynamic>? dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final Map<String, dynamic>? records = dashboardData['records'] ?? [];
      print(records);
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

      // Extract notifications
      notifications = List<String>.from(records['notifications'] ?? []);

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 3));

/*      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }*/
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }

      /*   monthlyData = records['Monthly'] ?? [];
      // Serialize dailyData to JSON string
      final monthlyDataJson = jsonEncode(dailyData);

      // Save dailyDataJson to SharedPreferences
      await saveMonthlyDataToSharedPreferences(monthlyDataJson);

      dailyData = records['Weekly'] ?? [];
      // Serialize dailyData to JSON string
      final dailyDataJson = jsonEncode(dailyData);

      // Save dailyDataJson to SharedPreferences
      await saveDailyDataToSharedPreferences(dailyDataJson);
*/
/*      // Map pending requests to widgets
      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return VisitorRequestInfoCardSecurityAdmin(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Belongs: request['belong'],
          ApplicationID: request['appointment_id'],
          Personnel: request['name_of_personnel'],
          // ApplicationID: request['appointment_id'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
        );
      }).toList();*/

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return VisitorRequestInfoCardSecurityAdmin(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Personnel: request['name_of_personnel'],
          Belongs: request['belong'],
          ApplicationID: request['appointment_id'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
        );
      }).toList();

      setState(() {
        /*     pendingRequests = pendingWidgets;*/
        acceptedRequests = acceptedWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
      //_errorOccurred = true;
      // Handle error as needed
    }
  }

/*// Function to save data to SharedPreferences
  Future<void> saveDailyDataToSharedPreferences(String dataJson) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('dailyData', dataJson);
    } catch (e) {
      print('Error saving data to SharedPreferences: $e');
      // Handle error as needed
    }
  }
  // Function to save data to SharedPreferences
  Future<void> saveMonthlyDataToSharedPreferences(String dataJson) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('monthlyData', dataJson);
    } catch (e) {
      print('Error saving data to SharedPreferences: $e');
      // Handle error as needed
    }
  }*/

  @override
  void initState() {
    super.initState();
    print('initState called');
    loadUserProfile();
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !_isFetched) {
        loadUserProfile();
        // Refresh logic here, e.g., fetch data again
        print('Page Loading Done!!');
        // connectionRequests = [];
        if (!_isFetched) {
          fetchConnectionRequests();
          //_isFetched = true; // Set _isFetched to true after the first call
        }
      }
      // After 5 seconds, set isLoading to false to stop showing the loading indicator
      setState(() {
        print('Page Loading');
        _pageLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _EntryTimeClockcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return _pageLoading
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
                  automaticallyImplyLeading: false,
                  title: const Text(
                    'Security Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'default',
                    ),
                  ),
                  centerTitle: true,
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.notifications,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            _showNotificationsOverlay(context);
                            var notificationApiService =
                                await NotificationReadApiService.create();
                            notificationApiService.readNotification();
                          },
                        ),
                        if (notifications.isNotEmpty)
                          Positioned(
                            right: 11,
                            top: 11,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: Text(
                                '${notifications.length}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    /*     IconButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout, color: Colors.white,),
              ),*/
                  ],
                ),
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Welcome, Admin',
                                //textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text('Search Appointment',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: screenWidth * 0.437,
                                    height: screenHeight * 0.075,
                                    child: Stack(
                                      children: [
                                        TextFormField(
                                          controller: _Datecontroller,
                                          validator: (value) {
                                            // Check if the text field is empty or contains a valid date
                                            if (value == null ||
                                                value.isEmpty) {
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
                                            color: Color.fromRGBO(
                                                143, 150, 158, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'default',
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Date',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: 'default',
                                            ),
                                            border: const OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5))),
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
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
                                                            .format(
                                                                selectedDate);
                                                    // Set the formatted date to the controller
                                                    _Datecontroller.text =
                                                        formattedDate;
                                                    print(formattedDate);
                                                    appointmentDate =
                                                        formattedDate;
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
                                ),
                                SizedBox(
                                  width: screenWidth * 0.026,
                                ),
                                Center(
                                  child: Container(
                                    width: screenWidth * 0.437,
                                    height: screenHeight * 0.075,
                                    child: Stack(
                                      children: [
                                        TextFormField(
                                          controller: _Clockcontroller,
                                          validator: (value) {
                                            // Check if the text field is empty or contains a valid time
                                            if (value == null ||
                                                value.isEmpty) {
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
                                            color: Color.fromRGBO(
                                                143, 150, 158, 1),
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'default',
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Time',
                                            labelStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              fontFamily: 'default',
                                            ),
                                            border: const OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5))),
                                            suffixIcon: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
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
                                                        DateFormat('h:mm a')
                                                            .format(
                                                      DateTime(
                                                          2020,
                                                          1,
                                                          1,
                                                          selectedTime.hour,
                                                          selectedTime.minute),
                                                    );
                                                    print(formattedTime);
                                                    // Set the formatted time to the controller
                                                    _Clockcontroller.text =
                                                        formattedTime;
                                                    appointmentTime =
                                                        formattedTime;
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
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: DropdownFormField(
                                hintText: 'Select Visiting Sector',
                                dropdownItems: dropdownItems,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSector = value ?? '';
                                    //print('New: $_selectedUserType');
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: ElevatedButton(
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
                                onPressed: () {
                                 if(_Datecontroller.text.isEmpty && _Clockcontroller.text.isEmpty && _selectedSector == ''){
                                   const snackBar = SnackBar(
                                     content: Text('Enter atleast one filter'),
                                   );
                                   ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                 }
                                 else{
                                   issearchbuttonclicked = true;
                                   String Date;
                                   String Clock;
                                   String Sector;
                                   if (_Datecontroller.text.isEmpty) {
                                     Date = ' ';
                                   } else {
                                     Date = _Datecontroller.text;
                                   }

                                   if (_Clockcontroller.text.isEmpty) {
                                     Clock = ' ';
                                   } else {
                                     Clock = _Clockcontroller.text;
                                   }

                                   if (_selectedSector == null) {
                                     Sector = ' ';
                                   } else {
                                     Sector = _selectedSector;
                                   }

                                   print('Date: $Date');
                                   print('Time: $Clock');
                                   print('Sector: $Sector');

                                     fetchSortedConnectionRequests(
                                         Date, Clock, Sector);
                                 }
                                },
                                child: const Text('Search',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            const SizedBox(height: 5),
                            if (issearchbuttonclicked == false) ...[
                              const Text('Appointment Approved List',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  )),
                              const SizedBox(height: 5),
                              Divider(),
                              Container(
                                //height: screenHeight*0.25,
                                child: FutureBuilder<void>(
                                    future: _isLoading
                                        ? null
                                        : fetchConnectionRequests(),
                                    builder: (context, snapshot) {
                                      if (!_isFetched) {
                                        // Return a loading indicator while waiting for data
                                        return Container(
                                          height:
                                              200, // Adjust height as needed
                                          width:
                                              screenWidth, // Adjust width as needed
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        // Handle errors
                                        return buildNoRequestsWidget(
                                            screenWidth,
                                            'Error: ${snapshot.error}');
                                      } else if (_isFetched) {
                                        if (acceptedRequests.isEmpty) {
                                          // Handle the case when there are no pending connection requests
                                          return buildNoRequestsWidget(
                                              screenWidth,
                                              'No appointment found');
                                        } else if (acceptedRequests
                                            .isNotEmpty) {
                                          // If data is loaded successfully, display the ListView
                                          return Container(
                                            child: Column(
                                              children: [
                                                ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      /*acceptedRequests.length > 10
                                                      ? 10
                                                      : */
                                                      acceptedRequests.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    // Display each connection request using ConnectionRequestInfoCard
                                                    return acceptedRequests[
                                                        index];
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const SizedBox(
                                                              height: 10),
                                                ),
                                                /*  if (shouldShowSeeAllButton(
                                            acceptedConnectionRequests))
                                          buildSeeAllButtonReviewedList(
                                              context),*/
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      return SizedBox();
                                    }),
                              ),
                            ] else if (issearchbuttonclicked == true) ...[
                              const Text('Sorted Appointment Approved List',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  )),
                              const SizedBox(height: 5),
                              Divider(),
                              Container(
                                //height: screenHeight*0.25,
                                child: FutureBuilder<void>(
                                    future: _isLoading
                                        ? null
                                        : fetchSortedConnectionRequests(
                                            _Datecontroller.text,
                                            _Clockcontroller.text,
                                            _selectedSector),
                                    builder: (context, snapshot) {
                                      if (!_isFetchedSorted) {
                                        // Return a loading indicator while waiting for data
                                        return Container(
                                          height:
                                              200, // Adjust height as needed
                                          width:
                                              screenWidth, // Adjust width as needed
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        // Handle errors
                                        return buildNoRequestsWidget(
                                            screenWidth,
                                            'Error: ${snapshot.error}');
                                      } else if (_isFetchedSorted) {
                                        if (recordsdata == true) {
                                          // Handle the case when there are no pending connection requests
                                          return buildNoRequestsWidget(
                                              screenWidth,
                                              'No appointment found');
                                        } else if (SortedacceptedRequests
                                            .isNotEmpty) {
                                          // If data is loaded successfully, display the ListView
                                          return Container(
                                            child: Column(
                                              children: [
                                                ListView.separated(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      /*SortedacceptedRequests.length > 10
                                                      ? 10
                                                      :*/
                                                      SortedacceptedRequests
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    // Display each connection request using ConnectionRequestInfoCard
                                                    return SortedacceptedRequests[
                                                        index];
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const SizedBox(
                                                              height: 10),
                                                ),
                                                /*  if (shouldShowSeeAllButton(
                                            acceptedConnectionRequests))
                                          buildSeeAllButtonReviewedList(
                                              context),*/
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                      return SizedBox();
                                    }),
                              ),
                            ],
                            Divider(),
/*                      VisitorRequestInfoCardSecurityAdmin(
                          name: 'Md. Abdur Sattar',
                          organization: 'Touch and Solve',
                          AppointmentWith: 'Md. Masud Bhuiya',
                          AppointmentDate: '12-04-2024, 12:00 PM',
                          Purpose: 'Visting',
                          Belongs: 'A handBag',
                          ApplicationID: 1234343,
                          Status: 'Accepted'),*/
                            /*Container(
                        width: screenWidth*0.95,
                        //height: MediaQuery.of(context).size.height* 0.35,
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(Radius.circular(10)),),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child:  Container(
                                    width: MediaQuery.of(context).size.width* 0.3,
                                    height: MediaQuery.of(context).size.height* 0.15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),),
                                    child: const Icon(Icons.person,
                                      size: 100,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: RichText(
                                      text: const TextSpan(children: [
                                        TextSpan(
                                            text: 'Name: Abddus Sobhan\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                        TextSpan(
                                            text: 'Organization Name: Touch and Solve\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                        TextSpan(
                                            text: 'Appointment With: Dhukhu Mia\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                        TextSpan(
                                            text: 'Belongs: A Handbag\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                        TextSpan(
                                            text: 'Mobile No: 00111222333\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                        TextSpan(
                                            text: 'Appointment Time & Date: 11:30, 15 February 2024\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                        TextSpan(
                                            text: 'Status: Pending\n',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'default',
                                            )),
                                      ])),
                                )
                              ],
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: screenWidth*0.4,
                                  height: screenHeight*0.07,
                                  child: TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    controller: _Clockcontroller,
                                    readOnly: true, // Make the text field readonly
                                    enableInteractiveSelection: false, // Disable interactive selection
                                    enableSuggestions: false,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(143, 150, 158, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Entry Time',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        fontFamily: 'default',
                                      ),
                                      border:  const OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(Radius.circular(10))
                                      ),
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((selectedTime) {
                                            if (selectedTime != null) {
                                              _Clockcontroller.text = selectedTime.format(context);
                                            }
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
                                          child: Icon(Icons.schedule_rounded, size: 30,),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(13, 70, 127, 1),
                                    //backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                                    fixedSize: Size(MediaQuery.of(context).size.width* 0.4, MediaQuery.of(context).size.height * 0.07),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                      width: 1,
                                   ),
                                  ),
                                  onPressed: () {
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.print, color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text('Print',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'default',
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),*/
                            //_buildPanel(_people),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  height: screenHeight * 0.08,
                  color: const Color.fromRGBO(13, 70, 127, 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SecurityAdminDashboard()));
                        },
                        child: Container(
                          width: screenWidth / 3,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.home,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Profile()));
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          )),
                          width: screenWidth / 3,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _showLogoutDialog(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          )),
                          width: screenWidth / 3,
                          padding: EdgeInsets.all(5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'default',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

/*  Widget _buildPanel(List<User> users) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          users[index].isExpanded = isExpanded;
        });
      },
      children: users.map<ExpansionPanel>((User user) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                tileColor: Colors.white,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: isExpanded ? 16 : 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                      ),
                    ),
                    if (!isExpanded) ...[
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: Text(
                          user.orgName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.05),
                      Expanded(
                        child: Text(
                          DateFormat('dd.MM.yyyy').format(user.appointmentDate),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                      ),
                    ],
                    Divider(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          },
          body: Column(
              children: [
              Divider(),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.black,
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 100,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${user.name}',
                              style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                      )),
                          Text('Organization: ${user.orgName}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                          Text('Appointment With: ${user.appointmentWith}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                          Text('Belongs to: ${user.belongs}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                          Text('Mobile No: ${user.mobileNo}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                          Text('Appointment Date: ${DateFormat('dd.MM.yyyy').format(user.appointmentDate)}, ${user.appointmentTime.hour.toString().padLeft(2, '0')}:${user.appointmentTime.minute.toString().padLeft(2, '0')} ${user.appointmentTime.period == DayPeriod.am ? 'AM' : 'PM'}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                          Text('Status: ${user.status}',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.4,
                      height: screenHeight * 0.07,
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: _Clockcontroller,
                        readOnly: true, // Make the text field readonly
                        enableInteractiveSelection: false, // Disable interactive selection
                        enableSuggestions: false,
                        style: const TextStyle(
                          color: Color.fromRGBO(143, 150, 158, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'default',
                        ),
                        decoration: InputDecoration(
                          labelText: 'Entry Time',
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'default',
                          ),
                          border: const OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(10))
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((selectedTime) {
                                if (selectedTime != null) {
                                  _Clockcontroller.text = selectedTime.format(context);
                                }
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
                              child: Icon(Icons.schedule_rounded, size: 30,),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(13, 70, 127, 1),
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.07),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          width: 1,
                        ),
                      ),
                      onPressed: () {
                        // Add functionality for print button here
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.print, color: Colors.white,),
                          SizedBox(width: 10,),
                          Text('Print',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'default',
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ],
          ),
          isExpanded: user.isExpanded,
          backgroundColor: Colors.white,
        );
      }).toList(),
    );
  }*/

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text(
                'Logout Confirmation',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'default',
                ),
              ),
              Divider()
            ],
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: const Color.fromRGBO(13, 70, 127, 1),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: const Color.fromRGBO(13, 70, 127, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  void _showNotificationsOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight + 10.0,
        right: 10.0,
        width: 250,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: notifications.isEmpty
                ? Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'No new notifications',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text(notifications[index]),
                            onTap: () {
                              // Handle notification tap if necessary
                              overlayEntry.remove();
                            },
                          ),
                          if (index < notifications.length - 1) Divider()
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );

    overlay?.insert(overlayEntry);

    // Remove the overlay when tapping outside
    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  bool recordsdata = false;

  Future<void> fetchSortedConnectionRequests(
      String Date, String Clock, String Sector) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      _isFetchedSorted = false;
    });
    print('Date Sent: $Date');
    print('Time Sent: $Clock');
    print('Sector Sent: $Sector');
    try {
      final apiService = await SortingAPIService.create();

      print('1');
      // Fetch dashboard data
      final Map<String, dynamic>? dashboardData =
          await apiService.filterData(Date, Clock, Sector);
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print('2');
      print(dashboardData);

      final List<dynamic> records = dashboardData['records'];
      print(records);
      if (records == null || records.isEmpty) {
        setState(() {
          recordsdata = true;
          _isFetchedSorted = true;
        });
        // No records available
        print('No records available');
        return;
      }

      print('3');

      // Set isLoading to true while fetching data
      setState(() {
        _isLoading = true;
      });

/*      // Extract notifications
      notifications = List<String>.from(records['notifications'] ?? []);*/

      // Simulate fetching data for 5 seconds
      await Future.delayed(Duration(seconds: 3));

/*      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }*/
/*      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }*/
      /*   // Map pending requests to widgets
      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return VisitorRequestInfoCardSecurityAdmin(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Belongs: request['belong'],
          ApplicationID: request['appointment_id'],
          Personnel: request['name_of_personnel'],
          // ApplicationID: request['appointment_id'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
        );
      }).toList();*/

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = records.map((request) {
        return VisitorRequestInfoCardSecurityAdmin(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Personnel: request['name_of_personnel'],
          Belongs: request['belong'],
          ApplicationID: request['appointment_id'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
        );
      }).toList();

      setState(() {
/*        SortedpendingRequests = pendingWidgets;*/
        SortedacceptedRequests = acceptedWidgets;
        _isFetchedSorted = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetchedSorted = true;
    }
  }
}
