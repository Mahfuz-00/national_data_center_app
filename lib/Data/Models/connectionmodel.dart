/// Represents an appointment request model.
///
/// This class encapsulates all the necessary information required to create
/// an appointment request for an individual.
///
/// **Variables:**
/// - [FullName]: A String representing the full name of the individual.
/// - [NID]: A String representing the National Identification Number of the individual.
/// - [OrganizationName]: A String representing the name of the organization the individual is associated with.
/// - [Designation]: A String representing the individual's designation or job title.
/// - [Mobile]: A String representing the mobile phone number of the individual.
/// - [Email]: A String representing the email address of the individual.
/// - [Purpose]: A String describing the purpose of the appointment.
/// - [Personnel]: A String indicating the name of the personnel related to the appointment.
/// - [Belongs]: A String indicating to whom or what the individual belongs (e.g., department, group).
/// - [Sector]: A String representing the sector related to the appointment.
/// - [DeviceModel]: A String representing the model of the device the individual is using.
/// - [DeviceSerial]: A String representing the serial number of the device.
/// - [DeviceDescription]: A String providing a description of the device.
/// - [AppointmentDate]: A String representing the date of the appointment.
/// - [AppointmentTime]: A String representing the time of the appointment.
class AppointmentRequestModel {
  final String FullName;
  final String NID;
  final String OrganizationName;
  final String Designation;
  final String Mobile;
  final String Email;
  final String Purpose;
  final String Belongs;
  final String Sector;
  final String DeviceModel;
  final String DeviceSerial;
  final String DeviceDescription;
  final String AppointmentStartDate;
  final String AppointmentStartTime;
  final String AppointmentEndDate;
  final String AppointmentEndTime;

  AppointmentRequestModel({
    required this.FullName,
    required this.NID,
    required this.OrganizationName,
    required this.Designation,
    required this.Mobile,
    required this.Email,
    required this.Purpose,
    required this.Belongs,
    required this.Sector,
    required this.DeviceModel,
    required this.DeviceSerial,
    required this.DeviceDescription,
    required this.AppointmentStartDate,
    required this.AppointmentStartTime,
    required this.AppointmentEndDate,
    required this.AppointmentEndTime,
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
      'belong': Belongs,
      'sector': Sector,
      'device_model': DeviceModel,
      'device_serial': DeviceSerial,
      'device_description': DeviceDescription,
      'date': AppointmentStartDate,
      'time': AppointmentStartTime,
      'to_date': AppointmentEndDate,
      'to_time': AppointmentEndTime,
    };
  }
}
