import 'sources.dart';

class Machines {
  final String id;
  final Sources source;
  final String? brandname;
  final String ipAddress;
  final int tcpPort;
  final bool? realtimeCapturable;
  final String? metadata;

  Machines({
    required this.id,
    required this.source,
    this.brandname, 
    required this.ipAddress, 
    required this.tcpPort, 
    this.realtimeCapturable,
    this.metadata,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "source_id": source.id,
    "ip_address": ipAddress,
    "tcp_port": tcpPort,
    "realtime_capturable": realtimeCapturable,
    "metadata": metadata,
  };

  @override
  String toString() {
    return 'Sources{id: $id, source: $source, endpoint: "$ipAddress:$tcpPort"}';
  }
}

Machines m1 = Machines(id: "1", source: s1, ipAddress: "10.0.1.1", tcpPort: 4370);
Machines m2 = Machines(id: "2", source: s2, ipAddress: "10.0.1.2", tcpPort: 4370);
Machines m3 = Machines(id: "3", source: s3, ipAddress: "10.0.1.3", tcpPort: 4370);

List<Machines> machines = [m1, m2, m3];