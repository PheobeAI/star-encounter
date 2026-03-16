import 'package:flutter/material.dart';
import 'models/character.dart';
import 'screens/character_select.dart';

// 简单的内存存储
class SimpleStorage {
  static final List<Character> _characters = [];
  static int _playerAffection = 0; // 玩家总好感度

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

  static int getPlayerAffection() => _playerAffection;
  static void addAffection(int amount) {
    _playerAffection += amount;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      Character(
        id: 'hikari',
        name: '光',
        personality: PersonalityType.energetic,
        appearance: CharacterAppearance(
          height: '162cm',
          hairColor: '金色',
          eyeColor: '亮黄色',
        ),
        stats: CharacterStats(),
        skills: [
          CharacterSkill(id: 'skill_9', name: '光之舞', description: '优雅的舞蹈', icon: '💃'),
          CharacterSkill(id: 'skill_10', name: '乐观主义', description: '永远积极', icon: '☀️'),
        ],
        background: '充满活力的舞者，相信光和希望，总是能给人带来正能量。',
      ),
      Character(
        id: 'akari',
        name: '明',
        personality: PersonalityType.cheerful,
        appearance: CharacterAppearance(
          height: '158cm',
          hairColor: '橙色',
          eyeColor: '红色',
        ),
        stats: CharacterStats(),
        skills: [
          CharacterSkill(id: 'skill_11', name: '热情似火', description: '热情洋溢', icon: '🔥'),
          CharacterSkill(id: 'skill_12', name: '美食家', description: '热爱美食', icon: '🍜'),
        ],
        background: '充满热情的美食家，喜欢探索各种美食，是团队中的开心果。',
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
      home: const HomeScreen(),
    );
  }
}

/// 主界面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部标题
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '⭐ 星之邂逅',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        // 查看所有角色
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CharacterSelectScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.people, color: Colors.white),
                        ),
                        // 设置
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SettingsScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 玩家信息卡片
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Text('👤', style: TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '训练师',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '总好感度: ${SimpleStorage.getPlayerAffection()}',
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 快速开始按钮
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CharacterSelectScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('开始'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 快速开始
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '快速开始',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // 最近对话
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '最近对话',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return _RecentChatCard(
                              characterId: ['yuki', 'rina', 'miku'][index],
                              onTap: () {
                                final character = SimpleStorage.getCharacter(
                                  ['yuki', 'rina', 'miku'][index],
                                );
                                if (character != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChatScreen(character: character),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentChatCard extends StatelessWidget {
  final String characterId;
  final VoidCallback onTap;

  const _RecentChatCard({
    required this.characterId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final character = SimpleStorage.getCharacter(characterId);
    if (character == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: _getGradientColors(characterId)),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: Text(_getAvatarEmoji(characterId), style: const TextStyle(fontSize: 24)),
          ),
        ),
        title: Text(character.name),
        subtitle: Text('最近对话: ${_getLastMessageTime()}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  String _getAvatarEmoji(String id) {
    switch (id) {
      case 'yuki': return '❄️';
      case 'rina': return '🌸';
      case 'miku': return '🎵';
      case 'sora': return '🎮';
      case 'hikari': return '💃';
      case 'akari': return '🔥';
      default: return '👤';
    }
  }

  List<Color> _getGradientColors(String id) {
    switch (id) {
      case 'yuki': return [const Color(0xFFa8edea), const Color(0xFFfed6e3)];
      case 'rina': return [const Color(0xFFffdde1), const Color(0xFFee9ca7)];
      case 'miku': return [const Color(0xFFc9ffbf), const Color(0xFFa8e063)];
      case 'sora': return [const Color(0xFFa1c4fd), const Color(0xFFc2e9fb)];
      case 'hikari': return [const Color(0xFFFFF5E1), const Color(0xFFFFD700)];
      case 'akari': return [const Color(0xFFFFE5E5), const Color(0xFFFF6B6B)];
      default: return [Colors.grey[300]!, Colors.grey[400]!];
    }
  }

  String _getLastMessageTime() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour < 12) return '今天 ${hour}:00';
    if (hour < 18) return '今天 ${hour}:00';
    return '今天 ${hour}:00';
  }
}

/// 设置页面
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.pink[100],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingItem(
            icon: Icons.info_outline,
            title: '关于',
            subtitle: '星之邂逅 v1.0.0',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.privacy_tip_outlined,
            title: '隐私政策',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.description_outlined,
            title: '用户协议',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.help_outline,
            title: '帮助与反馈',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.delete_outline,
            title: '清除数据',
            subtitle: '清除所有角色数据',
            onTap: () {
              _showClearDataDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除数据'),
        content: const Text('确定要清除所有角色数据吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              SimpleStorage.getCharacters().clear();
              SimpleStorage.addAffection(0);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('数据已清除')),
              );
            },
            child: const Text('确定', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// 聊天页面
class ChatScreen extends StatefulWidget {
  final Character character;

  const ChatScreen({super.key, required this.character});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<DialogueMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();

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

    // 滚动到底部
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // 模拟回复
    Future.delayed(const Duration(milliseconds: 800), () {
      final replies = [
        '嗯嗯，我听见了～',
        '真的吗？好厉害呀！',
        '哇，听起来好棒！',
        '呵呵，你真有趣～',
        '我在认真听呢',
        '✨ 好好玩！',
        '哇，你懂得好多呀！',
      ];
      final reply = DialogueMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sender: MessageSender.character,
        text: replies[DateTime.now().millisecond % replies.length],
        emotion: MessageEmotion.happy,
        affectionChange: 1,
      );

      SimpleStorage.addAffection(1);

      setState(() {
        _messages.add(reply);
      });

      // 滚动到底部
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(_getAvatarEmoji(widget.character.id), style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(widget.character.name),
          ],
        ),
        backgroundColor: Colors.pink[100],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CharacterDetailScreen(character: widget.character),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.sender == MessageSender.user;
                final showAvatar = !isUser && (index == 0 || _messages[index - 1].sender == MessageSender.user);

                return _MessageBubble(
                  message: message,
                  isUser: isUser,
                  showAvatar: showAvatar,
                  characterId: widget.character.id,
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
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
      child: SafeArea(
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAvatarEmoji(String id) {
    switch (id) {
      case 'yuki': return '❄️';
      case 'rina': return '🌸';
      case 'miku': return '🎵';
      case 'sora': return '🎮';
      case 'hikari': return '💃';
      case 'akari': return '🔥';
      default: return '👤';
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final DialogueMessage message;
  final bool isUser;
  final bool showAvatar;
  final String characterId;

  const _MessageBubble({
    required this.message,
    required this.isUser,
    required this.showAvatar,
    required this.characterId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            if (showAvatar)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: _getGradientColors(characterId)),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getAvatarEmoji(characterId),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              )
            else
              const SizedBox(width: 36),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? Colors.pink : Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 44),
        ],
      ),
    );
  }

  String _getAvatarEmoji(String id) {
    switch (id) {
      case 'yuki': return '❄️';
      case 'rina': return '🌸';
      case 'miku': return '🎵';
      case 'sora': return '🎮';
      case 'hikari': return '💃';
      case 'akari': return '🔥';
      default: return '👤';
    }
  }

  List<Color> _getGradientColors(String id) {
    switch (id) {
      case 'yuki': return [const Color(0xFFa8edea), const Color(0xFFfed6e3)];
      case 'rina': return [const Color(0xFFffdde1), const Color(0xFFee9ca7)];
      case 'miku': return [const Color(0xFFc9ffbf), const Color(0xFFa8e063)];
      case 'sora': return [const Color(0xFFa1c4fd), const Color(0xFFc2e9fb)];
      case 'hikari': return [const Color(0xFFFFF5E1), const Color(0xFFFFD700)];
      case 'akari': return [const Color(0xFFFFE5E5), const Color(0xFFFF6B6B)];
      default: return [Colors.grey[300]!, Colors.grey[400]!];
    }
  }
}

/// 角色详情页
class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        backgroundColor: Colors.pink[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 角色头像
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getGradientColors(character.id),
                  ),
                  borderRadius: BorderRadius.circular(75),
                ),
                child: Center(
                  child: Text(
                    _getAvatarEmoji(character.id),
                    style: const TextStyle(fontSize: 70),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 基本信息
            _buildSection('基本信息', [
              _buildInfoRow('姓名', character.name),
              _buildInfoRow('性格', _getPersonalityText(character.personality)),
              _buildInfoRow('身高', character.appearance.height),
              _buildInfoRow('发色', character.appearance.hairColor),
              _buildInfoRow('瞳色', character.appearance.eyeColor),
            ]),

            const SizedBox(height: 20),

            // 角色介绍
            _buildSection('角色介绍', [
              Text(
                character.background,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ]),

            const SizedBox(height: 20),

            // 技能
            _buildSection('技能', [
              ...character.skills.map((skill) => _buildSkillRow(skill)),
            ]),

            const SizedBox(height: 30),

            // 开始对话按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(character: character),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '开始对话 💬',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRow(CharacterSkill skill) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(skill.icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  skill.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  skill.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
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
      case 'yuki': return '❄️';
      case 'rina': return '🌸';
      case 'miku': return '🎵';
      case 'sora': return '🎮';
      case 'hikari': return '💃';
      case 'akari': return '🔥';
      default: return '👤';
    }
  }

  List<Color> _getGradientColors(String id) {
    switch (id) {
      case 'yuki': return [const Color(0xFFa8edea), const Color(0xFFfed6e3)];
      case 'rina': return [const Color(0xFFffdde1), const Color(0xFFee9ca7)];
      case 'miku': return [const Color(0xFFc9ffbf), const Color(0xFFa8e063)];
      case 'sora': return [const Color(0xFFa1c4fd), const Color(0xFFc2e9fb)];
      case 'hikari': return [const Color(0xFFFFF5E1), const Color(0xFFFFD700)];
      case 'akari': return [const Color(0xFFFFE5E5), const Color(0xFFFF6B6B)];
      default: return [Colors.grey[300]!, Colors.grey[400]!];
    }
  }

  String _getPersonalityText(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.gentle: return '温柔型';
      case PersonalityType.lively: return '活泼型';
      case PersonalityType.mysterious: return '神秘型';
      case PersonalityType.tsundere: return '傲娇型';
      case PersonalityType.energetic: return '精力充沛型';
      case PersonalityType.cheerful: return '开朗型';
      case PersonalityType.cool: return '冷酷型';
      case PersonalityType.shy: return '害羞型';
    }
  }
}
