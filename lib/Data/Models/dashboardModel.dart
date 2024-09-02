/// Represents an item in the dashboard.
///
/// This class holds information about a specific appointment request
/// and is used to display relevant details in the dashboard.
///
/// **Variables:**
/// - [name]: A String representing the name of the individual associated with the appointment.
/// - [organization]: A String representing the name of the organization of the individual.
/// - [appointmentwith]: A String indicating whom the appointment is with.
/// - [belongs]: A String representing to whom or what the individual belongs (e.g., department, group).
/// - [phone]: A String representing the phone number of the individual.
/// - [appointmentdateandtime]: A String representing the date and time of the appointment.
/// - [applicationID]: An int representing the unique application ID of the appointment.
/// - [status]: A String representing the current status of the appointment.
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