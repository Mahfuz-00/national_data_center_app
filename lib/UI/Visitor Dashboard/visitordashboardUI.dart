import 'package:flutter/material.dart';
import 'package:ndc_app/UI/Widgets/requestWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Data/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../Data/API Service (Log Out)/apiServiceLogOut.dart';
import '../../Data/API Service (Notification)/apiServiceNotificationRead.dart';
import '../Access Form(Visitor)/accessformUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Visitor Request and Review List (Full)/VisitorRequestList.dart';
import '../Visitor Request and Review List (Full)/VisitorReviewedList.dart';
import '../Widgets/Connection Checker/internetconnectioncheck.dart';
import '../Widgets/templateerrorcontainer.dart';
import '../Widgets/visitorRequestInfoCard.dart';

class VisitorDashboard extends StatefulWidget {
  final bool shouldRefresh;

  const VisitorDashboard({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<VisitorDashboard> createState() => _VisitorDashboardState();
}

class _VisitorDashboardState extends State<VisitorDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  List<String> notifications = [];

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';

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
      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        // No data available or an error occurred
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final Map<String, dynamic>? records = dashboardData['records'];
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
      await Future.delayed(Duration(seconds: 5));

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }
      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }

      // Map pending requests to widgets
      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return VisitorRequestInfoCard(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Personnel: request['name_of_personnel'],
          Belongs: request['belong'],
          Status: request['status'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
        );
      }).toList();

      // Map accepted requests to widgets
      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return VisitorRequestInfoCard(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Personnel: request['name_of_personnel'],
          Belongs: request['belong'],
          Status: request['status'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
        );
      }).toList();

      setState(() {
        pendingRequests = pendingWidgets;
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

  // Function to check if more than 10 items are available in the list
  bool shouldShowSeeAllButton(List list) {
    return list.length > 10;
  }

  // Build the button to navigate to the page showing all data
  Widget buildSeeAllButtonRequestList(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                MediaQuery.of(context).size.height * 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VisitorRequestList()));
          },
          child: Text('See all pending request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              )),
        ),
      ),
    );
  }

  // Build the button to navigate to the page showing all data
  Widget buildSeeAllButtonReviewedList(BuildContext context) {
    return Center(
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                MediaQuery.of(context).size.height * 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VisitorReviewedList()));
          },
          child: Text('See all reviewed request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'default',
              )),
        ),
      ),
    );
  }

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
                    'Visitor Dashboard',
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
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: SafeArea(
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Welcome, $userName',
                                textAlign: TextAlign.center,
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
                            const Text('Request List',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                )),
                            const SizedBox(height: 5),
                            Divider(),
                            const SizedBox(height: 5),
                            RequestsWidget(
                                loading: _isLoading,
                                fetch: _isFetched,
                                errorText:
                                    'You currently don\'t have any new requests pending.',
                                listWidget: pendingRequests,
                                fetchData: fetchConnectionRequests(),
                                numberOfWidgets: 10,
                                showSeeAllButton:
                                    shouldShowSeeAllButton(pendingRequests),
                                seeAllButtonText: 'See all pending request',
                                nextPage: VisitorRequestList()),
                            Divider(),
                            const SizedBox(height: 25),
                            Container(
                              child: const Text('Reviewed List',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'default',
                                  )),
                            ),
                            Divider(),
                            const SizedBox(height: 5),
                            RequestsWidget(
                                loading: _isLoading,
                                fetch: _isFetched,
                                errorText:
                                'No connection requests reviewed yet',
                                listWidget: acceptedRequests,
                                fetchData: fetchConnectionRequests(),
                                numberOfWidgets: 10,
                                showSeeAllButton:
                                shouldShowSeeAllButton(
                                    acceptedRequests),
                                seeAllButtonText: 'See all reviewed request',
                                nextPage: VisitorReviewedList()),
                            Divider(),
                            const SizedBox(height: 10),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromRGBO(13, 70, 127, 1),
                                  fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.8,
                                      MediaQuery.of(context).size.height * 0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccessForm()));
                                },
                                child: const Text('New Request',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            )
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisitorDashboard(
                                        shouldRefresh: true,
                                      )));
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
                                  builder: (context) => const AccessForm()));
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
                                Icons.add_circle_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'New Request',
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Profile(shouldRefresh: true)));
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
                    ],
                  ),
                ),
              ),
            ),
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
                  onPressed: () async {
                    // Clear user data from SharedPreferences
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userName');
                    await prefs.remove('organizationName');
                    await prefs.remove('photoUrl');
                    // Create an instance of LogOutApiService
                    var logoutApiService = await LogOutApiService.create();

                    // Wait for authToken to be initialized
                    logoutApiService.authToken;

                    // Call the signOut method on the instance
                    if (await logoutApiService.signOut()) {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login())); // Close the drawer
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
}
