import 'sources.dart';

class Records {
  final int id;
  final String recordId;
  final Sources source;
  final String employeeCode;
  final String? employeeName;
  final DateTime attendanceTime;
  final DateTime? createdTime;
  final DateTime? syncedTime;
  static String tableName = 'records';

  Records({
    required this.id,
    required this.recordId,
    required this.source,
    required this.employeeCode,
    this.employeeName,
    required this.attendanceTime,
    this.createdTime,
    this.syncedTime,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "record_id": recordId,
    "source_id": source.sourceId,
    "employee_code": employeeCode,
    "employee_name": employeeName ?? "",
    "attendance_time": attendanceTime.toUtc().millisecondsSinceEpoch,
    "created_time": createdTime?.toUtc().millisecondsSinceEpoch ?? DateTime.now().toUtc().millisecondsSinceEpoch,
    "synced_time": syncedTime?.toUtc().millisecondsSinceEpoch,
  };

  @override
  String toString() {
    return 'Records{record_id: $recordId, source_name: ${source.name}, employee_code: $employeeCode, attendance_time: $attendanceTime}';
  }
}
