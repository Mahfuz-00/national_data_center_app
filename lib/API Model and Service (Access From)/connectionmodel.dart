class AppointmentRequestModel {
  final String FullName;
  final String NID;
  final String OrganizationName;
  final String Designation;
  final String Mobile;
  final String Email;
  final String Purpose;
  final String Personnel;
  final String Belongs;
  final String Sector;
  final String DeviceModel;
  final String DeviceSerial;
  final String DeviceDescription;
  final String AppointmentDate;
  final String AppointmentTime;

  AppointmentRequestModel({
    required this.FullName,
    required this.NID,
    required this.OrganizationName,
    required this.Designation,
    required this.Mobile,
    required this.Email,
    required this.Purpose,
    required this.Personnel,
    required this.Belongs,
    required this.Sector,
    required this.DeviceModel,
    required this.DeviceSerial,
    required this.DeviceDescription,
    required this.AppointmentDate,
    required this.AppointmentTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': FullName,
      'identification': NID,
      'organization': OrganizationName,
      'designation': Designation,
      'phone': Mobile,
      'email': Email,
      'purpose': Purpose,
      'name_of_personnel': Personnel,
      'belong': Belongs,
      'sector': Sector,
      'device_model': DeviceModel,
      'device_serial': DeviceSerial,
      'device_description': DeviceDescription,
      'date': AppointmentDate,
      'time': AppointmentTime,
    };
  }
}
