import 'package:flutter/material.dart';
import 'models/character.dart';
import 'models/conversation.dart';
import 'models/story.dart';
import 'services/database_service.dart';
import 'services/ai_service.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '测试应用',
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final DatabaseService _dbService = DatabaseService();
  final AIService _aiService = AIService();
  Character? _character;
  DialogueMessage? _reply;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _dbService.initialize();

    // 创建测试角色
    final character = Character(
      id: 'test_character_1',
      name: '星野',
      personality: PersonalityType.lively,
      appearance: CharacterAppearance(
        height: '165cm',
        hairColor: '粉色',
        eyeColor: '蓝色',
      ),
      stats: CharacterStats(),
      skills: [],
      background: '这是一个活泼可爱的女孩子，喜欢和你聊天。',
    );

    await _dbService.addCharacter(character);
    setState(() {
      _character = character;
    });
  }

  Future<void> _testDialogue() async {
    if (_character == null) return;

    setState(() {
      _reply = null;
    });

    _reply = _aiService.generateReply(
      character: _character!,
      userMessage: '你好！',
      context: null,
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测试')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_character != null)
              Text('角色: ${_character!.name}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _testDialogue,
              child: const Text('测试对话'),
            ),
            const SizedBox(height: 20),
            if (_reply != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('回复: ${_reply!.text}'),
                    if (_reply!.affectionChange != 0)
                      Text(
                        '好感度变化: ${_reply!.affectionChange}',
                        style: TextStyle(
                          color: _reply!.affectionChange > 0 ? Colors.green : Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
