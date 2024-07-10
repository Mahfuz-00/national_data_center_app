
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Core/Connection Checker/internetconnectioncheck.dart';
import '../../../Data/Data Sources/API Service (Dashboard)/apiserviceDashboard.dart';
import '../../../Data/Data Sources/API Service (Log Out)/apiServiceLogOut.dart';
import '../../Bloc/auth_cubit.dart';
import '../../Widgets/templateerrorcontainer.dart';
import '../../Widgets/visitorRequestInfoCard.dart';
import '../Login UI/loginUI.dart';
import '../Visitor Dashboard/visitordashboardUI.dart';
import 'VisitorRequestList.dart';

class VisitorReviewedList extends StatefulWidget {
  final bool shouldRefresh;

  const VisitorReviewedList({Key? key, this.shouldRefresh = false}) : super(key: key);

  @override
  State<VisitorReviewedList> createState() => _VisitorReviewedListState();
}

class _VisitorReviewedListState extends State<VisitorReviewedList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //late List<ISPConnectionDetails> connectionRequests;
  // Declare variables to hold connection requests data
  List<Widget> acceptedConnectionRequests = [];
  bool _isFetched = false;
  bool _isLoading = false;
  bool _pageLoading = true;
  bool _hasMoreData = true;
  bool _isFetchingMore = false;
  ScrollController _scrollController = ScrollController();

  late String userName = '';
  late String organizationName = '';
  late String photoUrl = '';

  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      organizationName = prefs.getString('organizationName') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      photoUrl = 'https://bcc.touchandsolve.com'+ photoUrl;
    });
  }

  /*Future<void> fetchConnectionRequests() async {
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

      final Map<String, dynamic> records = dashboardData['records'];
      if (records == null || records.isEmpty) {
        // No records available
        print('No records available');
        return;
      }

      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Accepted Request at index $index: ${acceptedRequestsData[index]}\n');
      }


      // Map accepted requests to widgets
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
        acceptedConnectionRequests = acceptedWidgets;
        _isFetched = true;
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      // Handle error as needed
    }
  }*/

  Future<void> fetchConnectionRequests({bool loadMore = false}) async {
    if (_isFetched && !loadMore) return;

    if (loadMore) {
      setState(() {
        _isFetchingMore = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
    }

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

      final List<dynamic> acceptedRequestsData = records['Accepted'] ?? [];
      for (var index = 0; index < acceptedRequestsData.length; index++) {
        print(
            'Pending Request at index $index: ${acceptedRequestsData[index]}\n');
      }

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
        if (loadMore) {
          acceptedConnectionRequests.addAll(acceptedWidgets);
          _isFetchingMore = false;
        } else {
          acceptedConnectionRequests = acceptedWidgets;
          _isLoading = false;
          _isFetched = true;
        }

        if (acceptedRequestsData.isEmpty) {
          _hasMoreData = false; // No more data to fetch
        }
      });
    } catch (e) {
      print('Error fetching connection requests: $e');
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print('initState called');

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent &&
          !_isFetchingMore &&
          _hasMoreData) {
        fetchConnectionRequests(loadMore: true);
      }
    });

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

    return InternetChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
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
            // Show circular loading indicator while waiting
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: Colors.grey[100],
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Welcome ', /*$userName*/
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
                      Container(
                        //height: screenHeight*0.25,
                        child: FutureBuilder<void>(
                            future: _isLoading ? null : fetchConnectionRequests(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                // Return a loading indicator while waiting for data
                                return Container(
                                  height: 200, // Adjust height as needed
                                  width:
                                  screenWidth, // Adjust width as needed
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                // Handle errors
                                return buildNoRequestsWidget(
                                    screenWidth, 'Error: ${snapshot.error}');
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (acceptedConnectionRequests.isEmpty) {
                                  // Handle the case when there are no pending connection requests
                                  return buildNoRequestsWidget(screenWidth,
                                      'No connection requests reviewed yet');
                                } else {
                                  // If data is loaded successfully, display the ListView
                                  return Container(
                                    child: _isLoading
                                        ? Center(child: CircularProgressIndicator())
                                        : acceptedConnectionRequests.isNotEmpty
                                        ? Column(
                                      children: [
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: acceptedConnectionRequests.length,
                                          itemBuilder: (context, index) {
                                            return acceptedConnectionRequests[index];
                                          },
                                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                                        ),
                                        if (_isFetchingMore)
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(),
                                          ),
                                      ],
                                    ): buildNoRequestsWidget(screenWidth, 'You currently don\'t have any new requests pending.'),
                                  );
                                }
                              }
                              return SizedBox();
                            }),
                      ),
                      Divider(),
                      const SizedBox(height: 30),
                      Center(
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color.fromRGBO(25, 192, 122, 1),
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
                                      builder: (context) =>
                                          VisitorDashboard()));
                            },
                            child: const Text('Return to Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'default',
                                )),
                          ),
                        ),
                      )
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
                      context.read<AuthCubit>().logout();
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


}
