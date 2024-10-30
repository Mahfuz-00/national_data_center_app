/// Represents a guest appointment request model.
///
/// This class encapsulates all the necessary information required to create
/// an appointment request for a guest.
///
/// **Variables:**
/// - [FullName]: A string representing the full name of the guest.
/// - [NID]: A string representing the National Identification Number of the guest.
/// - [OrganizationName]: A string representing the name of the organization the guest is associated with.
/// - [Designation]: A string representing the guest's designation or job title.
/// - [Mobile]: A string representing the mobile phone number of the guest.
/// - [Email]: A string representing the email address of the guest.
/// - [Purpose]: A string describing the purpose of the appointment.
/// - [Belongs]: A string indicating to whom or what the guest belongs (e.g., department, group).
/// - [Sector]: A string representing the sector related to the appointment.
/// - [DeviceModel]: A string representing the model of the device the guest is using.
/// - [DeviceSerial]: A string representing the serial number of the device.
/// - [DeviceDescription]: A string providing a description of the device.
/// - [AppointmentDate]: A string representing the date of the appointment.
/// - [AppointmentTime]: A string representing the time of the appointment.
class GuestAppointmentModel {
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
  final String AppointmentDate;
  final String AppointmentFromTime;
  final String AppointmentToTime;

  GuestAppointmentModel({
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
    required this.AppointmentDate,
    required this.AppointmentFromTime,
    required this.AppointmentToTime,
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
      'device_model': DeviceModel,
      'device_serial': DeviceSerial,
      'device_description': DeviceDescription,
      'date': AppointmentDate,
      'time': AppointmentFromTime,
      'to_time': AppointmentToTime,
    };
  }
}
