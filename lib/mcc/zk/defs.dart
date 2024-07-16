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
  static const cmtUnAuth = 2005;
  static const repNotAuth = 0x07d5;
  static const repSuccess = 0x07d0;
  static const cmdReadConfig = 0x000b;

  static const testVoice = 1017;

  static const efAlarm = (1<<9);
}