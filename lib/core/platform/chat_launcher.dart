/// Platform boundary for launching external chat apps (e.g., WhatsApp).
/// Keep UI + domain independent from url_launcher or other plugins.
abstract class ChatLauncher {
  Future<bool> openWhatsApp({
    required String phone,
    required String message,
  });
}
