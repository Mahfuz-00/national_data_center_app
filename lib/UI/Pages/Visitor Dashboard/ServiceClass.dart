import 'package:flutter/material.dart';
import 'package:ndc_app/UI/Pages/Visitor%20Dashboard/visitordashboardUI.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> callFetchConnectionRequests() async {
    // Create an instance of VisitorDashboardUI
    final visitorDashboard = VisitorDashboardUI();
    await visitorDashboard.fetchRequests();
  }
}
