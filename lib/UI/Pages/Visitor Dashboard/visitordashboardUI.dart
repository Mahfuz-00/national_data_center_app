import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ndc_app/Data/Data%20Sources/API%20Service%20(Notification)/apiServicePopUpNotificationRead.dart';
import 'package:ndc_app/UI/Widgets/requestWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Data Sources/API Service (Notification)/apiServiceNotificationRead.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../../main.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/visitorRequestInfoCard.dart';
import '../Access Form(Visitor)/accessformUI.dart';
import '../Login UI/loginUI.dart';
import '../Profile UI/profileUI.dart';
import '../Visitor Request and Review List (Full)/VisitorRequestList.dart';
import '../Visitor Request and Review List (Full)/VisitorReviewedList.dart';

/// [VisitorDashboardUI] is a stateful widget that displays the visitor dashboard.
/// It shows the pending and accepted visitor requests along with the user's notifications.
///
/// [shouldRefresh] is a boolean that determines whether to refresh the dashboard on load.
///
/// [fetchConnectionRequests] is a method that fetches the pending and accepted requests from the API,
/// processes the data, and updates the state with the fetched requests.
///
/// [pendingRequests] stores the list of pending request widgets.
/// [acceptedRequests] stores the list of accepted request widgets.
/// [userName], [organizationName], [photoUrl] are strings that store user information.
/// [pendingPagination], [acceptedPagination] are instances of [Pagination] that manage pagination for requests.
/// [canFetchMorePending], [canFetchMoreAccepted] are booleans that indicate whether more requests can be fetched.
class VisitorDashboardUI extends StatefulWidget {
  final bool shouldRefresh;

  const VisitorDashboardUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<VisitorDashboardUI> createState() => _VisitorDashboardUIState();
}

class _VisitorDashboardUIState extends State<VisitorDashboardUI> with WidgetsBindingObserver{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> pendingRequests = [];
  List<Widget> acceptedRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _errorOccurred = false;
  List<String> notifications = [];
  List<String> filteredNotifications = [];
  List<String> filteredPopUpNotifications = [];
  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  late Pagination pendingPagination;
  late Pagination acceptedPagination;
  bool canFetchMorePending = false;
  bool canFetchMoreAccepted = false;
  bool _isDialogShown = false;
  Timer? _notificationTimer;
  bool _isAppActive = true;

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
      acceptedPagination = Pagination.fromJson(pagination['accepted']);
      print(pendingPagination.nextPage);
      print(acceptedPagination.nextPage);
      canFetchMorePending = pendingPagination.canFetchNext;
      canFetchMoreAccepted = acceptedPagination.canFetchNext;
      notifications = List<String>.from(records['notifications'] ?? []);

      // Filter out notifications that start with the specified string
      filteredPopUpNotifications = notifications.where((notification) {
        return notification.startsWith("Your appointment date time has been updated");
      }).toList();

      checkAndShowAppointmentUpdateDialog(filteredPopUpNotifications);

      // Filter out notifications that start with the specified string
      filteredNotifications = notifications.where((notification) {
        return !notification.startsWith("Your appointment date time has been updated");
      }).toList();

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
        return VisitorRequestInfoCard(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentDate: request['appointment_date_time'],
          Purpose: request['purpose'],
          Belongs: request['belong'],
          Status: request['status'],
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

  void checkAndShowAppointmentUpdateDialog(List<String> notifications) {
    for (String notification in notifications) {
      if (!_isDialogShown &&
          notification.startsWith('Your appointment date time has been updated')) {
        _isDialogShown = true;

        final parts = notification.split('|');
        if (parts.length > 1) {
          final details = parts[1].trim();
          final idMatch = RegExp(r'id-(\d+)').firstMatch(details);
          final sectorMatch = RegExp(r'sector-([A-Za-z]+)').firstMatch(details);
          final dateTimeMatch = RegExp(r'(\d{4}-\d{2}-\d{2})[^\d]*(\d{2}:\d{2} [APM]{2})').firstMatch(details);

          final id = idMatch != null ? idMatch.group(1) ?? 'Unknown' : 'Unknown';
          final sector = sectorMatch != null ? sectorMatch.group(1) ?? 'Unknown' : 'Unknown';
          final date = dateTimeMatch != null ? dateTimeMatch.group(1) ?? 'Unknown' : 'Unknown';
          final time = dateTimeMatch != null ? dateTimeMatch.group(2) ?? 'Unknown' : 'Unknown';

          // Display the notification
          _showAppointmentUpdateDialog(context, notification);
          _showNotification(notification, sector, date, time);
        }
        break; // Exit the loop after processing the first relevant notification
      }
    }
  }


  void _showAppointmentUpdateDialog(BuildContext context, String notification) {
    final parts = notification.split('|');
    if (parts.length > 1) {
      final details = parts[1].trim();
      final idMatch = RegExp(r'id-(\d+)').firstMatch(details);
      final id = idMatch != null ? idMatch.group(1) : 'Unknown';

      // Extract sector, date, and time from the notification details
      final sectorMatch = RegExp(r'sector-([A-Za-z]+)').firstMatch(details);
      final dateTimeMatch =
      RegExp(r'(\d{4}-\d{2}-\d{2})[^\d]*(\d{2}:\d{2} [APM]{2})')
          .firstMatch(details);

      final sector = sectorMatch != null ? sectorMatch.group(1) : 'Unknown';
      final date = dateTimeMatch != null ? dateTimeMatch.group(1) : 'Unknown';
      final time = dateTimeMatch != null ? dateTimeMatch.group(2) : 'Unknown';

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Appointment Time Updated',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'default',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(13, 70, 127, 1)),
            ),
            content: Text(
              'Your appointment time in $sector Sector has been updated.\n\nThe new appointment is scheduled for $date at $time.',
              style: TextStyle(
                  fontFamily: 'default',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () async {
                  final notificationService = await PopUpNotificationReadApiService.create();
                  bool isRead = await notificationService.readNotification(id);

                  if (isRead) {
                    print('Notification marked as read.');
                  } else {
                    print('Failed to mark notification as read.');
                  }

                  // Mark dialog as not shown to allow showing it again later
                  _isDialogShown = false;
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: 'default',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(13, 70, 127, 1)),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _showNotification(String notification, String sector, String date, String time) async {
    // Create BigTextStyleInformation
    final BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      'Your appointment time in $sector Sector has been updated.\n\nThe new appointment is scheduled for $date at $time.', // Full text to be shown
      htmlFormatBigText: true, // Optional, enables HTML formatting
      contentTitle: 'Appointment Time Update', // Notification title
      summaryText: '', // Optional, can provide summary text
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'appointment_updates_channel', // Unique ID for your notification channel
      'Appointment Updates',         // User-friendly name
      channelDescription: 'Notifications related to appointment updates', // Description
      importance: Importance.max,    // Importance level for the notification
      priority: Priority.high,        // Priority level for the notification
      showWhen: true,                // Show the time of the notification
      styleInformation: bigTextStyleInformation, // Pass the BigTextStyleInformation
    );

    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (use a unique ID for each notification if you want to update it later)
      'Appointment Time Update', // Notification title
      'Your appointment time in $sector Sector has been updated.\n\nThe new appointment is scheduled for $date at $time.', // Notification body
      platformChannelSpecifics,
      payload: 'item x', // Optional payload (you can use this to pass additional data)
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    startPeriodicNotificationCheck();
    print('initState called');
    pendingPagination = Pagination(nextPage: null, previousPage: null);
    acceptedPagination = Pagination(nextPage: null, previousPage: null);
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
    _notificationTimer?.cancel();
    super.dispose();
  }

  void startPeriodicNotificationCheck() {
    _notificationTimer = Timer.periodic(Duration(minutes: 5), (_) async {
      await fetchConnectionRequests();
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
              child: CircularProgressIndicator(),
            ),
          )
        : BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final userProfile = state.userProfile;
                return InternetConnectionChecker(
                  child: PopScope(
                    /*     canPop: false,*/
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
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Welcome, ${userProfile.name}',
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
                                  const Text('Appointment Pending List',
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
                                      showSeeAllButton: canFetchMorePending,
                                      seeAllButtonText:
                                          'See All Pending Request',
                                      nextView: VisitorRequestListUI(
                                        shouldRefresh: true,
                                      )),
                                  Divider(),
                                  const SizedBox(height: 25),
                                  Container(
                                    child:
                                        const Text('Appointment Accepted List',
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
                                      showSeeAllButton: canFetchMoreAccepted,
                                      seeAllButtonText:
                                          'See All Reviewed Request',
                                      nextView: VisitorReviewedListUI(
                                        shouldRefresh: true,
                                      )),
                                  Divider(),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromRGBO(
                                            13, 70, 127, 1),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                            MediaQuery.of(context).size.height *
                                                0.1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AccessFormUI()));
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
                                        builder: (context) =>
                                            VisitorDashboardUI(
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
                                        builder: (context) =>
                                            const AccessFormUI()));
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
                                        builder: (context) => const ProfileUI(
                                            shouldRefresh: true)));
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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginUI()));
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
            child: filteredNotifications.isEmpty
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
                    itemCount: filteredNotifications.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.info_outline),
                            title: Text(filteredNotifications[index]),
                            onTap: () {
                              // Handle notification tap if necessary
                              overlayEntry.remove();
                            },
                          ),
                          if (index < filteredNotifications.length - 1) Divider()
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

// New public interface
extension VisitorDashboardInterface on VisitorDashboardUI {
  Future<void> fetchRequests() async {
    final state = this.createState() as _VisitorDashboardUIState;
    await state.fetchConnectionRequests(); // Pass the filtered notifications
    state.checkAndShowAppointmentUpdateDialog(state.filteredPopUpNotifications);
  }
}




