import '../constants.dart';

class MachineModel {
  final int? id;
  final String sourceId;
  MachineBrandname? brandname;
  String ipAddress;
  int tcpPort;
  int? realtimeCapturable;
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
    "brandname": brandname?.value,
    "ip_address": ipAddress,
    "tcp_port": tcpPort,
    "realtime_capturable": realtimeCapturable ?? 0,
    "metadata": metadata ?? "",
  };

  factory MachineModel.fromMap(Map<String, dynamic> map) => MachineModel(
    id: map["id"],
    sourceId: map["source_id"],
    brandname: MachineBrandname.values.byName(map["brandname"]),
    ipAddress: map["ip_address"],
    tcpPort: map["tcp_port"],
    realtimeCapturable: map["realtime_capturable"],
    metadata: map["metadata"],
  );

  @override
  String toString() {
    return 'MachineModel{machine_id: $id, brandname: ${brandname?.value}, source_id: $sourceId, endpoint: "$ipAddress:$tcpPort"}';
  }
}
