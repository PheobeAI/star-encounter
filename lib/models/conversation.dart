/// 消息发送者
enum MessageSender {
  user,     // 用户
  character, // 角色
}

/// 消息情感
enum MessageEmotion {
  happy,     // 开心
  sad,       // 难过
  angry,     // 生气
  surprised, // 惊讶
  neutral,   // 中性
}

/// 对话消息
class DialogueMessage {
  final String id;
  final MessageSender sender;
  final String text;
  final MessageEmotion emotion;
  final int affectionChange; // 好感度变化
  final DateTime timestamp;

  DialogueMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.emotion,
    this.affectionChange = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// 对话上下文
class ConversationContext {
  final String id;
  final String characterId;
  final List<DialogueMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConversationContext({
    required this.id,
    required this.characterId,
    required this.messages,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();
}
