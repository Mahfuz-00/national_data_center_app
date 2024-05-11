import 'package:flutter/material.dart';

import 'package:flutter_charts/flutter_charts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_charts/flutter_charts.dart' as charts;
import 'package:ndc_app/Connection%20Checker/internetconnectioncheck.dart';
import 'package:ndc_app/Profile%20UI/profileUI.dart';
import '../Graph/graphs.dart';
import '../Login UI/loginUI.dart';
import '../Template Models/userinfo.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<User> _people = [
    User(
      name: 'Md. Sajjad Hasan',
      orgName: 'Touch and Solve',
      appointmentWith: 'Munna Bhai',
      belongs: 'A bag',
      mobileNo: 01234567890,
      appointmentDate: DateTime(2024, 2, 22),
      appointmentTime: TimeOfDay(hour: 10, minute: 0),
      status: 'Pending',
    ),
    User(
      name: 'Md, Sajjad Khan',
      orgName: 'Touch and Solve',
      appointmentWith: 'Munna Bhai',
      belongs: 'A handbag',
      mobileNo: 01234567890,
      appointmentDate: DateTime(2024, 3, 31),
      appointmentTime: TimeOfDay(hour: 17, minute: 0),
      status: 'Pending',
    ),
    User(
      name: 'Md. Sajjad Munna',
      orgName: 'Touch and Solve',
      appointmentWith: 'Munna Bhai',
      belongs: 'A Guccibag',
      mobileNo: 01234567890,
      appointmentDate: DateTime(2025, 2, 22),
      appointmentTime: TimeOfDay(hour: 10, minute: 0),
      status: 'Pending',
    ),
  ];

  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    return InternetChecker(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                SizedBox(width: 28,),
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'default',
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 1.0),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: const Color.fromRGBO(13, 70, 127, 1),
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
              // Widget for Pending Requests tab
              SingleChildScrollView(
                child: SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Welcome, Admin Name',
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
                            Center(
                              child: Container(
                                width: screenWidth * 0.9,
                                //height: screenHeight * 0.25,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width:
                                                    MediaQuery.of(context).size.width *
                                                        0.27,
                                                height:
                                                    MediaQuery.of(context).size.height *
                                                        0.12,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius: const BorderRadius.all(
                                                      Radius.circular(20)),
                                                ),
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 100,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
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
                                                text:
                                                    'Organization Name: Touch and Solve\n',
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
                                                text:
                                                    'Appointment Time & Date: 11:30, 15 February 2024\n',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'default',
                                                )),
                                            TextSpan(
                                                text:
                                                    'Entry Time & Date: 11:28, 15 February 2024\n',
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
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center ,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                                              fixedSize: Size(MediaQuery.of(context).size.width * 0.35,
                                                  MediaQuery.of(context).size.height * 0.06),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                             /* action = 'accepted';
                                              handleAcceptOrReject(action);*/
                                              const snackBar = SnackBar(
                                                content: Text('Processing...'),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              Future.delayed(Duration(seconds: 2), () {
                                                /*Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => NTTNDashboard(shouldRefresh: true)),
                                                );*/
                                                const snackBar = SnackBar(
                                                  content: Text('Request Accepted!'),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            },
                                            child: Text('Accept',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'default',
                                                )),
                                          ),
                                          SizedBox(width: 10,),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              fixedSize: Size(MediaQuery.of(context).size.width * 0.35,
                                                  MediaQuery.of(context).size.height * 0.06),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () {
                                              /*action = 'rejected';
                                              handleAcceptOrReject(action);*/
                                              const snackBar = SnackBar(
                                                content: Text('Processing...'),
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              Future.delayed(Duration(seconds: 2), () {
                                               /* Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>
                                                      NTTNDashboard(shouldRefresh: true)),
                                                );*/
                                                const snackBar = SnackBar(
                                                  content: Text('Request Rejected!'),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                              });
                                            },
                                            child: Text('Decline',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'default',
                                                )),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
                                  child: chartToRunLine()),
                            ),
                            SizedBox(height: 25),
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
                                  child: chartToRunVertical()),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              // Widget for Accepted Requests tab
              SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Welcome, Admin Name',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'default',
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Accepted List',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          ),
                        ),
                        const SizedBox(height: 5),
                        _buildPanel(),
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
                              child: chartToRunLine()),
                        ),
                        SizedBox(height: 25),
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
                              child: chartToRunVertical()),
                        )
                      ],
                    ),
                  ),
                ),
              )
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminDashboard()));
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


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('Logout Confirmation',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'default',
                ),),
              Divider()
            ],
          ),
          content: Text('Are you sure you want to log out?',
            style: TextStyle(
              color: const Color.fromRGBO(13, 70, 127, 1),
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'default',
            ),),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel',
                    style: TextStyle(
                      color: const Color.fromRGBO(13, 70, 127, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),),
                ),
                SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Login()));
                  },
                  child: Text('Logout',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'default',
                    ),),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildPanel() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _people[index].isExpanded = isExpanded;
        });
      },
      children: _people.map<ExpansionPanel>((User user) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                visualDensity: VisualDensity(vertical: -4),
                tileColor: Colors.white,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: isExpanded ? 20 : 12,
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
                    ),
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
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 100,
                            ),
                          ),
                        ],
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
                          Text(
                              'Appointment Date: ${DateFormat('dd.MM.yyyy').format(user.appointmentDate)}, ${user.appointmentTime.hour.toString().padLeft(2, '0')}:${user.appointmentTime.minute.toString().padLeft(2, '0')} ${user.appointmentTime.period == DayPeriod.am ? 'AM' : 'PM'}',
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
              ),
            ],
          ),
          isExpanded: user.isExpanded,
          backgroundColor: Colors.white,
        );
      }).toList(),
    );
  }
}
