import 'package:batt247/repositories/zkteco.dart';

void main() {
  // String n = '~DeviceName';
  // print(n.runes);
  ZK clt = ZK(ip: "10.20.1.217", port: 4370);
  clt.getDeviceInfo();
}