import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Data/Data Sources/API Service (PDF Download)/apiServicePDF.dart';

/// A [SecurityAdminVisitorRequestInfoCard] widget that displays visitor request details
/// and provides options to select [Entry Time] and print a [PDF] document.
///
/// This widget includes several visitor details such as:
/// - [Name]: The visitor's name.
/// - [Organization]: The visitor's organization.
/// - [Designation]: The visitor's designation.
/// - [Phone]: The visitor's phone number.
/// - [Email]: The visitor's email address.
/// - [Sector]: The visitor's sector.
/// - [AppointmentDate]: The date and time of the appointment.
/// - [ApplicationID]: A unique identifier for the application.
/// - [Purpose]: The purpose of the visit.
/// - [Personnel]: The personnel associated with the visit.
/// - [Belongs]: The visitor's belongings.
///
/// The widget also includes:
/// - A [TextEditingController] to manage the [Entry Time] input field.
/// - A button to generate and print a [PDF] document based on the provided details and [Entry Time].
///
/// Key Actions:
/// - [_buildRow]: Helper method to build rows for displaying visitor details.
/// - [generatePDF]: Method that triggers the PDF generation process by interacting with an API service and sends the document to the printer.
/// - [onTap] on the time picker: Allows users to select [Entry Time], which is then stored in [_Clockcontroller].
///
/// The widget also handles error scenarios like missing [Entry Time] and displays appropriate messages to the user.
class SecurityAdminVisitorRequestInfoCard extends StatelessWidget {
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

  SecurityAdminVisitorRequestInfoCard({
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
  }) : super(key: key);

  late String action;
  late TextEditingController _Clockcontroller = TextEditingController();
  late String appointmentTime = '';
  String _formatDate(String dateTimeStr) {
    try {
      final dateTime = DateFormat("dd-MM-yyyy, hh:mm a").parse(dateTimeStr);
      return DateFormat("dd-MM-yyyy").format(dateTime);
    } catch (e) {
      return "Invalid date format";
    }
  }

  String _formatTime(String dateTimeStr) {
    try {
      final dateTime = DateFormat("dd-MM-yyyy, hh:mm a").parse(dateTimeStr);
      return DateFormat("hh:mm a").format(dateTime);
    } catch (e) {
      return "Invalid time format";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final formattedDate = _formatDate(AppointmentDate);
    final formattedTime = _formatTime(AppointmentDate);

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
            _buildRow('Designation', Designation),
            _buildRow('Phone', Phone),
            _buildRow('Email', Email),
            _buildRow('Sector', Sector),
            _buildRow('Appointment Start Time', '$formattedTime, $formattedDate'),
            _buildRow('Appointment End Time', '$AppointmentTime, $formattedDate'),
            _buildRow('Purpose', Purpose),
            _buildRow('Belongings', Belongs),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.07,
                  child: GestureDetector(
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((selectedTime) {
                        if (selectedTime != null) {
                          String formattedTime = DateFormat('h:mm a').format(
                            DateTime(2020, 1, 1, selectedTime.hour, selectedTime.minute),
                          );
                          print(formattedTime);
                          _Clockcontroller.text = formattedTime;
                          appointmentTime = formattedTime;
                          print(appointmentTime);
                        }
                      });
                    },
                    child: AbsorbPointer(
                      child: TextFormField(
                        keyboardType: TextInputType.datetime,
                        controller: _Clockcontroller,
                        readOnly: true,
                        enableInteractiveSelection: false,
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
                            fontSize: 16,
                            fontFamily: 'default',
                          ),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.schedule_rounded,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(13, 70, 127, 1),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
                        MediaQuery.of(context).size.height * 0.07),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(
                      width: 1,
                    ),
                  ),
                  onPressed: () {
                    generatePDF(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
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
    );
  }

  Future<void> generatePDF(BuildContext context) async {
    if (appointmentTime.isNotEmpty) {
      final apiService = await PDFGenerateAPIService.create();
      const snackBar = SnackBar(
        content: Text('Preparing Printing, Please wait'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
      print('Print Triggered!!');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        final pdfData = await apiService.generatePDF(
          id: ApplicationID,
          time: appointmentTime,
        );
        final Uri url = Uri.parse(pdfData['download_url']);
        var data = await http.get(url);
        await Printing.layoutPdf(
            onLayout: (PdfPageFormat format) async => data.bodyBytes);
        print(
            'PDF generated successfully. Download URL: ${pdfData['download_url']}');
      } catch (e) {
        print('Error generating PDF: $e');
      } finally {
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else if (appointmentTime.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Enter Entry Time first'),
      );
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
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

