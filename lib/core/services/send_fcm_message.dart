import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:healthy_cart_user/utils/app_details.dart';
import 'package:http/http.dart' as http;

Future<void> sendFcmMessage({
  required String token,
  required String body,
  required String title,
  String? datavalue,
}) async {
  ///////////////////--------------->V1
  ///
  final result = await obtainAuthenticatedClient();
  const url =
      'https://fcm.googleapis.com/v1/projects/${AppDetails.projectId}/messages:send';

  // Replace with your notification details
  final notification = <String, dynamic>{
    'title': title,
    'body': body,
    // You can add 'image' here if needed
  };

  // Replace with your custom data
  final data = <String, dynamic>{
    'key': datavalue,
  };

  // Construct the FCM message
  final message = <String, dynamic>{
    'message': {
      'token': token,
      'notification': notification,
      'data': data,
    },
  };

  // Convert the message to JSON
  final jsonMessage = jsonEncode(message);

  // Make the POST request to send the FCM message
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${result.credentials.accessToken.data}',
    },
    body: jsonMessage,
  );

  // Check the response
  if (response.statusCode == 200) {
    //log('FCM message sent successfully (V1)');
  } else {
    //log('Failed to send FCM message. Status code: ${response.statusCode}');
   // log('Response body: ${response.body}');
  }
}

Future<AuthClient> obtainAuthenticatedClient() async {
  final accountCredentials = ServiceAccountCredentials.fromJson({
    "type": "service_account",
    "project_id": "healthycart-4c697",
    "private_key_id": "801c9692fd538975ed676f2bf225a4a960122b97",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDhidjle3NvOiCj\nGiDBEotQETAAcGC9hkTceyCrn5gAIiV9yABJVwu76a1u3NUW5NdZ1ah/EsZEIly+\nROifBSkgZBVV5vOuX6wXW83q+HiiOw6y6w61vZ6Mdwc8BKhQnF4eo3mnp7741GKl\nnZH+TgDdykWJ9CzL4bdK/AQcLoYoizT0Fj5vypDsk96ykgMnzN4mghyvu4npMdO9\narHQ+5Fh2bQuV9uLe4+ntp7YsPteb8eWR9Gq7dLsJ3c6IyzPa6nFSyTpU8eVye1h\nGa2EZjnvGOuWcYnDOXYZLhfOvknUhze9c1z2NPg8i92RCD8cLOlWgrxUjDrGYT50\n/8nIh+/HAgMBAAECggEAJvHLGqEtBx1F6nQGCOC/XpWBMOo2wjMvq9S1CP2XXRqI\nV8ZTylY2B/4rPPPz9a6RQwliPYML6lL2qcIzWtYkyluN1ZX6KPeLO0NWdMbv6a+B\n88Ij+ZzjBkU9Yg850yWVGPxIcvtDvirKV+e0AHIOsz2MsWwQ2inBITkQKp+b+d7w\ny1cY+ziLXngdepQxN55DxIQ1ae16uVDrNOh9f1w3IXKm1N6Nq48SX+/OydmIiouK\nOdl1uFnqNw1SGQa6S5FbGI23JLwSE2YpozphczXxtbhII7dPetP+4kI2XnU244lH\nTFXIm/r1rcwyVJ1GQanG3t5FHkQ7USgmarkUIbhLZQKBgQDxYXsC59u2ewbE+W+K\nEEmZdiY8LBKQ59VyXRoSZXJBn4qOWb98woJFD40ufBhvSMhsHEYbm/972Rgbu/iZ\nuStSLj4lohUl07UTyW/vXOhvXd9c1lj6exnZB7GBG5Jt1hch0kinr9GLexrKr3GV\nd4sEZTuVxNekUo5nLxWBxSIHywKBgQDvMrzLy2btjwcczoIoHCaRDcmg4EDucg9D\nFASx1m5YtqzXUiYj8XBUOEOHMePQAT879J/HmDJ/i7CrmafhhX2kxDgzT0VDrLLL\nd7Kvidp/UscGxUQi3/BuUIUunOu9wQ+eWSzKYu+BxtzI47OH8wQskj2MR5Q/dnLP\nPscv0uMgdQKBgQCKzGgEurhvjPzOhTQrKsR3lyXTUfB3HKhzM7ALRgRWUdxFkLv4\njIyGE7Q2N6uBSlPdPsDdnW1ilOo1AHiqRHzxq5+W2kXY04z7TMit1jnd2BfZdXQC\nzIiHcNIUEHu55vK0Qwv+SK5wyyATzqC8ttncdC24KFFrrwEtujhev7Ga0wKBgQDh\nAfhpOKhVFbNaHMSBGKIK105xICLUasUCk4UrCQx6NTT3w9YO/6JsBxU2yu6DD3k9\nXAslhX0TUANcGMm8socThGVdltcQJxd1oN6ck+/Oz75bFxvWNpQEIYh25bQ4prCb\ng0VICLNGgBvWeaO7YhXuG478M6U34aN0Ypia2yU+tQKBgEVJ8YSUbb3VUpWwvWJO\nbEzaVvyjj1LORkEMwsglhhsaOPfc70uZNebC/1uuzldOXwiHFP1xyy2uko+VmSVE\nVRCrdhpv9IStwxj24OO1UyM2dSljWAr9dgC/BA4NZb4BkNvtsikNY8MDoS2JCeMY\n4bBMFCY/qculeN6XTgijdTgE\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-sg2xe@healthycart-4c697.iam.gserviceaccount.com",
    "client_id": "100294573833443771767",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-sg2xe%40healthycart-4c697.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  });

  const messagingScope = 'https://www.googleapis.com/auth/firebase.messaging';
  final scopes = [messagingScope];

  final AuthClient client =
      await clientViaServiceAccount(accountCredentials, scopes);

  return client;
}
