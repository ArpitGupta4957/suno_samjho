import 'package:flutter/material.dart';
import 'package:suno_samjho/services/tts_service.dart';
import 'package:uuid/uuid.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  bool _isDark = false;
  late TtsService _ttsService;
  
  final List<Map<String, dynamic>> _messages = [
    {
      'id': const Uuid().v4(),
      'who': 'bot',
      'text': 'Hello! I am Samjho — how can I help you today?',
      'time': '09:00',
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ttsService = TtsService();
    _ttsService.init();
  }

  @override
  void dispose() {
    _ttsService.stop();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF1E88E5),
    scaffoldBackgroundColor: const Color(0xFFF7FAFF),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: const Color(0xFF1E88E5),
    ),
    inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
  );

  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF4A90E2),
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: const Color(0xFF4A90E2)),
    inputDecorationTheme: const InputDecorationTheme(border: InputBorder.none),
  );

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'id': const Uuid().v4(),
        'who': 'me',
        'text': text,
        'time': _timeNow(),
      });
      _controller.clear();
    });
    // simple simulated bot reply
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _messages.add({
          'id': const Uuid().v4(),
          'who': 'bot',
          'text': 'Got it — I will help with that.',
          'time': _timeNow(),
        });
      });
      _scrollToBottom();
    });
    _scrollToBottom();
  }

  String _timeNow() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDark ? _darkTheme : _lightTheme;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          centerTitle: false,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.chat, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Samjho',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      color: theme.textTheme.bodySmall?.color,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: _isDark ? 'Switch to light' : 'Switch to dark',
              icon: Icon(
                _isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round,
              ),
              onPressed: () => setState(() => _isDark = !_isDark),
              color: theme.primaryColor,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, i) {
                    final msg = _messages[i];
                    final isMe = msg['who'] == 'me';
                    return Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : 8, bottom: 4),
                      child: Row(
                        mainAxisAlignment: isMe
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          if (!isMe) _avatarSmall(theme),
                          Flexible(
                            child: _bubble(
                              msg['text'] ?? '',
                              msg['time'] ?? '',
                              msg['id'] ?? '',
                              isMe,
                              theme,
                            ),
                          ),
                          if (isMe) const SizedBox(width: 6),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _buildInputBar(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarSmall(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: CircleAvatar(
        radius: 16,
        backgroundColor: theme.primaryColor.withOpacity(0.15),
        child: Icon(Icons.smart_toy, color: theme.primaryColor, size: 18),
      ),
    );
  }

  Widget _bubble(String text, String time, String messageId, bool isMe, ThemeData theme) {
    final bg = isMe
        ? theme.colorScheme.secondary
        : (theme.brightness == Brightness.dark
              ? Colors.grey[800]
              : Colors.white);
    final color = isMe
        ? Colors.white
        : (theme.brightness == Brightness.dark
              ? Colors.white70
              : Colors.black87);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 16),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(color: color, fontSize: 15, height: 1.35),
              ),
              if (!isMe) ...[
                const SizedBox(height: 8),
                _buildTtsControls(messageId, theme, color),
              ],
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 11,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTtsControls(String messageId, ThemeData theme, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (_ttsService.isPlaying(messageId)) {
              await _ttsService.pause();
              setState(() {});
            } else if (_ttsService.isPaused(messageId)) {
              await _ttsService.resume();
              setState(() {});
            } else {
              final msgIndex = _messages.indexWhere((m) => m['id'] == messageId);
              if (msgIndex != -1) {
                await _ttsService.speak(_messages[msgIndex]['text'], messageId);
                setState(() {});
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Icon(
              _ttsService.isPlaying(messageId)
                  ? Icons.pause
                  : Icons.play_arrow,
              size: 18,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () async {
            if (_ttsService.getCurrentlyPlayingId() == messageId) {
              await _ttsService.stop();
              setState(() {});
            }
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
            ),
            child: Icon(
              Icons.stop,
              size: 18,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add, color: theme.primaryColor),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.grey[900]
                    : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type a message...',
                      ),
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 15,
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: theme.primaryColor,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _toggleListening,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isListening
                    ? Colors.red.withOpacity(0.15)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.red : theme.primaryColor,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// chatbot_page.dart
// TODO: Implement ChatbotPage widget
