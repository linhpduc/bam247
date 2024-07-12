import 'source_types.dart';

class Sources {
  final String id;
  final String name;
  final String? description;
  final SourceTypes type;
  final int? intervalInSeconds;
  final bool? realtimeEnabled;
  final String clientEndpoint;
  final String clientId;
  final String clientSecret;
  final DateTime? createdTime;

  Sources({
    required this.id, 
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
    "name": name,
    "type": type.name,
  };

  @override
  String toString() {
    return 'Sources{id: $id, name: $name, type: $type}';
  }
}

Sources s1 = Sources(
      id: "a46058eb9418",
      name: "Văn phòng HN",
      description: "",
      type: machine,
      intervalInSeconds: 600,
      realtimeEnabled: false,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));
Sources s2 = Sources(
      id: "84fc085cf219",
      name: "Văn phòng HN",
      description: "",
      type: machine,
      intervalInSeconds: 600,
      realtimeEnabled: false,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));
Sources s3 = Sources(
      id: "c4229d8e5f74",
      name: "Văn phòng HN",
      description: "",
      type: machine,
      intervalInSeconds: 600,
      realtimeEnabled: false,
      clientEndpoint: "https://checkin.base.vn",
      clientId: "45234",
      clientSecret: "0",
      createdTime: DateTime(2017, 9, 7, 17, 30));

List<Sources> mySources = [s1, s2,s3];