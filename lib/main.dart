import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_printer/flutter_printer.dart';

import 'UI/Splashscreen UI/splashscreenUI.dart';
import 'package:rename_app/rename_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(13, 70, 127, 1), // Change the status bar color here
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NDC Access',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromRGBO(13, 70, 127, 1)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
