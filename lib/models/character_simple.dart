import 'dart:convert';

/// 简化的角色模型（不使用Hive）
class Character {
  final String id;
  final String name;
  final String personality;
  final String height;
  final String hairColor;
  final String eyeColor;
  final int level;
  final int exp;
  final int affection;
  final List<String> skills;
  final String background;

  Character({
    required this.id,
    required this.name,
    required this.personality,
    required this.height,
    required this.hairColor,
    required this.eyeColor,
    this.level = 1,
    this.exp = 0,
    this.affection = 0,
    this.skills = const [],
    required this.background,
  });

  /// 从JSON创建角色
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      personality: json['personality'],
      height: json['height'],
      hairColor: json['hairColor'],
      eyeColor: json['eyeColor'],
      level: json['level'] ?? 1,
      exp: json['exp'] ?? 0,
      affection: json['affection'] ?? 0,
      skills: List<String>.from(json['skills'] ?? []),
      background: json['background'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'personality': personality,
      'height': height,
      'hairColor': hairColor,
      'eyeColor': eyeColor,
      'level': level,
      'exp': exp,
      'affection': affection,
      'skills': skills,
      'background': background,
    };
  }

  /// 保存到文件
  Future<void> saveToFile(String filename) async {
    final file = await _getFile(filename);
    await file.writeAsString(jsonEncode(toJson()));
  }

  /// 从文件加载
  static Future<Character> loadFromFile(String filename) async {
    final file = await _getFile(filename);
    final content = await file.readAsString();
    return Character.fromJson(jsonDecode(content));
  }

  static Future<FileSystemFile> _getFile(String filename) async {
    // TODO: 实现文件路径
    // 暂时返回null
    throw UnimplementedError('File operations not implemented');
  }
}
