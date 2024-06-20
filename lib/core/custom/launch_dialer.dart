import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchDialer {
  static Future<void> lauchDialer({required String phoneNumber}) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      CustomToast.errorToast(text: 'Could not launch the dialer');
    }
  }
}
