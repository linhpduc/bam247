import 'package:batt247/repositories/zkteco.dart';

void main() async {
  ZK clt = ZK(ip: "10.20.1.217", port: 4370);
  await clt.connect();
  print("Connected: ${clt.isConnected()}");
  clt.testVoice();
}