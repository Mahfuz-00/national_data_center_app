import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget that displays detailed information about a visitor's request,
/// including their personal details, appointment information, and request status.
///
/// Variables:
/// - [Name]: The name of the visitor.
/// - [Organization]: The organization the visitor is affiliated with.
/// - [Designation]: The visitor's job designation.
/// - [Phone]: The visitor's phone number.
/// - [Email]: The visitor's email address.
/// - [Sector]: The sector associated with the visitor.
/// - [AppointmentDate]: The date and time of the visitor's appointment.
/// - [Purpose]: The purpose of the visitor's appointment.
/// - [Personnel]: The personnel the visitor is meeting.
/// - [Belongs]: The belongings that the visitor has with them.
/// - [Status]: The status of the visitor's request (e.g., pending, approved).
///
/// Actions:
/// - Displays each piece of information in a row format with labels on the left and corresponding values on the right.
/// - Uses [_buildRow] to create a consistent layout for displaying text information.
/// - Uses [_buildRowTime] to format and display the appointment date and time with proper formatting.
class VisitorRequestInfoCard extends StatelessWidget {
  final String Name;
  final String Organization;
  final String Designation;
  final String Phone;
  final String Email;
  final String Sector;
  final String AppointmentDate;
  final String Purpose;
  final String Belongs;
  final String Status;

  const VisitorRequestInfoCard({
    Key? key,
    required this.Name,
    required this.Organization,
    required this.Designation,
    required this.Phone,
    required this.Email,
    required this.Sector,
    required this.AppointmentDate,
    required this.Purpose,
    required this.Belongs,
    required this.Status,
  }) : super(key: key);

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
            _buildRow('Appoinment Date and Time', AppointmentDate),
            _buildRow('Purpose', Purpose),
            _buildRow('Belongings', Belongs),
            _buildRow('Status', Status),
          ],
        ),
      ),
    );
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

