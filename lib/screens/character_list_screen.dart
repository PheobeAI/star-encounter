import 'package:flutter/material.dart';
import 'models/character.dart';
import 'services/database_service.dart';
import 'character_detail_screen.dart';

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<Character> _characters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    await _dbService.initialize();
    setState(() {
      _characters = _dbService.getCharacters();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择角色'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _characters.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('还没有角色，请先创建'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _createCharacter,
                        child: const Text('创建角色'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _characters.length,
                  itemBuilder: (context, index) {
                    final character = _characters[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('assets/images/${character.id}.png'),
                        ),
                        title: Text(character.name),
                        subtitle: Text(_getPersonalityText(character.personality)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CharacterDetailScreen(character: character),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: _characters.isEmpty
          ? FloatingActionButton(
              onPressed: _createCharacter,
              child: const Icon(Icons.add),
            )
          : null,
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

  Future<void> _createCharacter() async {
    final name = await _showInputDialog('角色名称');
    if (name == null || name.isEmpty) return;

    final personality = await _showPersonalityDialog();
    if (personality == null) return;

    final character = Character(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      personality: personality,
      appearance: CharacterAppearance(
        height: '160cm',
        hairColor: '粉色',
        eyeColor: '蓝色',
      ),
      stats: CharacterStats(),
      skills: [],
      background: '这是一个新的角色，等待你的陪伴。',
    );

    await _dbService.addCharacter(character);
    setState(() {
      _characters = _dbService.getCharacters();
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterDetailScreen(character: character),
        ),
      );
    }
  }

  Future<String?> _showInputDialog(String title) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: '请输入名称'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<PersonalityType?> _showPersonalityDialog() async {
    final personalities = PersonalityType.values;
    final results = await showDialog<List<int>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择性格'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: personalities.map((p) {
            return ListTile(
              title: Text(_getPersonalityText(p)),
              onTap: () => Navigator.pop(context, [personalities.indexOf(p)]),
            );
          }).toList(),
        ),
      ),
    );

    if (results == null || results.isEmpty) return null;
    return personalities[results[0]];
  }
}
