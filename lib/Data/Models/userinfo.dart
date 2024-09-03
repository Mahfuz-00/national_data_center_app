import 'package:flutter/material.dart';

/// Represents a user with appointment details.
///
/// This class encapsulates all the necessary information about a user,
/// including personal details and appointment specifics.
///
/// **Variables:**
/// - [name]: A String that holds the user's name.
/// - [orgName]: A String indicating the user's organization name.
/// - [appointmentWith]: A String specifying who the appointment is with.
/// - [belongs]: A String indicating the group or category the user belongs to.
/// - [mobileNo]: An int representing the user's mobile number.
/// - [appointmentDate]: A DateTime object for the date of the appointment.
/// - [appointmentTime]: A TimeOfDay object for the time of the appointment.
/// - [status]: A String that reflects the current status of the appointment.
/// - [isExpanded]: A bool indicating whether the user's details are expanded in the UI (default is false).

class UserModel {
  late String name;
  late String orgName;
  late String appointmentWith;
  late String belongs;
  late int mobileNo;
  late DateTime appointmentDate;
  late TimeOfDay appointmentTime;
  late String status;
  bool isExpanded;

  UserModel({
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