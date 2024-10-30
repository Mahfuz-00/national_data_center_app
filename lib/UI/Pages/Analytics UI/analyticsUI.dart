import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_charts/flutter_charts.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../Widgets/Graph/graphs.dart';
import '../../Widgets/visitorRequestInfoCard.dart';
import '../../Widgets/visitorRequestInfoCardAdmin.dart';
import '../Login UI/loginUI.dart';

/// [AnalyticsUI] is a [StatefulWidget] that represents the analytics interface of the application.
///
/// - [shouldRefresh] is a [boolean] that indicates whether the UI should refresh data upon loading.
///
/// The [AnalyticsUI] class manages the following:
///
/// - [_tabController]: A [TabController] that manages the tabs in the UI.
/// - [_scaffoldKey]: A [GlobalKey] for the scaffold, which allows the opening of the drawer or displaying of snack bars.
/// - [pendingRequests]: A List of Widget that holds the pending connection requests.
/// - [acceptedRequests]: A List of Widget that holds the accepted connection requests.
/// - [_isFetched]: A boolean that indicates whether the data has been fetched.
/// - [_isLoading]: A boolean that indicates whether the data is currently being loaded.
/// - [_pageLoading]: A boolean that indicates whether the page is still in the loading phase.
/// - [_errorOccurred]: A boolean that indicates whether an error occurred while fetching data.
/// - [monthlyData]: A Map that holds the data for monthly analytics.
/// - [dailyData]: A Map that holds the data for daily analytics.
/// - [userName]: A String that holds the user’s name.
/// - [organizationName]: A String that holds the name of the user’s organization.
/// - [photoUrl]: A String that holds the URL for the user’s profile photo.
///
/// The class performs the following actions:
///
/// - [loadUserProfile]: Fetches the user's profile from [SharedPreferences] and updates the state with user details.
/// - [fetchConnectionRequests]: Fetches connection requests and analytics data using the [DashboardAPIService].
///
/// The [initState] method initializes the [TabController], fetches the user profile, and optionally fetches data based on the [shouldRefresh] parameter.
/// The [dispose] method disposes of the [TabController].
///
/// The [build] method constructs the UI based on the loading state and displays analytics data.
/// The [_showLogoutDialog] method displays a confirmation dialog for logging out.
class AnalyticsUI extends StatefulWidget {
  final bool shouldRefresh;

  const AnalyticsUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<AnalyticsUI> createState() => _AnalyticsUIState();
}

class _AnalyticsUIState extends State<AnalyticsUI>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  late Map<String, dynamic> monthlyData;
  late Map<String, dynamic> dailyData;

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

      setState(() {
        _isLoading = true;
      });

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

      monthlyData = records['Monthly'] ?? [];
      dailyData = records['Weekly'] ?? [];

      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return AdminVisitorRequestInfoCard(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Belongs: request['belong'],
          Status: request['status'],
          ApplicationID: request['appointment_id'],
          Designation: request['status'],
          Email: request['status'],
          Sector: request['status'],
          AppointmentTime: request['to_time'],
        );
      }).toList();

      final List<Widget> acceptedWidgets = acceptedRequestsData.map((request) {
        return VisitorRequestInfoCard(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Belongs: request['belong'],
          Status: request['status'],
          Designation: request['status'],
          Email: request['status'],
          Sector: request['status'],
          AppointmentTime: request['to_time'],
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
    }
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    print('initState called');
    loadUserProfile();
    monthlyData = {};
    dailyData = {};
    Future.delayed(Duration(seconds: 5), () {
      if (widget.shouldRefresh && !_isFetched) {
        loadUserProfile();
        print('Page Loading Done!!');
        if (!_isFetched) {
          final data = fetchConnectionRequests();
        }
      }
      setState(() {
        print('Page Loading');
        _pageLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        : InternetConnectionChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
            leading:  IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Analytics',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'default',
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 25),
                  const Center(
                    child: Text(
                      'Request processed analysis',
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
                    height: 25,
                  ),
                  Text(
                    'Monthly Analytic Graph',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.35,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            )),
                        child: chartToRunLine(monthlyData)),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Daily Analytic Graph',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.35,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            )),
                        child: chartToRunVertical(dailyData)),
                  ),
                  SizedBox(height: 20,)
                ],
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
                            builder: (context) => AnalyticsUI(shouldRefresh: true,)));
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
                    Navigator.pop(context);
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
}
