import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../User Type Dashboard(Demo)/DemoAppDashboard.dart';
import '../Visitor Dashboard/visitordashboardUI.dart';

class AccessForm extends StatefulWidget {
  const AccessForm({super.key});

  @override
  State<AccessForm> createState() => _AccessFormState();
}

class _AccessFormState extends State<AccessForm> {
  late TextEditingController _Clockcontroller= TextEditingController();
  late TextEditingController _Datecontroller= TextEditingController();

  @override
  void dispose() {
    _Clockcontroller.dispose();
    _Datecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        title: const Text(
          'Access Form',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'default',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 25,),
                  Text('Access Form', style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                      fontFamily: 'default'
                  )),
                  SizedBox(height:20),
                  Container(
                    width: screenWidth*0.8,
                    height: screenHeight*0.15,
                    child: TextFormField(
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Purpose of the Visit (Reason)',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        alignLabelWithHint: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: screenHeight * 0.15),
                        border:  const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: screenWidth*0.8,
                    height: screenHeight*0.075,
                    //padding: EdgeInsets.all(20),
                    /*decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),),*/
                    child: TextFormField(
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Belongs',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: screenWidth*0.8,
                    height: screenHeight*0.075,
                    child: TextFormField(
                      controller: _Datecontroller,
                      readOnly: true,
                      enableInteractiveSelection: false,
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Appointment Date',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            ).then((selectedDate) {
                              if (selectedDate != null) {
                                final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
                                _Datecontroller.text = formattedDate;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
                            child: Icon(Icons.calendar_today_outlined, size: 40,),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: screenWidth*0.8,
                    height: screenHeight*0.075,
                    child: TextFormField(
                      controller: _Clockcontroller,
                      readOnly: true, // Make the text field readonly
                      enableInteractiveSelection: false, // Disable interactive selection
                      style: const TextStyle(
                        color: Color.fromRGBO(143, 150, 158, 1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'default',
                      ),
                      decoration: InputDecoration(
                        labelText: 'Appointment Time',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'default',
                        ),
                        border: const OutlineInputBorder(
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
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
                            child: Icon(Icons.schedule_rounded, size: 40,),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 60,),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(25, 192, 122, 1),
                        fixedSize: Size(MediaQuery.of(context).size.width* 0.8, MediaQuery.of(context).size.height * 0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => VisitorDashboard()));
                      },
                      child: const Text('Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'default',
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: screenHeight* 0.08,
        color: const Color.fromRGBO(25, 192, 122, 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth/3,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight*0.025,
                    width: screenWidth*0.04,
                    child: IconButton(
                      icon: const Icon(Icons.home,
                      size: 20,
                      color: Colors.white,),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => NDCDashboard()));
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Home',
                    style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'default',
                  ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  )
              ),
              width: screenWidth/3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight*0.025,
                    width: screenWidth*0.04,
                    child: IconButton(
                      icon: const Icon(Icons.search,
                      size: 20,
                      color: Colors.white,),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        /*Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ));*/
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'default',
                    ),),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  )
              ),
              width: screenWidth/3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenHeight*0.025,
                    width: screenWidth*0.04,
                    child: IconButton(
                      icon: const Icon(Icons.info,
                      size: 20,
                      color: Colors.white,),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        /*Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ));*/
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text('Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'default',
                    ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
