class SourceTypeModel {
  final int id;
  final String code;
  final String name;
  static String tableName = 'source_types';

  SourceTypeModel({required this.id, required this.code, required this.name});

  Map<String, dynamic> toMap() => {
    "id": id,
    "code": code,
    "name": name,
  };

  @override
  String toString() {
    return 'SourceTypeModel{code: $code, name: $name}';
  }
}

SourceTypeModel typeSample = SourceTypeModel(id: 1, code: "machine", name: "Attendance Machine");
