import '../core/platform/chat_launcher.dart';
import 'url_launcher_chat_launcher.dart';

@Deprecated('Use ChatLauncher via dependency injection (UrlLauncherChatLauncher).')
class WhatsAppService {
  static Future<bool> openChat({
    required String phone,
    required String message,
  }) async {
    final launcher = UrlLauncherChatLauncher();
    return launcher.openWhatsApp(phone: phone, message: message);
  }
}
