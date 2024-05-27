import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_printer/flutter_printer.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../API Service (PDF Download)/apiServicePDF.dart';

class VisitorRequestInfoCardSecurityAdmin extends StatelessWidget {
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


  VisitorRequestInfoCardSecurityAdmin({
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
  }) : super(key: key);

  late String action;
  late TextEditingController _Clockcontroller= TextEditingController();
  late String appointmentTime = '';

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
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.4,
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
                        fontSize: 16,
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
                              // Convert selectedTime to a formatted string
                              /*String formattedTime =
                                            selectedTime.hour.toString().padLeft(2, '0') +
                                                ':' +
                                                selectedTime.minute.toString().padLeft(2, '0');*/
                              String formattedTime =
                              DateFormat('h:mm a').format(
                                DateTime(
                                    2020,
                                    1,
                                    1,
                                    selectedTime.hour,
                                    selectedTime.minute),
                              );
                              print(formattedTime);
                              // Set the formatted time to the controller
                              _Clockcontroller.text = formattedTime;
                              appointmentTime = formattedTime;
                              print(appointmentTime);
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
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.4, MediaQuery.of(context).size.height * 0.07),
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
    );
  }

  Future<void> generatePDF(BuildContext context) async {
   if(appointmentTime.isNotEmpty){
     final apiService = await APIServiceNDCPDF.create();
     const snackBar = SnackBar(
       content: Text(
           'Printing'),
     );
     ScaffoldMessenger.of(context as BuildContext).showSnackBar(snackBar);
     print('Print Triggered!!');
     // Example usage: Generate PDF
     try {
       final pdfData = await apiService.generatePDF(
         id: ApplicationID,
         time: appointmentTime,
       );
       final Uri url = Uri.parse(pdfData['download_url']);
       var data = await http.get(url);
       await Printing.layoutPdf(
           onLayout: (PdfPageFormat format) async => data.bodyBytes);
/*       await Printing.sharePdf(bytes: await doc.save(), filename: 'my-document.pdf');
       await Printing.printPdf(bytes: data.bodyBytes, filename: 'Appointment.pdf');*/
       //await Printer.printMapJsonLog(url: {pdfData['download_url']}, name: 'Document.pdf');
       //await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => doc.save());
       // Handle the response data
       print('PDF generated successfully. Download URL: ${pdfData['download_url']}');
/*       ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: GestureDetector( // Wrap Text with GestureDetector
               child: Text('Print Appointment: ${pdfData['download_url']}', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
               onTap: () async {

               },
             ),
             action: SnackBarAction(
               label: 'Print',
               onPressed: () async {
                 String url = pdfData['download_url'];// Launch URL when tapped
                 if (await canLaunch(url)) {
                 await launch(url);
                 } else {
                 throw 'Could not launch $url';
                 }
               },
             ),
           ),
       );*/
     } catch (e) {
       // Handle any errors
       print('Error generating PDF: $e');
     }
   }
   else if (appointmentTime.isEmpty){
     const snackBar = SnackBar(
       content: Text(
           'Enter Entry Time first'),
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



