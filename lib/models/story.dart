import 'package:hive/hive.dart';

part 'story.g.dart';

/// 剧情章节
@HiveType(typeId: 6)
class StoryChapter {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final int chapterNumber; // 章节数

  @HiveField(3)
  final String content; // 剧情文本

  @HiveField(4)
  final List<StoryChoice> choices; // 剧情选择

  @HiveField(5)
  final bool isUnlocked; // 是否解锁

  @HiveField(6)
  final DateTime createdAt;

  StoryChapter({
    required this.id,
    required this.title,
    required this.chapterNumber,
    required this.content,
    required this.choices,
    this.isUnlocked = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

/// 剧情选择
@HiveType(typeId: 7)
class StoryChoice {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text; // 选项文本

  @HiveField(2)
  final String nextChapterId; // 下一个章节ID

  @HiveField(3)
  final int affectionChange; // 好感度变化

  StoryChoice({
    required this.id,
    required this.text,
    required this.nextChapterId,
    this.affectionChange = 0,
  });
}

/// 剧情分支
@HiveType(typeId: 8)
class StoryBranch {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chapterId; // 所属章节

  @HiveField(2)
  final String name; // 分支名称

  @HiveField(3)
  final List<StoryChoice> choices;

  @HiveField(4)
  final String? nextChapterId; // 结束章节ID

  StoryBranch({
    required this.id,
    required this.chapterId,
    required this.name,
    required this.choices,
    this.nextChapterId,
  });
}

/// 剧情点数
@HiveType(typeId: 9)
class StoryPoint {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String chapterId;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final int affinityReward; // 羁绊点数奖励

  StoryPoint({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.affinityReward,
  });
}
