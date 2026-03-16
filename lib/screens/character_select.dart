import 'package:flutter/material.dart';
import 'models/character.dart';

/// 角色选择屏幕
class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  final List<Character> _characters = [];
  final List<Character> _filteredCharacters = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedPersonality = 'all';

  @override
  void initState() {
    super.initState();
    _loadCharacters();
    _searchController.addListener(_filterCharacters);
  }

  void _loadCharacters() {
    // 从存储加载角色（这里使用模拟数据）
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

    setState(() {
      _characters.clear();
      _characters.addAll(defaultCharacters);
      _filteredCharacters.clear();
      _filteredCharacters.addAll(_characters);
    });
  }

  void _filterCharacters() {
    final query = _searchController.text.toLowerCase();
    final personality = _selectedPersonality;

    setState(() {
      _filteredCharacters.clear();
      for (final char in _characters) {
        final matchesQuery = char.name.toLowerCase().contains(query) ||
            char.background.toLowerCase().contains(query);
        final matchesPersonality = personality == 'all' ||
            char.personality.toString().toLowerCase().contains(personality);

        if (matchesQuery && matchesPersonality) {
          _filteredCharacters.add(char);
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择角色'),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: Column(
        children: [
          // 搜索栏
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '搜索角色...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),

          // 性别筛选
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('全部', 'all'),
                _buildFilterChip('温柔型', 'gentle'),
                _buildFilterChip('活泼型', 'lively'),
                _buildFilterChip('神秘型', 'mysterious'),
                _buildFilterChip('傲娇型', 'tsundere'),
                _buildFilterChip('精力充沛型', 'energetic'),
                _buildFilterChip('开朗型', 'cheerful'),
              ],
            ),
          ),

          const Divider(height: 1),

          // 角色列表
          Expanded(
            child: _filteredCharacters.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '没有找到匹配的角色',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCharacters.length,
                    itemBuilder: (context, index) {
                      final character = _filteredCharacters[index];
                      return _CharacterSelectCard(
                        character: character,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(character: character),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedPersonality == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedPersonality = value;
          _filterCharacters();
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: Colors.pink[100],
      checkmarkColor: Colors.pink[400],
      labelStyle: TextStyle(
        color: isSelected ? Colors.pink[700] : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class _CharacterSelectCard extends StatelessWidget {
  final Character character;
  final VoidCallback onTap;

  const _CharacterSelectCard({
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 头像
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _getGradientColors(character.id),
                  ),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    _getAvatarEmoji(character.id),
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getPersonalityText(character.personality),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 技能标签
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: character.skills.take(2).map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(skill.icon, style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 4),
                              Text(
                                skill.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.pink[700],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              // 箭头
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
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
