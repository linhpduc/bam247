import 'dart:typed_data';

class Helper {
  static Uint8List packUShort(int value) {
    ByteData byteData = ByteData(2);
    byteData.setUint16(0, value, Endian.little);
    return byteData.buffer.asUint8List();
  }

  static Uint8List packInt(int value) {
    ByteData byteData = ByteData(4);
    byteData.setUint32(0, value, Endian.little);
    return byteData.buffer.asUint8List();
  }

  static Uint8List hexStringToUint8List(String hex) {
    final len = hex.length;
    final Uint8List result = Uint8List(len ~/ 2);
    for (int i = 0; i < len; i += 2) {
      result[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }
    return result;
  }
}