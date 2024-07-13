import 'source_types.dart';

class Sources {
  final int id;
  final String sourceId;
  final String name;
  final String? description;
  final SourceTypes type;
  final int? intervalInSeconds;
  final bool? realtimeEnabled;
  final String clientEndpoint;
  final String clientId;
  final String clientSecret;
  final DateTime? createdTime;
  static String tableName = 'sources';

  Sources({
    required this.id, 
    required this.sourceId,
    required this.name, 
    this.description, 
    required this.type, 
    this.intervalInSeconds, 
    this.realtimeEnabled, 
    required this.clientEndpoint, 
    required this.clientId, 
    required this.clientSecret, 
    this.createdTime,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "source_id": sourceId,
    "name": name,
    "description": description ?? "",
    "type": type.name,
    "interval_in_seconds": intervalInSeconds ?? 600,
    "realtime_enabled": realtimeEnabled ?? 0,
    "client_endpoint": clientEndpoint,
    "client_id": clientId,
    "client_secret": clientSecret,
    "created_time": createdTime?.toUtc().millisecondsSinceEpoch ?? DateTime.now().toUtc().millisecondsSinceEpoch,
  };

  factory Sources.fromMap(Map<String, dynamic> map) => Sources(
    id: map["id"],
    sourceId: map["source_id"],
    name: map["description"],
    description: map["description"],
    type: typeSample,
    intervalInSeconds: map["interval_in_seconds"],
    realtimeEnabled: map["realtime_enabled"],
    clientEndpoint: map["client_endpoint"],
    clientId: map["client_id"],
    clientSecret: map["client_secret"],
    createdTime: DateTime.fromMillisecondsSinceEpoch(map["created_time"], isUtc: true),
  );

  Sources copy({
  int? id,
  String? sourceId,
  String? name,
  String? description,
  SourceTypes? type,
  int? intervalInSeconds,
  bool? realtimeEnabled,
  String? clientEndpoint,
  String? clientId,
  String? clientSecret,
  DateTime? createdTime,
  }) => Sources(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    name: name ?? this.name,
    description: description ?? this.description,
    type: type ?? this.type,
    intervalInSeconds: intervalInSeconds ?? this.intervalInSeconds,
    realtimeEnabled: realtimeEnabled ?? this.realtimeEnabled,
    clientEndpoint: clientEndpoint ?? this.clientEndpoint,
    clientId: clientId ?? this.clientId,
    clientSecret: clientSecret ?? this.clientSecret,
    createdTime: createdTime ?? this.createdTime,
    );

  @override
  String toString() {
    return 'Sources{source_id: $sourceId, name: $name, type: $type}';
  }
}

Sources s1 = Sources(
      id: 1,
      sourceId: "s_a46058eb9418",
      name: "Văn phòng HN",
      description: "",
      type: typeSample,
      intervalInSeconds: 600,
      realtimeEnabled: false,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));
Sources s2 = Sources(
      id: 2,
      sourceId: "s_84fc085cf219",
      name: "Văn phòng HN",
      description: "",
      type: typeSample,
      intervalInSeconds: 600,
      realtimeEnabled: false,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));
Sources s3 = Sources(
      id: 3,
      sourceId: "s_c4229d8e5f74",
      name: "Văn phòng HN",
      description: "",
      type: typeSample,
      intervalInSeconds: 600,
      realtimeEnabled: false,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));

List<Sources> mySources = [s1, s2,s3];