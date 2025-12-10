
import 'package:url_launcher/url_launcher.dart';

class WhatsAppService {
  static Future<bool> openChat({required String phone, required String message}) async {
    final msg = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/$phone?text=$msg');
    return launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
