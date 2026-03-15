import 'package:flutter/foundation.dart';
import '../models/character.dart';
import 'database_service.dart';
import 'ai_service.dart';

/// 角色服务
class CharacterService extends ChangeNotifier {
  final DatabaseService _databaseService;
  final AIService _aiService;

  List<Character> _characters = [];
  Character? _currentCharacter;
  List<StoryChapter> _storyChapters = [];

  List<Character> get characters => _characters;
  Character? get currentCharacter => _currentCharacter;
  List<StoryChapter> get storyChapters => _storyChapters;

  CharacterService({
    required DatabaseService databaseService,
    required AIService aiService,
  })  : _databaseService = databaseService,
        _aiService = aiService {
    _loadCharacters();
    _loadStoryChapters();
  }

  /// 加载角色列表
  void _loadCharacters() {
    _characters = _databaseService.getCharacters();
    notifyListeners();
  }

  /// 加载剧情章节
  void _loadStoryChapters() {
    _storyChapters = _databaseService.getStoryChapters();
  }

  /// 获取角色
  Character? getCharacter(String id) {
    return _characters.firstWhere(
      (c) => c.id == id,
      orElse: () => throw Exception('Character not found'),
    );
  }

  /// 选择角色
  void selectCharacter(String id) {
    _currentCharacter = getCharacter(id);
    notifyListeners();
  }

  /// 创建角色
  Future<void> createCharacter(Character character) async {
    await _databaseService.addCharacter(character);
    _loadCharacters();
  }

  /// 删除角色
  Future<void> deleteCharacter(String id) async {
    await _databaseService.deleteCharacter(id);
    _loadCharacters();
  }

  /// 升级角色
  Future<void> levelUpCharacter(String id) async {
    final character = getCharacter(id);
    final newCharacter = character!.levelUp();

    await _databaseService.saveCharacter(newCharacter);

    // 通知角色列表更新
    _loadCharacters();
    notifyListeners();
  }

  /// 增加经验值
  Future<void> addExpToCharacter(String id, int amount) async {
    final character = getCharacter(id);
    final newCharacter = character!.addExp(amount);

    await _databaseService.saveCharacter(newCharacter);
    _loadCharacters();
  }

  /// 增加好感度
  Future<void> addAffectionToCharacter(String id, int amount) async {
    final character = getCharacter(id);
    final newCharacter = character!.addAffection(amount);

    await _databaseService.saveCharacter(newCharacter);
    _loadCharacters();
  }

  /// 升级技能
  Future<void> upgradeSkill(String characterId, String skillId) async {
    final character = getCharacter(characterId);
    final newCharacter = character!.upgradeSkill(skillId);

    await _databaseService.saveCharacter(newCharacter);
    _loadCharacters();
  }

  /// 生成对话回复
  DialogueMessage generateReply({
    required String characterId,
    required String userMessage,
    required ConversationContext? context,
  }) {
    final character = getCharacter(characterId);
    return _aiService.generateReply(
      character: character!,
      userMessage: userMessage,
      context: context,
    );
  }
}
