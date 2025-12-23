import 'package:url_launcher/url_launcher.dart';

import '../core/platform/chat_launcher.dart';

class UrlLauncherChatLauncher implements ChatLauncher {
  @override
  Future<bool> openWhatsApp({
    required String phone,
    required String message,
  }) async {
    final msg = Uri.encodeComponent(message);
    final url = Uri.parse('https://wa.me/$phone?text=$msg');
    return launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
