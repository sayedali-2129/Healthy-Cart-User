import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlService {
  Future<bool> redirectToWhatsapp(String whatsAppLink) async {
    String encodedUrl = Uri.encodeFull(whatsAppLink);

    if (await launchUrlString(encodedUrl)) {
      await launchUrl(Uri.parse(encodedUrl));
      return true;
    } else {
      throw 'Could not launch $encodedUrl';
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
