import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ndc_app/Data/Data%20Sources/API%20Service%20(Dashboard)/apiserviceDashboardFull.dart';
import 'package:ndc_app/Data/Data%20Sources/API%20Service%20(Sorting)/apiServiceSortingFull.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Data Sources/API Service (Sorting)/apiServiceSorting.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/dropdownfield.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../../Widgets/templateloadingcontainer.dart';
import '../../Widgets/visitorRequestInfoCardSecurityAdmin.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// [SecurityAdminDashboardUI] is a StatefulWidget that represents the dashboard for security administrators.
/// It fetches, displays, and manages connection requests, providing functionalities for sorting, searching,
/// and pagination of data. The dashboard enhances user experience by allowing administrators to monitor
/// appointment requests effectively.
///
/// **Constructor Parameters:**
/// - [shouldRefresh]: A boolean that determines if the dashboard should refresh its content upon initialization. Defaults to false.
///
/// **State Variables:**
/// - [scaffoldKey]: A GlobalKey used to manage the scaffold state.
/// - [_Clockcontroller]: A TextEditingController for managing time input for appointments.
/// - [_Datecontroller]: A TextEditingController for managing date input for appointments.
/// - [_EntryTimeClockcontroller]: A TextEditingController for managing entry time input.
/// - [pendingRequests]: A list of widgets representing pending connection requests.
/// - [acceptedRequests]: A list of widgets representing accepted connection requests.
/// - [SortedpendingRequests]: A list of widgets for sorted pending connection requests.
/// - [SortedacceptedRequests]: A list of widgets for sorted accepted connection requests.
/// - [_isFetched]: A boolean indicating if the connection requests have been fetched.
/// - [_isFetchedSorted]: A boolean indicating if sorted requests have been fetched.
/// - [_isLoading]: A boolean indicating if data is currently being loaded.
/// - [_pageLoading]: A boolean indicating if the initial page is loading.
/// - [_errorOccurred]: A boolean indicating if an error has occurred during data fetching.
/// - [_buttonloading]: A boolean indicating if a button is currently in a loading state.
/// - [monthlyData]: A map to store monthly data retrieved from the API.
/// - [dailyData]: A map to store daily data retrieved from the API.
/// - [appointmentDate]: A string representing the date of the appointment.
/// - [appointmentTime]: A string representing the time of the appointment.
/// - [userName]: A string for the name of the user.
/// - [organizationName]: A string for the organization name.
/// - [photoUrl]: A string for the URL of the user's photo.
/// - [notifications]: A list of notifications received from the API.
/// - [_selectedSector]: A string for the selected sector from the dropdown menu.
/// - [issearchbuttonclicked]: A boolean indicating if the search button has been clicked.
/// - [scrollController]: A ScrollController to manage scrolling in the dashboard.
/// - [acceptedPagination]: An instance of Pagination for managing pagination of accepted requests.
/// - [canFetchMoreAccepted]: A boolean indicating if more accepted requests can be fetched.
/// - [url]: A string holding the URL for fetching more accepted requests.
///
/// **Methods:**
/// - [fetchConnectionRequests]: An asynchronous method that fetches connection requests from the API and updates the UI accordingly.
/// - [fetchSortedConnectionRequests]: An asynchronous method that fetches sorted connection requests based on provided [Date], [Clock], and [Sector].
/// - [fetchMoreConnectionRequests]: An asynchronous method to fetch additional connection requests when paginated results are available.
/// - [fetchMoreSortedConnectionRequests]: An asynchronous method that fetches more sorted connection requests based on the specified [Date], [Clock], and [Sector].
///
/// **Actions:**
/// - [_showNotificationsOverlay(context)]: Displays the notifications overlay.
/// - [fetchSortedConnectionRequests(Date, Clock, Sector)]: Fetches connection requests based on the applied filters.
/// - [fetchMoreConnectionRequests]: Loads additional accepted connection requests when the user scrolls to the bottom.
/// - [fetchMoreSortedConnectionRequests]: Loads additional sorted connection requests based on user input when scrolling.
/// - [buildNoRequestsWidget]: Constructs a widget to display when no appointment requests are found.
/// - [LoadingContainer]: Displays a loading container while waiting for data to load.
/// - [_showLogoutDialog]: Displays a confirmation dialog for user logout.
class SecurityAdminDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const SecurityAdminDashboardUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<SecurityAdminDashboardUI> createState() =>
      _SecurityAdminDashboardUIState();
}

class _SecurityAdminDashboardUIState extends State<SecurityAdminDashboardUI> {
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
  bool _buttonloading = false;
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
  ScrollController _scrollController = ScrollController();
  late Pagination acceptedPagination;
  bool canFetchMoreAccepted = false;
  late String url = '';

  List<DropdownMenuItem<String>> dropdownItems = [
    DropdownMenuItem(
        child: Text("Physical Security & Infrastructure"),
        value: "Physical Security & Infrastructure"),
    DropdownMenuItem(child: Text("Network"), value: "Network"),
    DropdownMenuItem(child: Text("Co Location"), value: "Co Location"),
    DropdownMenuItem(child: Text("Server & Cloud"), value: "Server & Cloud"),
    DropdownMenuItem(child: Text("Email"), value: "Email"),
  ];

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await DashboardAPIService.create();
      final Map<String, dynamic>? dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final Map<String, dynamic>? records = dashboardData['records'] ?? [];
      print(records);
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      print(issearchbuttonclicked);
      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      acceptedPagination = Pagination.fromJson(pagination);
      print(acceptedPagination.nextPage);
      if (acceptedPagination.nextPage != 'None' &&
          acceptedPagination.nextPage!.isNotEmpty) {
        url = acceptedPagination.nextPage as String;
        print(acceptedPagination.nextPage);
        canFetchMoreAccepted = acceptedPagination.canFetchNext;
      } else {
        url = '';
        canFetchMoreAccepted = false;
      }

      notifications = List<String>.from(records['notifications'] ?? []);
      await Future.delayed(Duration(seconds: 3));

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

      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return SecurityAdminVisitorRequestInfoCard(
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
        acceptedRequests = acceptedWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetched = true;
    }
  }
  bool recordsdata = false;

  Future<void> fetchSortedConnectionRequests(
      String Date, String Clock, String Sector) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    setState(() {
      _buttonloading = true;
      _isFetchedSorted = false;
    });
    print('Date Sent: $Date');
    print('Time Sent: $Clock');
    print('Sector Sent: $Sector');
    try {
      final apiService = await SortingAPIService.create();
      final Map<String, dynamic>? dashboardData =
          await apiService.filterData(Date, Clock, Sector);
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final Map<String, dynamic> records = dashboardData['records'];
      print(records);
      if (records == null || records.isEmpty) {
        setState(() {
          recordsdata = true;
          _isFetchedSorted = true;
        });
        print('No records available');
        return;
      }

      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination.toString());
      acceptedPagination = Pagination.fromJson(pagination);
      if (acceptedPagination.nextPage != 'None' &&
          acceptedPagination.nextPage!.isNotEmpty) {
        url = acceptedPagination.nextPage as String;
        print(acceptedPagination.nextPage);
        canFetchMoreAccepted = acceptedPagination.canFetchNext;
      } else {
        url = '';
        canFetchMoreAccepted = false;
      }

      setState(() {
        _isLoading = true;
      });

      final List<dynamic> acceptedRequestsData = records['appointments'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }

      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return SecurityAdminVisitorRequestInfoCard(
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
        SortedacceptedRequests = acceptedWidgets;
        _isFetchedSorted = true;
        _buttonloading = false;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      _isFetchedSorted = true;
      _buttonloading = false;
    }
  }

  Future<void> fetchMoreConnectionRequests() async {
    setState(() {
      _isLoading = true;
    });
    print(url);
    try {
      if (url != '' && url.isNotEmpty) {
        final apiService = await FullDashboardAPIService.create();
        final Map<String, dynamic> dashboardData =
            await apiService.fetchFullItems(url);

        if (dashboardData == null || dashboardData.isEmpty) {
          print(
              'No data available or error occurred while fetching dashboard data');
          return;
        }

        final Map<String, dynamic> records = dashboardData['records'];
        if (records == null || records.isEmpty) {
          print('No records available');
          return;
        }

        final Map<String, dynamic> pagination = records['pagination'] ?? {};
        print(pagination);

        acceptedPagination = Pagination.fromJson(pagination);
        if (acceptedPagination.nextPage != 'None' &&
            acceptedPagination.nextPage!.isNotEmpty) {
          url = acceptedPagination.nextPage as String;
          print(acceptedPagination.nextPage);
          canFetchMoreAccepted = acceptedPagination.canFetchNext;
        } else {
          url = '';
          canFetchMoreAccepted = false;
        }

        final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
        for (var index = 0; index < acceptedRequestsData.length; index++) {
          print(
              'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
        }

        final List<Widget> acceptedWidgets =
            acceptedRequestsData.map((request) {
          return SecurityAdminVisitorRequestInfoCard(
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
          acceptedRequests.addAll(acceptedWidgets);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All requests loaded')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      print('Error fetching more connection requests: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchMoreSortedConnectionRequests(
      String Date, String Clock, String Sector) async {
    print('Sort Date: $Date');
    print('Sort Time: $Clock');
    print('Sort Sector: $Sector');

    setState(() {
      _isLoading = true;
    });
    print(url);

    try {
      if (url != '' && url.isNotEmpty) {
        final apiService = await SortingFullAPIService.create();
        final Map<String, dynamic> dashboardData =
            await apiService.filterFullData(Date, Clock, Sector, url);
        if (dashboardData == null || dashboardData.isEmpty) {
          print(
              'No data available or error occurred while fetching dashboard data');
          return;
        }

        final Map<String, dynamic> records = dashboardData['records'];
        if (records == null || records.isEmpty) {
          print('No records available');
          return;
        }

        final Map<String, dynamic> pagination = records['pagination'] ?? {};
        print(pagination);

        acceptedPagination = Pagination.fromJson(pagination);
        if (acceptedPagination.nextPage != 'None' &&
            acceptedPagination.nextPage!.isNotEmpty) {
          url = acceptedPagination.nextPage as String;
          print(acceptedPagination.nextPage);
          canFetchMoreAccepted = acceptedPagination.canFetchNext;
        } else {
          url = '';
          canFetchMoreAccepted = false;
        }

        final List<dynamic> acceptedRequestsData =
            records['appointments'] ?? [];
        for (var index = 0; index < acceptedRequestsData.length; index++) {
          print(
              'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
        }

        final List<Widget> acceptedWidgets =
            acceptedRequestsData.map((request) {
          return SecurityAdminVisitorRequestInfoCard(
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
          SortedacceptedRequests.addAll(acceptedWidgets);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('All requests loaded')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }
    } catch (e) {
      print('Error fetching more connection requests: $e');
      setState(() {
        _isLoading = false;
      });
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
    _scrollController.addListener(() {
      print("Scroll Position: ${_scrollController.position.pixels}");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('Invoking Scrolling!!');
        fetchMoreConnectionRequests();
      }
    });
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    Future.delayed(Duration(seconds: 2), () {
      if (widget.shouldRefresh && !_isFetched) {
        print('Page Loading Done!!');
      }
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
              child: CircularProgressIndicator(),
            ),
          )
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                print('Welcome, ${userProfile.name}');
                return InternetConnectionChecker(
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
                        ],
                      ),
                      body: SingleChildScrollView(
                        controller: _scrollController,
                        child: SafeArea(
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Welcome, ${userProfile.name}',
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
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please select a date';
                                                  }
                                                  return null;
                                                },
                                                readOnly: true,
                                                enableInteractiveSelection:
                                                    false,
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
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Icon(
                                                      Icons
                                                          .calendar_today_outlined,
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
                                                      showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(2020),
                                                        lastDate:
                                                            DateTime(2100),
                                                      ).then((selectedDate) {
                                                        if (selectedDate !=
                                                            null) {
                                                          final formattedDate =
                                                              DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(
                                                                      selectedDate);
                                                          _Datecontroller.text =
                                                              formattedDate;
                                                          print(formattedDate);
                                                          appointmentDate =
                                                              formattedDate;
                                                          print(
                                                              appointmentDate);
                                                        } else {
                                                          print(
                                                              'No date selected');
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
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please select a time';
                                                  }
                                                  return null;
                                                },
                                                readOnly: true,
                                                enableInteractiveSelection:
                                                    false,
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
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          5))),
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
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
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          String formattedTime =
                                                              DateFormat(
                                                                      'h:mm a')
                                                                  .format(
                                                            DateTime(
                                                                2024,
                                                                1,
                                                                1,
                                                                selectedTime
                                                                    .hour,
                                                                selectedTime
                                                                    .minute),
                                                          );
                                                          print(formattedTime);
                                                          _Clockcontroller
                                                                  .text =
                                                              formattedTime;
                                                          appointmentTime =
                                                              formattedTime;
                                                          print(
                                                              appointmentTime);
                                                        } else {
                                                          print(
                                                              'No time selected');
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
                                        backgroundColor: const Color.fromRGBO(
                                            13, 70, 127, 1),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                            MediaQuery.of(context).size.height *
                                                0.075),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_Datecontroller.text.isEmpty &&
                                            _Clockcontroller.text.isEmpty &&
                                            _selectedSector == '') {
                                          print('Button not pressed');
                                          const snackBar = SnackBar(
                                            content: Text(
                                                'Enter atleast one filter'),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        } else {
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

                                          print('Button pressed');
                                          print('Date: $Date');
                                          print('Time: $Clock');
                                          print('Sector: $Sector');
                                          fetchSortedConnectionRequests(
                                              Date, Clock, Sector);
                                        }
                                      },
                                      child: _buttonloading
                                          ? CircularProgressIndicator() // Show circular progress indicator when button is clicked
                                          : Text('Search',
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
                                    acceptedRequests.isNotEmpty
                                        ? NotificationListener<
                                            ScrollNotification>(
                                            onNotification: (scrollInfo) {
                                              if (!scrollInfo
                                                      .metrics.outOfRange &&
                                                  scrollInfo.metrics.pixels ==
                                                      scrollInfo.metrics
                                                          .maxScrollExtent &&
                                                  !_isLoading &&
                                                  canFetchMoreAccepted) {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                fetchMoreConnectionRequests()
                                                    .then((_) {
                                                  setState(() {
                                                    _isLoading = false;
                                                  });
                                                });
                                              }
                                              return true;
                                            },
                                            child: ListView.separated(
                                              addAutomaticKeepAlives: false,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  acceptedRequests.length + 1,
                                              itemBuilder: (context, index) {
                                                if (index ==
                                                    acceptedRequests.length) {
                                                  return Center(
                                                    child: _isLoading
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        20),
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : SizedBox.shrink(),
                                                  );
                                                }
                                                return acceptedRequests[index];
                                              },
                                              separatorBuilder: (context,
                                                      index) =>
                                                  const SizedBox(height: 10),
                                            ),
                                          )
                                        : !_isLoading
                                            ? LoadingContainer(
                                                screenWidth: screenWidth)
                                            : buildNoRequestsWidget(screenWidth,
                                                'No appointment found'),
                                  ] else if (issearchbuttonclicked == true) ...[
                                    const Text(
                                        'Sorted Appointment Approved List',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'default',
                                        )),
                                    const SizedBox(height: 5),
                                    Divider(),
                                    _buttonloading
                                        ? Padding(
                                            padding: const EdgeInsets.all(50.0),
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                        : SortedacceptedRequests.isNotEmpty
                                            ? NotificationListener<
                                                ScrollNotification>(
                                                onNotification: (scrollInfo) {
                                                  if (!scrollInfo
                                                          .metrics.outOfRange &&
                                                      scrollInfo
                                                              .metrics.pixels ==
                                                          scrollInfo.metrics
                                                              .maxScrollExtent &&
                                                      !_isLoading &&
                                                      canFetchMoreAccepted) {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    fetchMoreSortedConnectionRequests(
                                                            _Datecontroller
                                                                .text,
                                                            _Clockcontroller
                                                                .text,
                                                            _selectedSector)
                                                        .then((_) {
                                                      setState(() {
                                                        _isLoading = false;
                                                      });
                                                    });
                                                  }
                                                  return true;
                                                },
                                                child: ListView.separated(
                                                  addAutomaticKeepAlives: false,
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      SortedacceptedRequests
                                                              .length +
                                                          1,
                                                  itemBuilder:
                                                      (context, index) {
                                                    if (index ==
                                                        SortedacceptedRequests
                                                            .length) {
                                                      return Center(
                                                        child: _isLoading
                                                            ? Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            20),
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              )
                                                            : SizedBox.shrink(),
                                                      );
                                                    }
                                                    return SortedacceptedRequests[
                                                        index];
                                                  },
                                                  separatorBuilder:
                                                      (context, index) =>
                                                          const SizedBox(
                                                              height: 10),
                                                ),
                                              )
                                            : !_isLoading
                                                ? LoadingContainer(
                                                    screenWidth: screenWidth)
                                                : buildNoRequestsWidget(
                                                    screenWidth,
                                                    'No appointment found'),
                                  ],
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
                                            SecurityAdminDashboardUI()));
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
                                        builder: (context) =>
                                            const ProfileUI()));
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
              } else {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
  }

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
                    Navigator.of(context).pop();
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
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userName');
                    await prefs.remove('organizationName');
                    await prefs.remove('photoUrl');
                    var logoutApiService = await LogOutApiService.create();
                    logoutApiService.authToken;
                    if (await logoutApiService.signOut()) {
                      Navigator.pop(context);
                      context.read<AuthCubit>().logout();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LoginUI()));
                    }
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
    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
