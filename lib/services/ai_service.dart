import 'dart:math';
import '../models/character.dart';
import '../models/conversation.dart';

/// AI对话服务
class AIService {
  // 预设对话库
  static final List<String> _greetings = [
    '你好呀~',
    '嗨！今天过得怎么样？',
    '呀，好久不见！',
    '你好，很高兴见到你！',
  ];

  static final List<String> _livelyResponses = [
    '哇！真的吗？太棒了！',
    '哈哈哈，好有趣！',
    '真的假的？',
    '天呐，我完全没想到！',
  ];

  static final List<String> _gentleResponses = [
    '嗯嗯，我理解你的感受。',
    '没关系，我会一直陪着你。',
    '谢谢你告诉我这些。',
    '我会好好记住的。',
  ];

  static final List<String> _coolResponses = [
    '哦，是吗。',
    '嗯，我知道了。',
    '确实如此。',
    '有道理。',
  ];

  static final List<String> _tsundereResponses = [
    '哼，才不是特意为你说的呢！',
    '切，你听不懂吗？',
    '...随便啦。',
    '笨蛋，我只是刚好这么说而已。',
  ];

  static final List<String> _shyResponses = [
    '啊...那个...我...',
    '呃...不知道怎么说...',
    '嘿嘿...',
    '你...你看得见吗？',
  ];

  static final List<String> _excitedResponses = [
    '耶！太棒了！',
    '好耶好耶！',
    '哇！我最喜欢这个了！',
    '哈哈，开心到飞起！',
  ];

  static final List<String> _mysteriousResponses = [
    '有些事情，你不需要知道。',
    '这也是命运的一部分...',
    '嘘...不要问太多。',
    '这其中的秘密，只有时间能告诉你。',
  ];

  static final List<String> _cheerfulResponses = [
    '哇！今天也是美好的一天！',
    '嘻嘻，真开心！',
    '哈哈，太有趣了！',
    '阳光明媚，心情超好！',
  ];

  /// 生成对话回复
  DialogueMessage generateReply({
    required Character character,
    required String userMessage,
    required ConversationContext? context,
  }) {
    // 根据性格选择回复风格
    final replyStyle = _getReplyStyle(character.personality);

    // 随机选择回复
    final replyText = _selectRandomReply(replyStyle);

    // 计算好感度变化
    final affectionChange = _calculateAffectionChange(
      character.personality,
      userMessage,
      context?.lastMessage.text ?? '',
    );

    // 随机情感
    final emotion = _selectRandomEmotion(character.personality);

    return DialogueMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: MessageSender.character,
      text: replyText,
      emotion: emotion,
      affectionChange: affectionChange,
    );
  }

  /// 根据性格获取回复风格
  List<String> _getReplyStyle(PersonalityType personality) {
    switch (personality) {
      case PersonalityType.lively:
        return [..._greetings, ..._livelyResponses];
      case PersonalityType.gentle:
        return [..._greetings, ..._gentleResponses];
      case PersonalityType.cool:
        return [..._greetings, ..._coolResponses];
      case PersonalityType.tsundere:
        return [..._greetings, ..._tsundereResponses];
      case PersonalityType.shy:
        return [..._greetings, ..._shyResponses];
      case PersonalityType.energetic:
        return [..._greetings, ..._cheerfulResponses];
      case PersonalityType.mysterious:
        return [..._greetings, ..._mysteriousResponses];
      case PersonalityType.cheerful:
        return [..._greetings, ..._cheerfulResponses];
    }
  }

  /// 随机选择回复
  String _selectRandomReply(List<String> replies) {
    final random = Random();
    return replies[random.nextInt(replies.length)];
  }

  /// 随机选择情感
  MessageEmotion _selectRandomEmotion(PersonalityType personality) {
    final random = Random();
    final emotions = MessageEmotion.values;
    return emotions[random.nextInt(emotions.length)];
  }

  /// 计算好感度变化
  int _calculateAffectionChange(
    PersonalityType personality,
    String userMessage,
    String lastCharacterMessage,
  ) {
    final random = Random();

    // 基础好感度变化
    int baseChange = random.nextInt(3) - 1; // -1, 0, 1

    // 根据性格调整
    switch (personality) {
      case PersonalityType.lively:
      case PersonalityType.energetic:
      case PersonalityType.cheerful:
        baseChange += 1; // 活泼性格更容易增加好感度
        break;
      case PersonalityType.gentle:
        baseChange += 0; // 温柔性格保持稳定
        break;
      case PersonalityType.tsundere:
        baseChange = random.nextInt(5) - 2; // 傲娇性格变化较大
        break;
      default:
        baseChange += 0;
    }

    return baseChange.clamp(-2, 2);
  }
}
