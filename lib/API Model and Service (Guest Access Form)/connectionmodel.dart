class GuestAppointmentRequestModel {
  final String FullName;
  final String NID;
  final String OrganizationName;
  final String Designation;
  final String Mobile;
  final String Email;
  final String Purpose;
  final String Belongs;
  final String Sector;
  final String AppointmentDate;
  final String AppointmentTime;

  GuestAppointmentRequestModel({
    required this.FullName,
    required this.NID,
    required this.OrganizationName,
    required this.Designation,
    required this.Mobile,
    required this.Email,
    required this.Purpose,
    required this.Belongs,
    required this.Sector,
    required this.AppointmentDate,
    required this.AppointmentTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'guest_name': FullName,
      'guest_identification': NID,
      'guest_organization': OrganizationName,
      'guest_designation': Designation,
      'guest_phone': Mobile,
      'guest_email': Email,
      'purpose': Purpose,
      'belong': Belongs,
      'sector': Sector,
      'date': AppointmentDate,
      'time': AppointmentTime,
    };
  }
}
