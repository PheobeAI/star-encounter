import 'package:flutter/material.dart';
import 'models/character.dart';
import 'models/conversation.dart';

// 简单的内存存储
class SimpleStorage {
  static final List<Character> _characters = [];
  static final Map<String, ConversationContext> _conversations = {};

  static List<Character> getCharacters() => List.from(_characters);
  static Character? getCharacter(String id) {
    try {
      return _characters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  static Future<void> addCharacter(Character character) async {
    _characters.add(character);
  }

  static ConversationContext? getConversation(String id) => _conversations[id];

  static Future<void> saveConversation(ConversationContext context) async {
    _conversations[context.id] = context;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化默认角色
  _initDefaultCharacters();

  runApp(const StarEncounterApp());
}

void _initDefaultCharacters() {
  if (SimpleStorage.getCharacters().isEmpty) {
    final defaultCharacters = [
      Character(
        id: 'yuki',
        name: '雪羽',
        personality: PersonalityType.gentle,
        appearance: CharacterAppearance(
          height: '165cm',
          hairColor: '银白色',
          eyeColor: '淡蓝色',
        ),
        stats: CharacterStats(),
        skills: [
          CharacterSkill(id: 'skill_1', name: '冰雪魔法', description: '操控冰雪的力量', icon: '❄️'),
          CharacterSkill(id: 'skill_2', name: '治愈术', description: '恢复生命值', icon: '💚'),
        ],
        background: '来自冰雪王国的公主，性格温柔内向，喜欢安静地看雪。',
      ),
      Character(
        id: 'rina',
        name: '莉娜',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: '粉色',
          eyeColor: '橙色',
        ),
        stats: CharacterStats(),
        skills: [
          CharacterSkill(id: 'skill_3', name: '活力满点', description: '充满活力', icon: '⚡'),
          CharacterSkill(id: 'skill_4', name: '社交达人', description: '容易交到朋友', icon: '🤝'),
        ],
        background: '活力四射的阳光少女，喜欢有趣的事情和结交新朋友。',
      ),
      Character(
        id: 'miku',
        name: '美琴',
        personality: PersonalityType.mysterious,
        appearance: CharacterAppearance(
          height: '168cm',
          hairColor: '紫色',
          eyeColor: '深紫色',
        ),
        stats: CharacterStats(),
        skills: [
          CharacterSkill(id: 'skill_5', name: '天籁之音', description: '美妙的歌声', icon: '🎵'),
          CharacterSkill(id: 'skill_6', name: '神秘之力', description: '未知的力量', icon: '🔮'),
        ],
        background: '神秘的歌手，拥有天籁般的嗓音，似乎隐藏着很多秘密。',
      ),
      Character(
        id: 'sora',
        name: '空',
        personality: PersonalityType.tsundere,
        appearance: CharacterAppearance(
          height: '170cm',
          hairColor: '蓝色',
          eyeColor: '灰蓝色',
        ),
        stats: CharacterStats(),
        skills: [
          CharacterSkill(id: 'skill_7', name: '电竞高手', description: '游戏高手', icon: '🎮'),
          CharacterSkill(id: 'skill_8', name: '傲娇', description: '嘴上不承认', icon: '😤'),
        ],
        background: '酷酷的电竞少女，实际上是个傲娇，非常在乎你但嘴上不承认。',
      ),
    ];

    for (final char in defaultCharacters) {
      SimpleStorage.addCharacter(char);
    }
  }
}

class StarEncounterApp extends StatelessWidget {
  const StarEncounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '星之邂逅',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const CharacterListScreen(),
    );
  }
}

class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final characters = SimpleStorage.getCharacters();

    return Scaffold(
      appBar: AppBar(
        title: const Text('星之邂逅 ⭐'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: characters.isEmpty
          ? const Center(child: Text('暂无角色'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final character = characters[index];
                return _CharacterCard(
                  character: character,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(character: character),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const _CharacterCard({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getGradientColors(character.id),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    _getAvatarEmoji(character.id),
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getPersonalityText(character.personality),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  String _getAvatarEmoji(String id) {
    switch (id) {
      case 'yuki':
        return '❄️';
      case 'rina':
        return '🌸';
      case 'miku':
        return '🎵';
      case 'sora':
        return '🎮';
      default:
        return '👤';
    }
  }

  List<Color> _getGradientColors(String id) {
    switch (id) {
      case 'yuki':
        return [const Color(0xFFa8edea), const Color(0xFFfed6e3)];
      case 'rina':
        return [const Color(0xFFffdde1), const Color(0xFFee9ca7)];
      case 'miku':
        return [const Color(0xFFc9ffbf), const Color(0xFFa8e063)];
      case 'sora':
        return [const Color(0xFFa1c4fd), const Color(0xFFc2e9fb)];
      default:
        return [Colors.grey[300]!, Colors.grey[400]!];
    }
  }

  String _getPersonalityText(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.gentle:
        return '温柔型';
      case PersonalityType.lively:
        return '活泼型';
      case PersonalityType.cool:
        return '冷酷型';
      case PersonalityType.tsundere:
        return '傲娇型';
      case PersonalityType.shy:
        return '害羞型';
      case PersonalityType.energetic:
        return '精力充沛型';
      case PersonalityType.mysterious:
        return '神秘型';
      case PersonalityType.cheerful:
        return '开朗型';
    }
  }
}

class ChatScreen extends StatefulWidget {
  final Character character;

  const ChatScreen({super.key, required this.character});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<DialogueMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _addInitialMessage();
  }

  void _addInitialMessage() {
    final greeting = _getGreeting(widget.character.personality);
    final message = DialogueMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.character,
      text: greeting,
      emotion: MessageEmotion.happy,
      affectionChange: 0,
    );
    setState(() {
      _messages.add(message);
    });
  }

  String _getGreeting(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.gentle:
        return '你好呀～很高兴见到你！✨';
      case PersonalityType.lively:
        return '哇！终于有人来了！你好呀！🎉';
      case PersonalityType.mysterious:
        return '......你好。我是美琴。🎶';
      case PersonalityType.tsundere:
        return '哼...你也是来打游戏的？';
      case PersonalityType.shy:
        return '啊...你、你好......';
      case PersonalityType.cool:
        return '......来了。';
      case PersonalityType.cheerful:
        return '嘿！今天也要开心度过！🌟';
      case PersonalityType.energetic:
        return '你好，有什么需要帮助的吗？';
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final userMessage = DialogueMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.user,
      text: text,
      emotion: MessageEmotion.happy,
      affectionChange: 0,
    );

    setState(() {
      _messages.add(userMessage);
      _controller.clear();
    });

    // 简单的自动回复
    Future.delayed(const Duration(milliseconds: 500), () {
      final replies = [
        '嗯嗯，我听见了～',
        '真的吗？好厉害呀！',
        '哇，听起来好棒！',
        '呵呵，你真有趣～',
        '我在认真听呢',
      ];
      final reply = DialogueMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.character,
        text: replies[DateTime.now().millisecond % replies.length],
        emotion: MessageEmotion.happy,
        affectionChange: 1,
      );
      setState(() {
        _messages.add(reply);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_getAvatarEmoji(widget.character.id),
                style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(widget.character.name),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.sender == MessageSender.user;

                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: '发送消息...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAvatarEmoji(String id) {
    switch (id) {
      case 'yuki':
        return '❄️';
      case 'rina':
        return '🌸';
      case 'miku':
        return '🎵';
      case 'sora':
        return '🎮';
      default:
        return '👤';
    }
  }
}
