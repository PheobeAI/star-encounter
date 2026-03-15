import 'package:flutter/material.dart';
import 'models/character.dart';
import 'models/conversation.dart';
import 'models/story.dart';
import 'services/database_service.dart';
import 'services/ai_service.dart';
import 'services/character_service.dart';
import 'services/story_service.dart';
import 'dialogue_screen.dart';

class CharacterDetailScreen extends StatefulWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  final DatabaseService _dbService = DatabaseService();
  final AIService _aiService = AIService();
  final CharacterService _characterService = CharacterService(
    databaseService: DatabaseService(),
    aiService: AIService(),
  );
  final StoryService _storyService = StoryService(
    databaseService: DatabaseService(),
  );

  late ConversationContext _context;
  DialogueMessage? _reply;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _context = ConversationContext(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      characterId: widget.character.id,
      messages: [],
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _reply = null;
    });

    // 添加用户消息
    _context = _context.addMessage(
      DialogueMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.user,
        text: text,
      ),
    );

    // 保存对话
    await _dbService.saveConversation(_context);

    // 生成回复
    _reply = _aiService.generateReply(
      character: widget.character,
      userMessage: text,
      context: _context,
    );

    // 保存回复
    _context = _context.addMessage(_reply!);
    await _dbService.saveConversation(_context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.character.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // 角色信息卡片
          _buildCharacterInfo(),
          // 对话区域
          Expanded(
            child: _buildDialogueArea(),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/${widget.character.id}.png'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.character.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPersonalityText(widget.character.personality),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatRow('等级', '${widget.character.stats.level}'),
          _buildStatRow('经验值', '${widget.character.stats.exp}/${widget.character.stats.requiredExp}'),
          _buildStatRow('好感度', '${widget.character.stats.affection}/100'),
          _buildStatRow('羁绊点数', '${widget.character.stats.affinity}'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildDialogueArea() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 对话记录
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _context.messages.length,
              itemBuilder: (context, index) {
                final message = _context.messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          // 输入框
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(DialogueMessage message) {
    final isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isUser
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
            if (message.affectionChange != 0) ...[
              const SizedBox(height: 4),
              Text(
                message.affectionChange > 0 ? '好感度 +${message.affectionChange}' : '好感度 ${message.affectionChange}',
                style: TextStyle(
                  fontSize: 12,
                  color: message.affectionChange > 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    final controller = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: '输入消息...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (text) {
                _sendMessage(text);
                controller.clear();
              },
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _sendMessage(controller.text);
                controller.clear();
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  String _getPersonalityText(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.lively:
        return '活泼';
      case PersonalityType.gentle:
        return '温柔';
      case PersonalityType.cool:
        return '高冷';
      case PersonalityType.tsundere:
        return '傲娇';
      case PersonalityType.shy:
        return '害羞';
      case PersonalityType.efficient:
        return '精力充沛';
      case PersonalityType.mysterious:
        return '神秘';
      case PersonalityType.cheerful:
        return '开朗';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
