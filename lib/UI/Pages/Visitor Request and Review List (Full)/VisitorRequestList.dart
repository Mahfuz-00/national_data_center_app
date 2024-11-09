import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ndc_app/Data/Data%20Sources/API%20Service%20(Dashboard)/apiserviceDashboardFull.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../../Data/Models/paginationModel.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../../Widgets/visitorRequestInfoCard.dart';
import '../Login UI/loginUI.dart';

/// The [VisitorRequestListUI] class represents the user interface for displaying
/// a list of visitor pending requests. It manages the fetching, displaying, and
/// pagination of connection requests using a [ScrollController] for scroll
/// events. This class uses [BlocBuilder] to manage authentication states.
///
/// Variables:
/// - [shouldRefresh]: a boolean flag indicating whether to refresh the view.
/// - [_scaffoldKey]: a key for the [Scaffold] widget to manage the app's
///   layout.
/// - [pendingConnectionRequests]: a list of widgets representing the pending
///   connection requests.
/// - [_isFetched]: a boolean flag indicating whether data has been fetched.
/// - [_isLoading]: a boolean flag indicating whether data is currently being
///   loaded.
/// - [_pageLoading]: a boolean flag indicating whether the page is loading.
/// - [_hasMoreData]: a boolean flag indicating whether more data is available
///   for loading.
/// - [_isFetchingMore]: a boolean flag indicating whether more data is being
///   fetched.
/// - [userName]: a string representing the user's name.
/// - [organizationName]: a string representing the user's organization name.
/// - [photoUrl]: a string representing the user's photo URL.
/// - [_scrollController]: a controller for handling scroll events.
/// - [pendingPagination]: an instance of the [Pagination] model for managing
///   pagination data.
/// - [canFetchMorePending]: a boolean flag indicating if more pending requests
///   can be fetched.
/// - [url]: a string representing the URL for fetching more requests.
///
/// Actions:
/// - [fetchConnectionRequests()]: fetches the initial connection requests from
///   the API.
/// - [fetchMoreConnectionRequests()]: fetches additional connection requests
///   when the user scrolls to the bottom of the list.
/// - [_showLogoutDialog(BuildContext context)]: displays a confirmation dialog
///   for logging out.
class VisitorRequestListUI extends StatefulWidget {
  final bool shouldRefresh;

  const VisitorRequestListUI({Key? key, this.shouldRefresh = false})
      : super(key: key);

  @override
  State<VisitorRequestListUI> createState() => _VisitorRequestListUIState();
}

class _VisitorRequestListUIState extends State<VisitorRequestListUI> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Widget> pendingConnectionRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _hasMoreData = true;
  bool _isFetchingMore = false;

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';
  ScrollController _scrollController = ScrollController();
  late Pagination pendingPagination;
  bool canFetchMorePending = false;
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

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        print('No records available');
        return;
      }

      final Map<String, dynamic> pagination = records['pagination'] ?? {};
      print(pagination);

      pendingPagination = Pagination.fromJson(pagination['pending']);
      if (pendingPagination.nextPage != 'None' &&
          pendingPagination.nextPage!.isNotEmpty) {
        url = pendingPagination.nextPage as String;
        print(pendingPagination.nextPage);
        canFetchMorePending = pendingPagination.canFetchNext;
      } else {
        url = '';
        canFetchMorePending = false;
      }

      final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
      for (var index = 0; index < pendingRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${pendingRequestsData[index]}\n');
      }

      final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
        return VisitorRequestInfoCard(
          Name: request['name'],
          Organization: request['organization'],
          Phone: request['phone'],
          AppointmentStartDateandTime: request['appointment_date_time'],
          Purpose: request['purpose'],
          Belongs: request['belong'],
          Status: request['status'],
          Designation: request['designation'],
          Email: request['email'],
          Sector: request['sector'],
          AppointmentEndTime: request['to_time'],
          AppointmentEndDate: request['to_date'],
        );
      }).toList();

      setState(() {
        pendingConnectionRequests = pendingWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
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
          // No records available
          print('No records available');
          return;
        }

        final Map<String, dynamic> pagination = records['pagination'] ?? {};
        print(pagination);

        pendingPagination = Pagination.fromJson(pagination['pending']);
        if (pendingPagination.nextPage != 'None' &&
            pendingPagination.nextPage!.isNotEmpty) {
          url = pendingPagination.nextPage as String;
          print(pendingPagination.nextPage);
          canFetchMorePending = pendingPagination.canFetchNext;
        } else {
          url = '';
          canFetchMorePending = false;
        }

        final List<dynamic> pendingRequestsData = records['Pending'] ?? [];
        for (var index = 0; index < pendingRequestsData.length; index++) {
          print(
              'Pending Request at index $index: ${pendingRequestsData[index]}\n');
        }

        final List<Widget> pendingWidgets = pendingRequestsData.map((request) {
          return VisitorRequestInfoCard(
            Name: request['name'],
            Organization: request['organization'],
            Phone: request['phone'],
            AppointmentStartDateandTime: request['appointment_date_time'],
            Purpose: request['purpose'],
            Belongs: request['belong'],
            Status: request['status'],
            Designation: request['designation'],
            Email: request['email'],
            Sector: request['sector'],
            AppointmentEndTime: request['to_time'],
            AppointmentEndDate: request['to_date'],
          );
        }).toList();

        setState(() {
          pendingConnectionRequests.addAll(pendingWidgets);
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

  @override
  void initState() {
    super.initState();
    print('initState called');
    _scrollController.addListener(() {
      print("Scroll Position: ${_scrollController.position.pixels}");
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        print('Invoking Scrolling!!');
        fetchMoreConnectionRequests();
      }
    });
    if (!_isFetched) {
      fetchConnectionRequests();
    }
    Future.delayed(Duration(seconds: 2), () {
      if (widget.shouldRefresh) {
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
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final userProfile = state.userProfile;
          return InternetConnectionChecker(
            child: Scaffold(
              backgroundColor: Colors.grey[100],
              key: _scaffoldKey,
              appBar: AppBar(
                backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
                automaticallyImplyLeading: false,
                title: const Text(
                  'Request List',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),
                ),
                centerTitle: true,
                actions: [
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
              body: _pageLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SafeArea(
                            child: Container(
                              color: Colors.grey[100],
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Welcome, ${userProfile.name}',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Center(
                                    child: Text(
                                      'All Pending Requests',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'default',
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ),
                          pendingConnectionRequests.isNotEmpty
                              ? NotificationListener<ScrollNotification>(
                                  onNotification: (scrollInfo) {
                                    if (!scrollInfo.metrics.outOfRange &&
                                        scrollInfo.metrics.pixels ==
                                            scrollInfo
                                                .metrics.maxScrollExtent &&
                                        !_isLoading &&
                                        canFetchMorePending) {
                                      fetchMoreConnectionRequests();
                                    }
                                    return true;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: ListView.separated(
                                      addAutomaticKeepAlives: false,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      // Prevent internal scrolling
                                      itemCount:
                                          pendingConnectionRequests.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index ==
                                            pendingConnectionRequests.length) {
                                          return Center(
                                            child: _isLoading
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20),
                                                    child:
                                                        CircularProgressIndicator(),
                                                  )
                                                : SizedBox.shrink(),
                                          );
                                        }
                                        return pendingConnectionRequests[index];
                                      },
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 10),
                                    ),
                                  ),
                                )
                              : !_isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : buildNoRequestsWidget(screenWidth,
                                      'You currently don\'t have any new requests pending.'),
                        ],
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
}
