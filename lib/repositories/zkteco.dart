import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../utils/helper.dart';

class ZK {
  static const int uShrtMAX = 65535;

  final String ip = "";
  final int port = 4370;
  final int password = 0;

  Socket? _socket;
  int _cmdID = 0;
  int _sessionID = 0;
  int _lastReplyID = 0;
  bool _isConnect = false;

  ZK({required ip, required int port, password = 0}) {
    this.ip;
    this.port;
  }

  Uint8List _createPacket(int cmdCode, {Uint8List? data}) {
    _lastReplyID++;
    var zkPacket = Uint8List.fromList([0x50, 0x50, 0x82, 0x7D]);
    zkPacket = Uint8List.fromList([...zkPacket, ...Uint8List.fromList([0x00, 0x00])]);
    zkPacket = Uint8List.fromList([...zkPacket, ...Uint8List.fromList([0x00, 0x00])]);
    zkPacket = Uint8List.fromList([...zkPacket, ...Helper.packUShort(cmdCode)]);
    zkPacket = Uint8List.fromList([...zkPacket, ...Uint8List.fromList([0x00, 0x00])]);
    zkPacket = Uint8List.fromList([...zkPacket, ...[_sessionID % (1<<8), _sessionID>>8]]);
    zkPacket = Uint8List.fromList([...zkPacket, ...[_lastReplyID % (1<<8), _lastReplyID>>8]]);
    if (data != null) {
      zkPacket = Uint8List.fromList([...zkPacket, ...data]);
    }
    var sizeField = ByteData(2)..setUint16(0, zkPacket.length - 8, Endian.little);
    zkPacket.setRange(4, 6, sizeField.buffer.asUint8List());
    var checksum = _checksum16(zkPacket.sublist(8));
    zkPacket.setRange(10, 12, Helper.packUShort(checksum));
    return zkPacket;
  }

  void _sendPacket(Uint8List packet) {
    _socket?.add(packet);
  }

  void _sendCmd(int cmd, {Uint8List? data}) {
    _sendPacket(_createPacket(cmd, data: data));
  }

  bool _parseAns(Uint8List replyData) {
    _cmdID = ByteData.sublistView(replyData, 8, 10).getUint16(0, Endian.little);
    _sessionID = ByteData.sublistView(replyData, 12, 14).getUint16(0, Endian.little);
    _lastReplyID = ByteData.sublistView(replyData, 14, 16).getUint16(0, Endian.little);
    // payloadData = replyData.sublist(16);
    return true;
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

  int _checksum16(List<int> payload) {
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

  Future<void> connect() async {
    try {
      _socket = await Socket.connect("10.20.1.217", 4370, timeout: const Duration(seconds: 1));
      print("address: $ip:$port");

      _sendCmd(DEFS.cmdConnect);

      _socket?.listen(
        (data) {
          _parseAns(data);
          if (_cmdID == DEFS.repNotAuth) {
            _sendCmd(DEFS.cmdAuth, data: _makeCmdKey(password, _sessionID));
          } else if (_cmdID == DEFS.cmdAckOk) {
            _isConnect = true;
          }
        },
        onDone: () {
          _socket?.destroy();
        },
        onError: (error) {
          print('Error: $error');
          _socket?.destroy();
        }
      );
    } catch (e) {
      print("Error: $e");
      _socket?.close();
    }
  }

  void testVoice({int index = 0}) {
    _sendCmd(DEFS.testVoice, data: Helper.packInt(index));
  }

  bool isConnected () => _isConnect;
}

class DEFS {
  static const startTag = [0x50, 0x50, 0x82, 0x7D];

  static const cmdConnect = 0x03e8;
  static const cmdEnableDevice = 0x03ea;
  static const cmdData = 0x05dd;
  static const cmdPrepareData = 0x05dc;
  static const cmdAckOk = 0x07d0;
  static const cmdDataRdy = 0x05e0;
  static const cmdFreeData = 0x05de;
  static const cmdReq2SendCmdKey = 0x044e;
  static const cmdGetDeviceName = 0x000b;
  static const cmdRegEvent = 0x01f4;
  static const cmdDisconnect = 0x03e9;
  static const cmdAuth = 0x044e;
  static const cmdReadConfig = 0x000b;

  static const repNotAuth = 0x07d5;
  static const repSuccess = 0x07d0;

  static const testVoice = 1017;
  static const efAlarm = (1<<9);
}
