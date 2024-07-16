import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import './defs.dart' as defs;
import './api.dart' as api;

class ZKClient {
  String ip = "";
  int port = 4370;
  late Socket socket;
  Duration timeout = const Duration(seconds: 0);
  int password = 0;
  var cmdId = 0;
  var lastReplyId = 0;
  var sessionId = 0;
  var payloadData = Uint8List(0);
  var counter = 0;
  int replyId = 65535 - 1;

  bool isConnect = false;
  bool isEnabled = true;
  bool forceUdp = false;
  bool omitPing = false;
  bool verbose = false;
  bool tcp = true;
  int users = 0;
  int fingers = 0;
  int records = 0;
  int dummy = 0;
  int cards = 0;
  int fingersCap = 0;
  int usersCap = 0;
  int recCap = 0;
  int faces = 0;
  int facesCap = 0;
  int fingersAv = 0;
  int usersAv = 0;
  int recAv = 0;
  int nextUid = 1;
  String nextUserId = '1';
  int userPacketSize = 28;
  bool endLiveCapture = false;

  ZKClient(ip, {
    int port = 4370,
    Duration timeout = const Duration(seconds: 60),
    password = 0,
    forceUdp = false,
    omitPing = false,
    verbose = false,
    encoding = 'UTF-8'
  }) {
    this.ip;
    this.port;
    this.timeout;
    sessionId = 0;
    replyId = 65534; // const.USHRT_MAX - 1
    isConnect = false;
    isEnabled = true;
    tcp = !forceUdp;
    users = 0;
    fingers = 0;
    records = 0;
    dummy = 0;
    cards = 0;
    fingersCap = 0;
    usersCap = 0;
    recCap = 0;
    faces = 0;
    facesCap = 0;
    fingersAv = 0;
    usersAv = 0;
    recAv = 0;
    nextUid = 1;
    nextUserId = '1';
    userPacketSize = 28; // default zk6
    endLiveCapture = false;
  }

  Future init() async {
    socket = await Socket.connect(ip, port);
    await Future.delayed(const Duration(seconds: 1), () => {print("ok")});
    print('Connected to: ${socket.remoteAddress.address}:${socket.remotePort}');
    var flag1 = true;
    var flag2 = true;
    socket.listen(
      (data) {
        recvReply(data);

        if (cmdId == defs.DEFS.cmtUnAuth && flag1) {
          print("send auth");
          flag1 = false;
          sendCommand(defs.DEFS.cmdAuth, data:makeCommKey(password, sessionId));
        }

        if (cmdId == defs.DEFS.cmdAckOk && flag2) {
          flag2 = false;
          isConnect = true;
          print("auth ok");
          regEvent(1);
        }

        if (cmdId == 500) {
          handleLogEntry();
        }
      },
      onDone: () {

      },
      onError:(error) {
        print('init Error: $error');
        socket.destroy();
      }
    );
    sendCommand(defs.DEFS.cmdConnect);
  }

  void recvReply(Uint8List replyData) {
    print('------------Received from server------------');
    parseAns(replyData);
  }



  Uint8List makeCommKey(int key, int sessionId, {int ticks = 50}) {
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

  bool testVoice({int index = 0}) {
    sendCommand(defs.DEFS.testVoice, data:packIntAsBytes(index));
    return true;
  }

  void regEvent(int flags) {
    sendCommand(defs.DEFS.cmdRegEvent, data:packIntAsBytes(flags));
  }

  bool parseAns(Uint8List replyData) {
    cmdId = ByteData.sublistView(replyData, 8, 10).getUint16(0, Endian.little);
    sessionId = ByteData.sublistView(replyData, 12, 14).getUint16(0, Endian.little);
    lastReplyId = ByteData.sublistView(replyData, 14, 16).getUint16(0, Endian.little) + 1;
    payloadData = replyData.sublist(16);
    counter += 1;
    print('Command code: $cmdId');
    print('Session Id: $sessionId');
    print('Reply Id: $lastReplyId');
    print('Data: $payloadData');
    print('Counter: $counter');
    return true;
  }

  List<dynamic> parseEventAttlog() {
    String uid = '';
    int verType = -1;

    uid = utf8.decode(payloadData.sublist(0, 9)).replaceAll('\x00', '');
    ByteData byteData = ByteData.sublistView(payloadData);
    verType = byteData.getUint16(24, Endian.little);
    int year = byteData.getUint8(26) + 2000;
    int month = byteData.getUint8(27);
    int day = byteData.getUint8(28);
    int hour = byteData.getUint8(29);
    int minute = byteData.getUint8(30);
    int second = byteData.getUint8(31);
    DateTime dateTime = DateTime(year, month, day, hour, minute, second);

    return [uid, verType, dateTime];
  }

  Future<bool> testPing() async {
    // Ping parameters as function of OS
    String pingStr = Platform.isWindows ? "-n 1" : "-c 1 -W 5";
    List<String> args = ['ping', pingStr, ip];
    bool needSh = !Platform.isWindows;
    print(args[0]); 
    print(args.sublist(1));
    // Ping
    ProcessResult result = await Process.run(args[0], args.sublist(1), runInShell: needSh);
    return result.exitCode == 0;
  }

  Uint8List createPacket(int cmdCode, {Uint8List? data}) {
    var zkPacket = Uint8List.fromList([0x50, 0x50, 0x82, 0x7D]);
    zkPacket = Uint8List.fromList([...zkPacket, ...Uint8List.fromList([0x00, 0x00])]);
    zkPacket = Uint8List.fromList([...zkPacket, ...Uint8List.fromList([0x00, 0x00])]);
    zkPacket = Uint8List.fromList([...zkPacket, ...packUnsignedShort(cmdCode)]);
    zkPacket = Uint8List.fromList([...zkPacket, ...Uint8List.fromList([0x00, 0x00])]);
    zkPacket = Uint8List.fromList([...zkPacket, ...[sessionId % (1<<8), sessionId>>8]]);
    zkPacket = Uint8List.fromList([...zkPacket, ...[lastReplyId % (1<<8), lastReplyId>>8]]);
    if (data != null) {
      zkPacket = Uint8List.fromList([...zkPacket, ...data]);
    }
    var sizeField = ByteData(2)..setUint16(0, zkPacket.length - 8, Endian.little);
    zkPacket.setRange(4, 6, sizeField.buffer.asUint8List());
    var checksum = checksum16(zkPacket.sublist(8));
    zkPacket.setRange(10, 12, packUnsignedShort(checksum));
    return zkPacket;
  }

  Uint8List packUnsignedShort(int value) {
    ByteData byteData = ByteData(2);
    byteData.setUint16(0, value, Endian.little);
    return byteData.buffer.asUint8List();
  }

  Uint8List packIntAsBytes(int index) {
    ByteData byteData = ByteData(4);
    byteData.setUint32(0, index, Endian.little);
    return byteData.buffer.asUint8List();
  }

  Uint8List hexStringToUint8List(String hex) {
    final len = hex.length;
    final Uint8List result = Uint8List(len ~/ 2);
    for (int i = 0; i < len; i += 2) {
      result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return result;
  }

  void sendCommand(int cmd, {Uint8List? data}) {
    sendPacket(createPacket(cmd, data: data));
  }

  void sendPacket(Uint8List zkp) {
    socket.add(zkp);
  }

  int checksum16(List<int> payload) {
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

  // void handleLogEntry() {
  //   List<dynamic> result = parseEventAttlog();
  //   print('UID: ${result[0]}, Verification Type: ${result[1]}, Date: ${result[2]}');
  // }

  Future<void> handleLogEntry() async {
    try {
      final parsedData = parseEventAttlog();
      final userCode = int.parse(parsedData[0]);//.toString();
      print(parsedData[2]);
      final timestamp = dateTimeToTimestamp(parsedData[2]);
      final log = {
        'deviceUserId': parsedData[0],
        'id': '${parsedData[0]}_${timestamp * 1000}',
        'ip': '10.20.1.110',
        'time': timestamp
      };
      final logs = [log];
      final logData = api.makeLog(userCode, logs);


      await api.sendLog('MS0xMzQtYTEwM2I1MjQ1YWIwMjJjMA', '123456', [logData]);
    } catch (e) {
      print('handleLogEntry Error: $e');
    }
  }
}

int dateTimeToTimestamp(DateTime dateTime) {
  return (dateTime.millisecondsSinceEpoch / 1000).round();
}