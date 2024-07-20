import 'dart:io';
import 'dart:typed_data';

import '../utils/helper.dart';

class ZK {
  static const int uShrtMAX = 65535;

  String ip;
  int port;
  int password;
  late int _counter;

  ZK({required this.ip, this.port = 4370, this.password = 0}) {
    _counter = 0;
  }

  void __sendCommand(Socket socket, int command, int sessionID, int replyID, {Uint8List? data}) {
    ZKPacket pkt = ZKPacket(
      cmdCode: command, 
      sessionID: sessionID, 
      replyID: replyID, 
      data: data,
    );
    print(pkt);
    _counter++;
    socket.add(pkt.toBytes());
  }

  void connect(socket) {
    __sendCommand(socket, ZKCMD.connect, 0, 0);
  }

  void disconnect(socket, int sessionID, int replyID) {
    replyID++;
    __sendCommand(socket, ZKCMD.disconnect, sessionID, replyID);
  }

  void auth(Socket socket, int sessionID, int replyID) {
    replyID++;
    __sendCommand(socket, ZKCMD.auth, sessionID, replyID, data: _makeCmdKey(password, sessionID));
  }

  void readInfo(Socket socket, int sessionID, int replyID, String confName) {
    replyID++;
    Uint8List data = Uint8List.fromList([...confName.runes, 0x00]);
    __sendCommand(socket, ZKCMD.readConfig, sessionID, replyID, data: data);
  }

  Uint8List _makeCmdKey(int key, int sessionId, {int ticks = 50}) {
    int k = 0;
    for (int i = 0; i < 32; i++) {
      if ((key & (1 << i)) != 0) {
        k = (k << 1) | 1;
      } else {
        k = k << 1;
      }
    }
    k += sessionId;

    ByteData kData = ByteData(4);
    kData.setUint32(0, k, Endian.little);

    Uint8List kBytes = kData.buffer.asUint8List();
    kBytes[0] ^= 'Z'.codeUnitAt(0);
    kBytes[1] ^= 'K'.codeUnitAt(0);
    kBytes[2] ^= 'S'.codeUnitAt(0);
    kBytes[3] ^= 'O'.codeUnitAt(0);

    var temp = kBytes.buffer.asByteData().getUint16(0, Endian.little);
    kData.setUint16(0, kBytes.buffer.asByteData().getUint16(2, Endian.little), Endian.little);
    kData.setUint16(2, temp, Endian.little);

    int B = 0xff & ticks;
    kBytes = kData.buffer.asUint8List();
    kBytes[0] ^= B;
    kBytes[1] ^= B;
    kBytes[2] = B;
    kBytes[3] ^= B;

    return kBytes;
  }

  Future<void> getDeviceInfo() async {
    Socket socket = await Socket.connect(ip, port, timeout: const Duration(seconds: 1)); print("address: $ip:$port");
    await Future.delayed(const Duration(seconds: 1), () => {print("ok")});
    List<String> infos = <String>['~SerialNumber', '~Platform', '~MAC', '~ZKFaceVersion', '~ZKFPVersion', '~DeviceName'];
    try {
      connect(socket);
      socket.listen(
        (data) {
          ZKPacket respkt = ZKPacket.fromBytes(data); print("Receive: $respkt");
          switch (respkt.cmdCode) {
            case ZKCMD.repNotAuth:
              auth(socket, respkt.sessionID, respkt.replyID);
              break;
            case ZKCMD.repSuccess:
              if (infos.isNotEmpty) {
                String confName = infos.removeLast();
                readInfo(socket, respkt.sessionID, respkt.replyID, confName);
              } else {
                disconnect(socket, respkt.sessionID, respkt.replyID);
              }
              break;
            default:
          }
        },
        onDone: () {
          print('Done.');
          socket.destroy();
        },
        onError: (error) {
          print('Error: $error');
          socket.destroy();
        }
      );
    } catch (e) {
      print("Error: $e");
      socket.close();
    }
  }

}

class ZKPacket {
  final int headIndicator;
  late int payloadSz;
  int cmdCode;
  late int checksum;
  int sessionID;
  int replyID;
  Uint8List? data;

  ZKPacket({
    this.headIndicator = 0x7d825050,
    required this.cmdCode,
    required this.sessionID,
    required this.replyID,
    required this.data,
  }) {
    payloadSz = 0x08 + (data ?? Uint8List(0)).length;
    checksum = _calcCheckSum16([cmdCode, 0, sessionID, replyID, ...(data ?? Uint8List(0))]);
  }

  factory ZKPacket.fromBytes(Uint8List packet) => ZKPacket(
    cmdCode: ByteData.sublistView(packet, 8, 10).getUint16(0, Endian.little),
    sessionID: ByteData.sublistView(packet, 12, 14).getUint16(0, Endian.little),
    replyID: ByteData.sublistView(packet, 14, 16).getUint16(0, Endian.little),
    data: packet.sublist(16),
  );

  Uint8List toBytes() {
    int checksum = _calcCheckSum16([cmdCode, 0, sessionID, replyID, ...data ?? []]);
    Uint8List packet = Uint8List.fromList([
      ...Helper.packInt(headIndicator), 
      ...Helper.packInt(payloadSz), 
      ...Helper.packUShort(cmdCode), 
      ...Helper.packUShort(checksum), 
      ...[sessionID % (1<<8), sessionID>>8], 
      ...[replyID % (1<<8), replyID>>8],
    ]);
    if (data != null) {
      packet = Uint8List.fromList([...packet, ...(data ?? Uint8List(0))]);
    }
    return packet;
  }

  @override
  String toString() {
    return 'ZKPacket{cmdCode: $cmdCode, sessionID: $sessionID, replyIDNumber: $replyID, data: $data}';
  }

  int _calcCheckSum16(List<int> payload) {
    int chk32b = 0;
    int j = 1;

    if (payload.length % 2 == 1) {
      Uint8List.fromList([...payload, ...Uint8List.fromList([0x00])]);
    }

    while (j < payload.length) {
      int num16b = payload[j - 1] + (payload[j] << 8);
      chk32b += num16b;
      j += 2;
    }

    chk32b = (chk32b & 0xFFFF) + ((chk32b & 0xFFFF0000) >> 16);
    int chk16b = chk32b ^ 0xFFFF;

    return chk16b;
  }
  
}

class ZKCMD {
  static const startTag = [0x50, 0x50, 0x82, 0x7D];

  static const connect = 0x03e8;          // 1000
  static const disconnect = 0x03e9;       // 1101
  static const auth = 0x044e;             // 1102
  static const readConfig = 0x000b;       // 11
  
  static const cmdData = 0x05dd;          // 1501
  static const cmdPrepareData = 0x05dc;
  static const cmdDataRdy = 0x05e0;
  static const cmdFreeData = 0x05de;
  static const cmdReq2SendCmdKey = 0x044e;
  static const cmdRegEvent = 0x01f4;

  static const repNotAuth = 0x07d5;       // 2005
  static const repSuccess = 0x07d0;       // 2000

  static const testVoice = 1017;
  static const efAlarm = (1<<9);
}
