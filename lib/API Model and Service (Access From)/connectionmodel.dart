class AppointmentRequestModel {
  final String Purpose;
  final String Belongs;
  final String Sector;
  final String AppointmentDate;
  final String AppointmentTime;


  AppointmentRequestModel({
  required this.Purpose,
  required this.Belongs,
  required this.Sector,
  required this.AppointmentDate,
  required this.AppointmentTime,
  });

  Map<String, dynamic> toJson() {
    return {
    'purpose': Purpose,
    'belong': Belongs,
    'sector': Sector,
    'date': AppointmentDate,
    'time': AppointmentTime,
    };
  }
}
