import 'package:flutter/foundation.dart';
import '../models/story.dart';
import 'database_service.dart';

/// 剧情服务
class StoryService extends ChangeNotifier {
  final DatabaseService _databaseService;
  List<StoryChapter> _storyChapters = [];

  List<StoryChapter> get storyChapters => _storyChapters;

  StoryService({
    required DatabaseService databaseService,
  })  : _databaseService = databaseService {
    _loadStoryChapters();
  }

  /// 加载剧情章节
  void _loadStoryChapters() {
    _storyChapters = _databaseService.getStoryChapters();
    notifyListeners();
  }

  /// 获取剧情章节
  StoryChapter? getChapter(String id) {
    return _storyChapters.firstWhere(
      (c) => c.id == id,
      orElse: () => null,
    );
  }

  /// 获取第一章
  StoryChapter? getFirstChapter() {
    // 按章节号排序
    final sortedChapters = List<StoryChapter>.from(_storyChapters)
      ..sort((a, b) => a.chapterNumber.compareTo(b.chapterNumber));

    return sortedChapters.first;
  }

  /// 获取下一个章节
  StoryChapter? getNextChapter(String currentChapterId) {
    final currentIndex = _storyChapters.indexWhere((c) => c.id == currentChapterId);

    if (currentIndex == -1 || currentIndex == _storyChapters.length - 1) {
      return null;
    }

    return _storyChapters[currentIndex + 1];
  }

  /// 根据选择获取下一个章节
  StoryChapter? getNextChapterByChoice(String currentChapterId, String choiceId) {
    final currentChapter = getChapter(currentChapterId);
    if (currentChapter == null) return null;

    // 查找选中的选项
    for (final choice in currentChapter.choices) {
      if (choice.id == choiceId) {
        return getChapter(choice.nextChapterId);
      }
    }

    return null;
  }

  /// 解锁章节
  Future<void> unlockChapter(String chapterId) async {
    final chapter = getChapter(chapterId);
    if (chapter != null) {
      await _databaseService.saveStoryChapter(
        chapter.copyWith(isUnlocked: true),
      );
      _loadStoryChapters();
    }
  }

  /// 创建章节
  Future<void> createChapter(StoryChapter chapter) async {
    await _databaseService.saveStoryChapter(chapter);
    _loadStoryChapters();
  }

  /// 删除章节
  Future<void> deleteChapter(String id) async {
    await _databaseService.deleteStoryChapter(id);
    _loadStoryChapters();
  }
}
