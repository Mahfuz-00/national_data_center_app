import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Data/Data Sources/API Service (Accept or Decline)/apiServiceAcceptOrDecline.dart';
import '../Pages/Admin Dashboard/admindashboardUI.dart';

/// [AdminVisitorRequestInfoCard] is a [StatelessWidget] that represents a detailed information card
/// for visitor requests in an admin panel. It displays various details such as the [Name], [Organization],
/// [Designation], [Phone], [Email], [Sector], [AppointmentDate], [ApplicationID], [Purpose],
/// [Personnel], [Belongs], and [Status] of the visitor request.
///
/// The widget provides options for the admin to [Accept] or [Decline] the request using two buttons.
/// Upon pressing one of these buttons, the appropriate [action] ('accepted' or 'rejected') is taken,
/// which triggers the [handleAcceptOrReject] method. This method interacts with the
/// [AccessAcceptRejectAPIService] to update the request's status via an API call.
///
/// The [handleAcceptOrReject] method makes an API call to accept or reject the visitor request based on
/// the [Action] provided, and then navigates back to the [AdminDashboardUI] with a success message.
///
/// The UI is built using [Material] and [Container] widgets with styling for the layout, buttons, and text.
class AdminVisitorRequestInfoCard extends StatelessWidget {
  final String Name;
  final String Organization;
  final String Designation;
  final String Phone;
  final String Email;
  final String Sector;
  final String AppointmentDate;
  final String AppointmentTime;
  final int ApplicationID;
  final String Purpose;
  final String Belongs;
  final String Status;

  AdminVisitorRequestInfoCard({
    Key? key,
    required this.Name,
    required this.Organization,
    required this.Designation,
    required this.Phone,
    required this.Email,
    required this.Sector,
    required this.ApplicationID,
    required this.AppointmentDate,
    required this.AppointmentTime,
    required this.Purpose,
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
            _buildRow('Appoinment Start Date and Time', AppointmentDate),
            _buildRow('Appoinment End Time', AppointmentTime),
            _buildRow('Purpose', Purpose),
            _buildRow('Belongings', Belongs),
            _buildRow('Status', Status),
            Divider(),
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminDashboardUI(shouldRefresh: true)),
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
                  SizedBox(
                    width: 10,
                  ),
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
                          MaterialPageRoute(
                              builder: (context) =>
                                  AdminDashboardUI(shouldRefresh: true)),
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

  Future<void> handleAcceptOrReject(String Action) async {
    final apiService = await AccessAcceptRejectAPIService.create();

    print(Action);
    print(ApplicationID);
    if (action.isNotEmpty) {
      await apiService.acceptOrRejectConnection(
          type: Action, ApplicationId: ApplicationID);
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
