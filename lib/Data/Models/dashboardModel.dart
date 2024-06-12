class DashboardItem {
  final String name;
  final String organization;
  final String appointmentwith;
  final String belongs;
  final String phone;
  final String appointmentdateandtime;
  final int applicationID;
  final String status;

  DashboardItem({
    required this.name,
    required this.organization,
    required this.appointmentwith,
    required this.belongs,
    required this.phone,
    required this.appointmentdateandtime,
    required this.applicationID,
    required this.status,
  });

  factory DashboardItem.fromJson(Map<String, dynamic> json) {
    return DashboardItem(
      name: json['name'],
      organization: json['organization'],
      appointmentwith: json['appointment_with'],
      belongs: json['belong'],
      phone: json['phone'],
      appointmentdateandtime: json['appointment_date_time'],
      applicationID: json['appointment_id'],
      status: json['status'],
    );
  }
}