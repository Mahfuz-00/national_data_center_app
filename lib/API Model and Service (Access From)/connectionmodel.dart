class AppointmentRequestModel {
  final String Purpose;
  final String Belongs;
  final String AppointmentWith;
  final String AppointmentDate;
  final String AppointmentTime;


  AppointmentRequestModel({
  required this.Purpose,
  required this.Belongs,
  required this.AppointmentWith,
  required this.AppointmentDate,
  required this.AppointmentTime,
  });

  Map<String, dynamic> toJson() {
    return {
    'purpose': Purpose,
    'belong': Belongs,
    'appoint_mentor': AppointmentWith,
    'date': AppointmentDate,
    'time': AppointmentTime,
    };
  }
}
