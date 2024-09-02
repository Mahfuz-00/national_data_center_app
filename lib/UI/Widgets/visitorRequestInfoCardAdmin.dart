import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Data/Data Sources/API Service (Accept or Decline)/apiServiceAcceptOrDecline.dart';
import '../Pages/Admin Dashboard/admindashboardUI.dart';


class VisitorRequestInfoCardAdmin extends StatelessWidget {
  final String Name;
  final String Organization;
  final String Designation;
  final String Phone;
  final String Email;
  final String Sector;
  final String AppointmentDate;
  final int ApplicationID;
  final String Purpose;
  final String Personnel;
  final String Belongs;
  final String Status;

  VisitorRequestInfoCardAdmin({
    Key? key,
    required this.Name,
    required this.Organization,
    required this.Designation,
    required this.Phone,
    required this.Email,
    required this.Sector,
    required this.ApplicationID,
    required this.AppointmentDate,
    required this.Purpose,
    required this.Personnel,
    required this.Belongs,
    required this.Status,
  }) : super(key: key);

  late String action;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        //width: screenWidth*0.9,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Visitor Name', Name),
            _buildRow('Organization', Organization),
            _buildRow('Desination', Designation),
            _buildRow('Phone', Phone),
            _buildRow('Email', Email),
            _buildRow('Sector', Sector),
            _buildRow('Appoinment Date and Time', AppointmentDate),
            _buildRow('Purpose', Purpose),
            _buildRow('Personnel', Personnel),
            _buildRow('Belongings', Belongs),
            _buildRow('Status', Status),
            Divider(),
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
                       action = 'accepted';
                       handleAcceptOrReject(action);
                      const snackBar = SnackBar(
                        content: Text('Processing...'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => AdminDashboard(shouldRefresh: true)),
                                                );
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
                      action = 'rejected';
                      handleAcceptOrReject(action);
                      const snackBar = SnackBar(
                        content: Text('Processing...'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Future.delayed(Duration(seconds: 2), () {
                         Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>
                                                      AdminDashboard(shouldRefresh: true)),
                                                );
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
    );
  }

  // Function to handle accept or reject action
  Future<void> handleAcceptOrReject(String Action) async {
    final apiService = await ConnectionAcceptRejectAPIService.create();

    print(Action);
    print(ApplicationID);
    if (action.isNotEmpty) {
      await apiService.acceptOrRejectConnection(type: Action, ApplicationId: ApplicationID);
    } else {
      print('Action or ISP connection ID is missing');
    }
  }


}

Widget _buildRow(String label, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          ":",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildRowTime(String label, String value) {
  //String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm a').format(value); // 'a' for AM/PM

  // Parse the date and time string
  DateTime dateTime = DateFormat('dd-MM-yyyy, hh:mm a').parse(value);

  // Format the date and time
  String formattedDateTime = DateFormat('dd-MM-yyyy, hh:mm a').format(dateTime);
  DateTime date = DateTime.parse(value);
  DateFormat dateFormat = DateFormat.yMMMMd('en_US');
  DateFormat timeFormat = DateFormat.jm();
  String formattedDate = dateFormat.format(date);
  String formattedTime = timeFormat.format(date);
  //String formattedDateTime = '$formattedDate, $formattedTime';
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  height: 1.6,
                  letterSpacing: 1.3,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'default',
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          ":",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Expanded(
        child: Text(
          formattedDateTime, // Format date as DD/MM/YYYY
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            height: 1.6,
            letterSpacing: 1.3,
            fontWeight: FontWeight.bold,
            fontFamily: 'default',
          ),
        ),
      ),
    ],
  );
}



