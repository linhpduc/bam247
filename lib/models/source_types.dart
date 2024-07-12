class SourceTypes {
  final String code;
  final String name;

  SourceTypes({required this.code, required this.name});

  Map<String, dynamic> toMap() => {
    "code": code,
    "name": name,
  };

  @override
  String toString() {
    return 'SourceTypes{code: $code, name: $name}';
  }
}

SourceTypes machine = SourceTypes(code: "machine", name: "Attendance Machine");
