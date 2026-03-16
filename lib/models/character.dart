/// 角色性格类型
enum PersonalityType {
  lively,     // 活泼
  gentle,     // 温柔
  cool,       // 高冷
  tsundere,   // 傲娇
  shy,        // 害羞
  energetic,  // 精力充沛
  mysterious, // 神秘
  cheerful,   // 开朗
}

/// 角色外观
class CharacterAppearance {
  final String height; // 身高
  final String hairColor; // 发色
  final String eyeColor; // 眼色
  final String? outfit; // 服装
  final String? accessory; // 配饰

  CharacterAppearance({
    required this.height,
    required this.hairColor,
    required this.eyeColor,
    this.outfit,
    this.accessory,
  });
}

/// 角色属性
class CharacterStats {
  final int level; // 等级
  final int exp; // 经验值
  final int affection; // 好感度 (0-100)
  final int affinity; // 羁绊点数

  CharacterStats({
    this.level = 1,
    this.exp = 0,
    this.affection = 0,
    this.affinity = 0,
  });

  /// 获取升级所需经验值
  int get requiredExp => level * 100;

  /// 检查是否可以升级
  bool canLevelUp() => exp >= requiredExp;

  /// 升级
  CharacterStats levelUp() {
    if (!canLevelUp()) return this;
    return CharacterStats(
      level: level + 1,
      exp: exp - requiredExp,
      affection: affection,
      affinity: affinity + 10,
    );
  }

  /// 增加经验值
  CharacterStats addExp(int amount) {
    return CharacterStats(
      level: level,
      exp: exp + amount,
      affection: affection,
      affinity: affinity,
    );
  }

  /// 增加好感度
  CharacterStats addAffection(int amount) {
    return CharacterStats(
      level: level,
      exp: exp,
      affection: (affection + amount).clamp(0, 100),
      affinity: affinity,
    );
  }
}

/// 角色技能
class CharacterSkill {
  final String id;
  final String name;
  final String description;
  final int level; // 当前等级
  final int maxLevel; // 最大等级
  final String icon; // 技能图标

  CharacterSkill({
    required this.id,
    required this.name,
    required this.description,
    this.level = 1,
    this.maxLevel = 5,
    required this.icon,
  });

  /// 检查是否可以升级
  bool canUpgrade() => level < maxLevel;

  /// 升级技能
  CharacterSkill upgrade() {
    if (!canUpgrade()) return this;
    return CharacterSkill(
      id: id,
      name: name,
      description: description,
      level: level + 1,
      maxLevel: maxLevel,
      icon: icon,
    );
  }
}

/// 角色数据模型
class Character {
  final String id;
  final String name;
  final PersonalityType personality;
  final CharacterAppearance appearance;
  final CharacterStats stats;
  final List<CharacterSkill> skills;
  final String background; // 背景故事
  final DateTime createdAt;

  Character({
    required this.id,
    required this.name,
    required this.personality,
    required this.appearance,
    required this.stats,
    required this.skills,
    required this.background,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 深拷贝
  Character copyWith({
    String? id,
    String? name,
    PersonalityType? personality,
    CharacterAppearance? appearance,
    CharacterStats? stats,
    List<CharacterSkill>? skills,
    String? background,
    DateTime? createdAt,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      personality: personality ?? this.personality,
      appearance: appearance ?? this.appearance,
      stats: stats ?? this.stats,
      skills: skills ?? this.skills,
      background: background ?? this.background,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// 升级角色
  Character levelUp() {
    return copyWith(stats: stats.levelUp());
  }

  /// 增加经验值
  Character addExp(int amount) {
    return copyWith(stats: stats.addExp(amount));
  }

  /// 增加好感度
  Character addAffection(int amount) {
    return copyWith(stats: stats.addAffection(amount));
  }

  /// 添加技能
  Character addSkill(CharacterSkill skill) {
    final newSkills = List<CharacterSkill>.from(skills);
    if (!newSkills.any((s) => s.id == skill.id)) {
      newSkills.add(skill);
    }
    return copyWith(skills: newSkills);
  }

  /// 升级技能
  Character upgradeSkill(String skillId) {
    final newSkills = skills.map((skill) {
      if (skill.id == skillId) {
        return skill.upgrade();
      }
      return skill;
    }).toList();
    return copyWith(skills: newSkills);
  }
}
