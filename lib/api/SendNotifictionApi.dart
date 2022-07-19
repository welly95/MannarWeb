import 'dart:convert';

import 'package:dio/dio.dart';

Future<bool> callOnFcmApiSendPushNotifications(String token, String title, String message) async {
  final postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "notification": {"body": "$message", "title": "$title"},
    "priority": "high",
    "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "id": "1", "status": "done"},
    "to": "$token"
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization':
        "key=AAAAbEAO6S0:APA91bHFnec6QV_zxUQebHSfgAXEtigRLbiRf0XJIbjhxKuB0hosclw-xghggixWt-tLD0V_u4uW698VmK6sYkd5rHsWQW7KpbtaWn3BTps7D29L2Z1q4EEFePtNlIwIPj3wPMVnzumG" // 'key=YOUR_SERVER_KEY'
  };
  Dio dio = Dio();
  final response = await dio.post(postUrl,
      data: json.encode(data),
      options: Options(
//          encoding: Encoding.getByName('utf-8'),
          headers: headers));

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    return true;
  } else {
    print(' CFM error');
    // on failure do sth
    return false;
  }
}
