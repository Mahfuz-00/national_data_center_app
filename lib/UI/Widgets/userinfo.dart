import 'package:flutter/material.dart';

class User {
  late String name;
  late String orgName;
  late String appointmentWith;
  late String belongs;
  late int mobileNo;
  late DateTime appointmentDate;
  late TimeOfDay appointmentTime;
  late String status;
  bool isExpanded;

  User({
  required this.name,
  required this.orgName,
  required this.appointmentWith,
  required this.belongs,
  required this.mobileNo,
  required this.appointmentDate,
  required this.appointmentTime,
  required this.status,
    this.isExpanded = false,
  });
}