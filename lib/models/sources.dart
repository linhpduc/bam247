import '../constants.dart';

class SourceModel {
  final int? id;
  final String sourceId;
  String name;
  String? description;
  SourceTypeModel typeCode;
  int? intervalInSeconds;
  int? realtimeEnabled;
  String? clientEndpoint;
  String? clientId;
  String? clientSecret;
  DateTime? createdTime;
  
  static String tableName = 'sources';

  SourceModel({
    this.id, 
    required this.sourceId,
    required this.name, 
    this.description, 
    required this.typeCode, 
    this.intervalInSeconds = 600, 
    this.realtimeEnabled = 0, 
    this.clientEndpoint, 
    this.clientId, 
    this.clientSecret, 
    this.createdTime,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "source_id": sourceId,
    "name": name,
    "description": description ?? "",
    "type_code": typeCode.code,
    "interval_in_seconds": intervalInSeconds ?? 600,
    "realtime_enabled": realtimeEnabled ?? 0,
    "client_endpoint": clientEndpoint,
    "client_id": clientId,
    "client_secret": clientSecret,
    "created_time": createdTime?.toUtc().millisecondsSinceEpoch,
  };

  factory SourceModel.fromMap(Map<String, dynamic> map) => SourceModel(
    id: map["id"],
    sourceId: map["source_id"],
    name: map["name"],
    description: map["description"],
    typeCode: SourceTypeModel.values.byName(map["type_code"]),
    intervalInSeconds: map["interval_in_seconds"],
    realtimeEnabled: map["realtime_enabled"],
    clientEndpoint: map["client_endpoint"],
    clientId: map["client_id"],
    clientSecret: map["client_secret"],
    createdTime: DateTime.fromMillisecondsSinceEpoch(map["created_time"]),
  );

  @override
  String toString() {
    return 'SourceModel{source_id: $sourceId, name: $name, type: $typeCode}';
  }
}

SourceModel s1 = SourceModel(
      id: 1,
      sourceId: "s_a46058eb9418",
      name: "Văn phòng HN",
      description: "",
      typeCode: SourceTypeModel.machine,
      intervalInSeconds: 600,
      realtimeEnabled: 0,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));
SourceModel s2 = SourceModel(
      id: 2,
      sourceId: "s_84fc085cf219",
      name: "Chi nhánh HCM",
      description: "",
      typeCode:SourceTypeModel.machine,
      intervalInSeconds: 600,
      realtimeEnabled: 0,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));
SourceModel s3 = SourceModel(
      id: 3,
      sourceId: "s_c4229d8e5f74",
      name: "Thủ phủ Đà Nẵng",
      description: "",
      typeCode: SourceTypeModel.machine,
      intervalInSeconds: 600,
      realtimeEnabled: 0,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));

List<SourceModel> mySources = [s1, s2,s3];