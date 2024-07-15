import 'sources.dart';

class MachineModel {
  final int? id;
  final String sourceId;
  String? brandname;
  String ipAddress;
  int tcpPort;
  bool? realtimeCapturable;
  String? metadata;
  
  static String tableName = 'machines';

  MachineModel({
    this.id,
    required this.sourceId,
    this.brandname, 
    required this.ipAddress, 
    required this.tcpPort, 
    this.realtimeCapturable,
    this.metadata,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "source_id": sourceId,
    "brandname": brandname ?? "",
    "ip_address": ipAddress,
    "tcp_port": tcpPort,
    "realtime_capturable": realtimeCapturable ?? 0,
    "metadata": metadata ?? "",
  };

  @override
  String toString() {
    return 'MachineModel{machine_id: $id, source_id: $sourceId, endpoint: "$ipAddress:$tcpPort"}';
  }
}
