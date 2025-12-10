
import 'package:flutter/material.dart';
import '../../../core/design_system/tokens.dart';

class ChatPage extends StatefulWidget {
  final String name;
  final bool isOnline;
  final String? avatarUrl;

  const ChatPage({super.key, required this.name, required this.isOnline, this.avatarUrl});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final messages = <_Msg>[
    _Msg(text: 'Hey! Just confirming our ride for tomorrow at 9 AM.', fromMe: false, time: '10:42 AM'),
    _Msg(text: "Yep, that's correct. I'll be there.\nWhere should I pick you up?", fromMe: true, time: '10:43 AM'),
    _Msg(text: 'The corner of Maple & 5th St, right by the coffee shop.', fromMe: false, time: '10:44 AM'),
    _Msg(text: 'Got it.', fromMe: true, time: '10:44 AM'),
    _Msg(text: 'Perfect, see you then!', fromMe: false, time: '10:45 AM'),
  ];

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(widget.name, style: Theme.of(context).textTheme.titleLarge),
            Text(widget.isOnline ? 'Online' : 'Offline', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.7))),
          ],
        ),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTokens.space3),
              itemCount: messages.length,
              itemBuilder: (_, i) => _Bubble(msg: messages[i]),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppTokens.space3),
              child: Row(children: [
                Expanded(child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'Type your message...'),
                )),
                const SizedBox(width: AppTokens.space3),
                FloatingActionButton.small(onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  setState(() {
                    messages.add(_Msg(text: controller.text.trim(), fromMe: true, time: 'Now'));
                    controller.clear();
                  });
                }, child: const Icon(Icons.send)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Msg {
  final String text;
  final bool fromMe;
  final String time;
  _Msg({required this.text, required this.fromMe, required this.time});
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  const _Bubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final alignment = msg.fromMe ? Alignment.centerRight : Alignment.centerLeft;
    final bg = msg.fromMe ? cs.primary : Colors.white;
    final fg = msg.fromMe ? Colors.white : cs.onSurface;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(24),
      topRight: const Radius.circular(24),
      bottomLeft: Radius.circular(msg.fromMe ? 24 : 8),
      bottomRight: Radius.circular(msg.fromMe ? 8 : 24),
    );
    return Align(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: msg.fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: const BoxConstraints(maxWidth: 320),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: bg, borderRadius: radius, boxShadow: AppTokens.cardShadow),
            child: Text(msg.text, style: TextStyle(color: fg)),
          ),
          const SizedBox(height: 6),
          Text(msg.time, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6))),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
