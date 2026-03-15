import 'package:hive/hive.dart';
import 'character.dart';

part 'conversation.g.dart';

/// 消息发送者类型
enum MessageSender {
  user,
  character,
}

/// 消息情感
enum MessageEmotion {
  happy,    // 开心
  sad,      // 难过
  angry,    // 生气
  shy,      // 害羞
  excited,  // 兴奋
  calm,     // 平静
  surprised, // 惊讶
}

/// 对话消息
@HiveType(typeId: 4)
class DialogueMessage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final MessageSender sender;

  @HiveField(2)
  final String text;

  @HiveField(3)
  final MessageEmotion emotion;

  @HiveField(4)
  final int affectionChange; // 好感度变化

  @HiveField(5)
  final DateTime timestamp;

  DialogueMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.emotion = MessageEmotion.calm,
    this.affectionChange = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// 对话上下文
@HiveType(typeId: 5)
class ConversationContext {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String characterId;

  @HiveField(2)
  final List<DialogueMessage> messages;

  @HiveField(3)
  final int totalAffectionChange;

  ConversationContext({
    required this.id,
    required this.characterId,
    required this.messages,
    this.totalAffectionChange = 0,
  });

  /// 添加消息
  ConversationContext addMessage(DialogueMessage message) {
    final newMessages = List<DialogueMessage>.from(messages);
    newMessages.add(message);
    return ConversationContext(
      id: id,
      characterId: characterId,
      messages: newMessages,
      totalAffectionChange: totalAffectionChange + message.affectionChange,
    );
  }

  /// 获取最新消息
  DialogueMessage get lastMessage {
    return messages.last;
  }

  /// 获取消息数量
  int get messageCount => messages.length;
}
