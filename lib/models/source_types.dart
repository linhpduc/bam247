class SourceTypes {
  final int id;
  final String code;
  final String name;
  static String tableName = 'source_types';

  SourceTypes({required this.id, required this.code, required this.name});

  Map<String, dynamic> toMap() => {
    "id": id,
    "code": code,
    "name": name,
  };

  @override
  String toString() {
    return 'SourceTypes{code: $code, name: $name}';
  }
}

SourceTypes typeSample = SourceTypes(id: 1, code: "machine", name: "Attendance Machine");
