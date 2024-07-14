import 'sources.dart';

class MachineModel {
  final int id;
  final SourceModel source;
  final String? brandname;
  final String ipAddress;
  final int tcpPort;
  final bool? realtimeCapturable;
  final String? metadata;
  static String tableName = 'machines';

  MachineModel({
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
    "source_id": source.sourceId,
    "brandname": brandname ?? "",
    "ip_address": ipAddress,
    "tcp_port": tcpPort,
    "realtime_capturable": realtimeCapturable ?? 0,
    "metadata": metadata ?? "",
  };

  @override
  String toString() {
    return 'MachineModel{machine_id: $id, source_name: ${source.name}, endpoint: "$ipAddress:$tcpPort"}';
  }
}

MachineModel m1 = MachineModel(id: 1, source: s1, ipAddress: "10.0.1.1", tcpPort: 4370);
MachineModel m2 = MachineModel(id: 2, source: s2, ipAddress: "10.0.1.2", tcpPort: 4370);
MachineModel m3 = MachineModel(id: 3, source: s3, ipAddress: "10.0.1.3", tcpPort: 4370);

List<MachineModel> machinesSample = [m1, m2, m3];