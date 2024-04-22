import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Graph/graphs.dart';
import '../Login UI/loginUI.dart';
import '../Template Models/userinfo.dart';
import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';

class SecurityAdminDashboard extends StatefulWidget {
  const SecurityAdminDashboard({super.key});

  @override
  State<SecurityAdminDashboard> createState() => _SecurityAdminDashboardState();
}

class _SecurityAdminDashboardState extends State<SecurityAdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _Clockcontroller= TextEditingController();

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

  @override
  void dispose() {
    _Clockcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 70, 127, 1),
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          'Security Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded, color: Colors.white,),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert_outlined, color: Colors.white,),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(13, 70, 127, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      size: 35,
                    ),
                    radius: 30,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'User Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Home',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NDCDashboard())); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              title: Text('Information',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));*/
              },
            ),
            Divider(),
            ListTile(
              title: Text('Logout',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'default',)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login())); // Close the drawer
              },
            ),
            Divider(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Welcome, Security Admin Name',
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
                  const Text('Appointment Approved List',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      )),
                  const SizedBox(height: 5),
                  Container(
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
                          children: [
                            Container(
                              width: screenWidth*0.35,
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
                                fixedSize: Size(MediaQuery.of(context).size.width* 0.5, MediaQuery.of(context).size.height * 0.07),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: BorderSide(
                                  width: 1,
                               ),
                              ),
                              onPressed: () {
                                /*Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => AccessForm()));*/
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
                  ),
                  _buildPanel(_people),
                  const SizedBox(height: 10),
                  SizedBox(height: 15),
                  Text('Daily Analytic Graph',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',),),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.35,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            )
                        ),
                        child: chartToRunLine()
                    ),
                  ),
                  SizedBox(height: 25),
                  Text('Monthly Analytic Graph',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'default',),),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.35,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            )
                        ),
                        child: chartToRunVertical()
                    ),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NDCDashboard()));
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
              onTap: (){
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchUser()));*/
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
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Search',
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
              onTap: (){
                /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Information()));*/
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
                      Icons.info,
                      size: 30,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Information',
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
    );
  }

  Widget _buildPanel(List<User> users) {
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
                  children: [
                    Container(
                      width: screenWidth * 0.35,
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
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.07),
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
  }
}
