import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlService {
  Future<void> redirectToWhatsapp({ required String whatsAppLink,VoidCallback? onFailure}) async {
    String encodedUrl = Uri.encodeFull(whatsAppLink);
 try {
    if (await launchUrlString(encodedUrl)) {
      await launchUrl(Uri.parse(encodedUrl));
    } else {
       onFailure!();
      throw 'Could not launch $encodedUrl';
    }
     } on Exception catch (e) {
      print(e.toString());
      onFailure!();
    }
  }

  Future<void> redirectToLink(
      {required String link, VoidCallback? onFailure}) async {
    String encodedUrl = Uri.encodeFull(link);

    try {
      if (await launchUrlString(encodedUrl)) {
        await launchUrl(Uri.parse(encodedUrl));
        LaunchMode.externalApplication;
      } else {
        onFailure!();
      }
    } on Exception catch (e) {
      print(e.toString());
      onFailure!();
    }
  }
}
