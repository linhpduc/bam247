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

MachineModel m1 = MachineModel(id: 1, sourceId: s1.sourceId, ipAddress: "10.0.1.1", tcpPort: 4370);
MachineModel m2 = MachineModel(id: 2, sourceId: s2.sourceId, ipAddress: "10.0.1.2", tcpPort: 4370);
MachineModel m3 = MachineModel(id: 3, sourceId: s3.sourceId, ipAddress: "10.0.1.3", tcpPort: 4370);

List<MachineModel> machinesSample = [m1, m2, m3];