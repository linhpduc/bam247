import 'sources.dart';

class Records {
  final String id;
  final Sources source;
  final String employeeCode;
  final String? employeeName;
  final DateTime attendanceTime;
  final DateTime? createdTime;
  final DateTime? syncedTime;

  Records({
    required this.id, 
    required this.source,
    required this.employeeCode,
    this.employeeName,
    required this.attendanceTime,
    this.createdTime,
    this.syncedTime,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "source_id": source.id,
    "employee_code": employeeCode,
    "employee_name": employeeName,
    "attendance_time": attendanceTime,
    "created_time": createdTime,
    "synced_time": syncedTime,
  };

  @override
  String toString() {
    return 'Records{id: $id, source_id: $source, employee_code: $employeeCode, attendance_time: $attendanceTime}';
  }
}
