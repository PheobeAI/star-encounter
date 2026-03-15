import 'package:hive_flutter/hive_flutter.dart';
import '../models/character.dart';
import '../models/conversation.dart';
import '../models/story.dart';

/// 数据库服务
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  late Box<Character> _characterBox;
  late Box<ConversationContext> _conversationBox;
  late Box<StoryChapter> _storyBox;

  /// 初始化数据库
  Future<void> initialize() async {
    await Hive.initFlutter();

    // 注册适配器
    Hive.registerAdapter(CharacterAdapter());
    Hive.registerAdapter(CharacterAppearanceAdapter());
    Hive.registerAdapter(CharacterStatsAdapter());
    Hive.registerAdapter(CharacterSkillAdapter());
    Hive.registerAdapter(DialogueMessageAdapter());
    Hive.registerAdapter(ConversationContextAdapter());
    Hive.registerAdapter(StoryChapterAdapter());
    Hive.registerAdapter(StoryChoiceAdapter());
    Hive.registerAdapter(StoryBranchAdapter());
    Hive.registerAdapter(StoryPointAdapter());

    // 打开盒子
    _characterBox = await Hive.openBox<Character>('characters');
    _conversationBox = await Hive.openBox<ConversationContext>('conversations');
    _storyBox = await Hive.openBox<StoryChapter>('story');
  }

  /// 获取角色列表
  List<Character> getCharacters() {
    return _characterBox.values.toList();
  }

  /// 获取角色
  Character? getCharacter(String id) {
    return _characterBox.get(id);
  }

  /// 保存角色
  Future<void> saveCharacter(Character character) async {
    await _characterBox.put(character.id, character);
  }

  /// 添加角色
  Future<void> addCharacter(Character character) async {
    await _characterBox.put(character.id, character);
  }

  /// 删除角色
  Future<void> deleteCharacter(String id) async {
    await _characterBox.delete(id);
  }

  /// 获取对话上下文
  ConversationContext? getConversation(String id) {
    return _conversationBox.get(id);
  }

  /// 保存对话上下文
  Future<void> saveConversation(ConversationContext context) async {
    await _conversationBox.put(context.id, context);
  }

  /// 删除对话上下文
  Future<void> deleteConversation(String id) async {
    await _conversationBox.delete(id);
  }

  /// 获取所有对话上下文
  List<ConversationContext> getAllConversations() {
    return _conversationBox.values.toList();
  }

  /// 获取剧情章节
  List<StoryChapter> getStoryChapters() {
    return _storyBox.values.toList();
  }

  /// 获取剧情章节
  StoryChapter? getStoryChapter(String id) {
    return _storyBox.get(id);
  }

  /// 保存剧情章节
  Future<void> saveStoryChapter(StoryChapter chapter) async {
    await _storyBox.put(chapter.id, chapter);
  }

  /// 删除剧情章节
  Future<void> deleteStoryChapter(String id) async {
    await _storyBox.delete(id);
  }

  /// 清空所有数据
  Future<void> clearAll() async {
    await _characterBox.clear();
    await _conversationBox.clear();
    await _storyBox.clear();
  }
}
