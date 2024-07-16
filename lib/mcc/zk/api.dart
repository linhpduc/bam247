import 'package:http/http.dart' as http;
import 'dart:convert';

Map<String, dynamic> makeLog(int userCode, List<Map<String, dynamic>> logs) {
  Map<String, dynamic> dateLogs = {};

  for (var log in logs) {
    int dateTimestamp = log['time'];
    String dateString = dateTimestamp.toString();

    if (!dateLogs.containsKey(dateString)) {
      dateLogs[dateString] = {
        'date': dateTimestamp,
        'logs': []
      };
    }

    dateLogs[dateString]['logs'].add({
      'deviceUserId': log['deviceUserId'],
      'id': log['id'],
      'ip': log['ip'],
      'time': dateTimestamp
    });
  }

  return {
    'user_code': userCode,
    'dates': dateLogs
  };
}

Future<void> sendLog(String cltToken, String cltPass, List<Map<String, dynamic>> logs) async {
  final url = Uri.parse('https://checkin.basesystem.dev/v1/client/mass_sync'); // Replace with your actual endpoint
  final headers = {
    'authority': 'checkin.base.vn',
    'access-control-allow-origin': '*',
    'accept': 'application/json, text/plain, */*',
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) base-checkin-station-desktop-full-ip/3.2.5 Chrome/87.0.4280.141 Electron/11.5.0 Safari/537.36',
    'content-type': 'application/x-www-form-urlencoded',
    'sec-fetch-site': 'cross-site',
    'sec-fetch-mode': 'cors',
    'sec-fetch-dest': 'empty',
    'accept-language': 'en-US',
    'cookie': 'basessid=6f61f59h9aqqf4rtula4ri2bkjujdgheg7g9haact5n2al22h6khsk6qm34nopsa8laa0v3ntm5lvkep8g5tn10bl5c02m76qhh5e2s1c4locctdf353vsgt3ttjdf2b',
    'Accept-Encoding': 'gzip',
  };

  final body = {
    'client_token': cltToken,
    'client_password': cltPass,
    'logs': jsonEncode(logs)
  };



  final encodedBody = body.entries.map((entry) {
    return '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value.toString())}';
  }).join('&');

  final response = await http.post(
    url,
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    print('Request was successful: ${response.body}');
  } else {
    print('Request failed with status: ${response.statusCode}, ${response.body}');
  }
}