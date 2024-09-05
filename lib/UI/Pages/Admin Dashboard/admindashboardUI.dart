import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_charts/flutter_charts.dart';
import 'package:flutter_charts/flutter_charts.dart' as charts;
import 'package:ndc_app/Data/Data%20Sources/API%20Service%20(Dashboard)/apiserviceDashboardFull.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/RequestBody.dart';
import '../../Widgets/visitorRequestInfoCard.dart';
import '../../Widgets/visitorRequestInfoCardAdmin.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';

/// [AdminDashboardUI] is a [StatefulWidget] that provides the user interface for
/// the admin dashboard. It displays connection requests, handles pagination, and
/// manages the fetching of additional data based on user interactions.
///
/// The widget accepts the following [parameters]:
/// - [shouldRefresh]: A bool that indicates whether the page should refresh data when loaded.
///
/// Key variables and actions include:
/// - [_tabController]: Manages tab navigation within the dashboard.
/// - [_scaffoldKey]: A [GlobalKey] to access the scaffold state for displaying snack bars and other UI elements.
/// - [pendingRequests]: A list of Widgets that displays pending connection requests.
/// - [acceptedRequests]: A list of Widgets that displays accepted connection requests.
/// - [_isFetched]: A bool indicating whether the initial data has been fetched.
/// - [_isLoading]: A bool indicating whether more data is being fetched.
/// - [_pageLoading]: A bool controlling whether the entire page is loading initially.
/// - [_errorOccurred]: A bool tracking if an error occurred during data fetching.
/// - [monthlyData]: A [Map<String, dynamic>] containing the monthly data fetched from the API.
/// - [dailyData]: A [Map<String, dynamic>] containing the daily data fetched from the API.
/// - [userName], [organizationName], [photoUrl]: Strings storing user-specific information.
/// - [notifications]: A [List<String>] holding the notifications fetched from the API.
/// - [_scrollController]: A [ScrollController] to monitor the scroll position and trigger data fetching when needed.
/// - [pendingPagination], [acceptedPagination]: Instances of [Pagination] managing pagination for pending and accepted requests.
/// - [canFetchMore], [canFetchMoreAccepted]: bool values indicating whether more pending or accepted requests can be fetched.
/// - [url]: A String storing the URL for fetching additional data.
///
/// [fetchConnectionRequests]: A [Future<void>] method that fetches the initial set of connection requests from the API.
/// [fetchMoreConnectionRequests]: A [Future<void>] method that fetches additional connection requests when the user scrolls to the bottom of the list.
class AdminDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const AdminDashboardUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<AdminDashboardUI> createState() => _AdminDashboardUIState();
}

class _AdminDashboardUIState extends State<AdminDashboardUI>
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
  List<String> notifications = [];
  ScrollController _scrollController = ScrollController();
  late Pagination pendingPagination;
  late Pagination acceptedPagination;

  bool canFetchMorePending = false;
  bool canFetchMoreAccepted = false;
  late String url = '';

  Future<void> fetchConnectionRequests() async {
    if (_isFetched) return;
    try {
      final apiService = await DashboardAPIService.create();

      final Map<String, dynamic> dashboardData =
          await apiService.fetchDashboardItems();
      if (dashboardData == null || dashboardData.isEmpty) {
        print(
            'No data available or error occurred while fetching dashboard data');
        return;
      }
      print(dashboardData);

      final Map<String, dynamic>? records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      setState(() {
        _isLoading = true;
      });
      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPagination = Pagination.fromJson(pagination['pending']);
      print('Pagination: $pendingPagination');
      if (pendingPagination.nextPage != 'None' &&
          pendingPagination.nextPage!.isNotEmpty) {
        url = pendingPagination.nextPage as String;
        print(pendingPagination.nextPage);
        canFetchMorePending = pendingPagination.canFetchNext;
      } else {
        url = '';
        canFetchMorePending = false;
      }

      acceptedPagination = Pagination.fromJson(pagination['accepted']);
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

      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return AdminVisitorRequestInfoCard(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Personnel: request['name_of_personnel'],
          Belongs: request['belong'],
          Status: request['status'],
          ApplicationID: request['appointment_id'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
        );
      }).toList();

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

        final Map<String, dynamic>? records = dashboardData['records'];
        if (records == null || records.isEmpty) {
          print('No records available');
          return;
        }

        setState(() {
          _isLoading = true;
        });
        final Map<String, dynamic> pagination = records['pagination'] ?? {};
        print(pagination);

        pendingPagination = Pagination.fromJson(pagination['pending']);
        print('Pagination: $pendingPagination');
        if (pendingPagination.nextPage != 'None' &&
            pendingPagination.nextPage!.isNotEmpty) {
          url = pendingPagination.nextPage as String;
          print(pendingPagination.nextPage);
          canFetchMorePending = pendingPagination.canFetchNext;
        } else {
          url = '';
          canFetchMorePending = false;
        }

        acceptedPagination = Pagination.fromJson(pagination['accepted']);
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

        final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
          return AdminVisitorRequestInfoCard(
            Name: request['name'],
            Organization: request['organization'],
            Phone: request['phone'],
            AppointmentDate: request['appointment_date_time'],
            Purpose: request['purpose'],
            Personnel: request['name_of_personnel'],
            Belongs: request['belong'],
            Status: request['status'],
            ApplicationID: request['appointment_id'],
            Designation: request['designation'],
            Email: request['email'],
            Sector: request['sector'],
          );
        }).toList();

        final List<Widget> acceptedWidgets =
            acceptedRequestsData.map((request) {
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
          pendingRequests.addAll(pendingWidgets);
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

  /*      monthlyData = records['Monthly'] ?? [];
      // Serialize dailyData to JSON string
      final monthlyDataJson = jsonEncode(dailyData);

      // Save dailyDataJson to SharedPreferences
      await saveMonthlyDataToSharedPreferences(monthlyDataJson);

      dailyData = records['Weekly'] ?? [];
      // Serialize dailyData to JSON string
      final dailyDataJson = jsonEncode(dailyData);

      // Save dailyDataJson to SharedPreferences
      await saveDailyDataToSharedPreferences(dailyDataJson);*/

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
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(() {
      print("Scroll Position: ${_scrollController.position.pixels}");
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("Scroll Position Max");
      }
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('Invoking Scrolling!!');
        fetchMoreConnectionRequests();
      }
    });
    print('initState called');
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    Future.delayed(Duration(seconds: 5), () {
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
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                return InternetConnectionChecker(
                  child: PopScope(
                    canPop: false,
                    child: Scaffold(
                      key: _scaffoldKey,
                      appBar: AppBar(
                        backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
                        automaticallyImplyLeading: false,
                        title: const Text(
                          'Admin Dashboard',
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
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(kToolbarHeight),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                top:
                                    BorderSide(color: Colors.black, width: 1.0),
                              ),
                            ),
                            child: TabBar(
                              padding: EdgeInsets.zero,
                              controller: _tabController,
                              indicatorColor:
                                  const Color.fromRGBO(13, 70, 127, 1),
                              labelColor: const Color.fromRGBO(13, 70, 127, 1),
                              unselectedLabelColor: Colors.black,
                              tabs: [
                                Tab(
                                  child: Text(
                                    'Pending Requests',
                                    style: TextStyle(
                                      //color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Accepted Requests',
                                    style: TextStyle(
                                      //color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'default',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          AdminRequestsBody(
                            scrollController: _scrollController,
                            Requests: pendingRequests,
                            isLoading: _isLoading,
                            canFetchMore: canFetchMorePending,
                            fetchMoreConnectionRequests:
                                fetchMoreConnectionRequests,
                            Type: 'Pending',
                          ),
                          AdminRequestsBody(
                            scrollController: _scrollController,
                            Requests: acceptedRequests,
                            isLoading: _isLoading,
                            canFetchMore: canFetchMorePending,
                            fetchMoreConnectionRequests:
                                fetchMoreConnectionRequests,
                            Type: 'Accepted',
                          ),
                        ],
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
                                        builder: (context) => AdminDashboardUI(
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
                                        builder: (context) => const ProfileUI(
                                              shouldRefresh: true,
                                            )));
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
                                      Icons.login,
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
                                  LoginUI())); // Close the drawer
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
    Future.delayed(Duration(seconds: 5), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}
