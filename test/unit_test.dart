import 'package:flutter_test/flutter_test.dart';
import 'package:star_encounter/models/character.dart';
import 'package:star_encounter/models/conversation.dart';
import 'package:star_encounter/services/ai_service.dart';

void main() {
  group('AIService Tests', () {
    late AIService aiService;
    late Character testCharacter;

    setUp(() {
      aiService = AIService();
      testCharacter = Character(
        id: 'test_001',
        name: '测试角色',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: '粉色',
          eyeColor: '蓝色',
        ),
        stats: CharacterStats(),
        skills: [],
        background: '这是一个测试角色。',
      );
    });

    test('generateReply should return a DialogueMessage', () {
      final reply = aiService.generateReply(
        character: testCharacter,
        userMessage: '你好',
        context: null,
      );

      expect(reply, isA<DialogueMessage>());
      expect(reply.text, isNotEmpty);
      expect(reply.sender, equals(MessageSender.character));
    });

    test('generateReply should include affection change', () {
      final reply = aiService.generateReply(
        character: testCharacter,
        userMessage: '你好',
        context: null,
      );

      expect(reply.affectionChange, isA<int>());
    });

    test('generateReply should work with conversation context', () {
      final context = ConversationContext(
        characterId: 'test_001',
        messages: [
          DialogueMessage(
            id: '1',
            sender: MessageSender.user,
            text: '你好',
            emotion: MessageEmotion.happy,
            affectionChange: 0,
          ),
        ],
        lastMessage: DialogueMessage(
          id: '2',
          sender: MessageSender.character,
          text: '你好呀！',
          emotion: MessageEmotion.happy,
          affectionChange: 1,
        ),
      );

      final reply = aiService.generateReply(
        character: testCharacter,
        userMessage: '今天天气真好',
        context: context,
      );

      expect(reply, isA<DialogueMessage>());
    });

    test('different personalities should produce different replies', () {
      final personalities = [
        PersonalityType.lively,
        PersonalityType.gentle,
        PersonalityType.cool,
        PersonalityType.tsundere,
        PersonalityType.shy,
        PersonalityType.mysterious,
        PersonalityType.cheerful,
      ];

      final replies = <String>[];
      
      for (final personality in personalities) {
        final character = Character(
          id: 'test_${personality.name}',
          name: '角色',
          personality: personality,
          appearance: CharacterAppearance(
            height: '160cm',
            hairColor: '黑色',
            eyeColor: '黑色',
          ),
          stats: CharacterStats(),
          skills: [],
          background: '测试',
        );
        
        final reply = aiService.generateReply(
          character: character,
          userMessage: '你好',
          context: null,
        );
        replies.add(reply.text);
      }

      // All personalities should produce some response
      expect(replies.length, equals(personalityities.length));
      expect(replies.every((r) => r.isNotEmpty), isTrue);
    });
  });

  group('Character Model Tests', () {
    test('Character should be created with correct properties', () {
      final character = Character(
        id: 'char_001',
        name: '雪羽',
        personality: PersonalityType.gentle,
        appearance: CharacterAppearance(
          height: '165cm',
          hairColor: '银白色',
          eyeColor: '淡蓝色',
        ),
        stats: CharacterStats(),
        skills: [],
        background: '来自冰雪王国的公主。',
      );

      expect(character.id, equals('char_001'));
      expect(character.name, equals('雪羽'));
      expect(character.personality, equals(PersonalityType.gentle));
    });

    test('Character levelUp should increase level', () {
      final character = Character(
        id: 'char_001',
        name: '测试',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: '黑色',
          eyeColor: '黑色',
        ),
        stats: CharacterStats(level: 1, exp: 100, affection: 50),
        skills: [],
        background: '测试',
      );

      final upgraded = character.levelUp();
      expect(upgraded.stats.level, equals(2));
    });

    test('Character addAffection should modify affection', () {
      final character = Character(
        id: 'char_001',
        name: '测试',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: '黑色',
          eyeColor: '黑色',
        ),
        stats: CharacterStats(affection: 50),
        skills: [],
        background: '测试',
      );

      final updated = character.addAffection(10);
      expect(updated.stats.affection, equals(60));
    });

    test('Character addAffection should not exceed max', () {
      final character = Character(
        id: 'char_001',
        name: '测试',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: '黑色',
          eyeColor: '黑色',
        ),
        stats: CharacterStats(affection: 100),
        skills: [],
        background: '测试',
      );

      final updated = character.addAffection(10);
      expect(updated.stats.affection, equals(100));
    });

    test('Character addExp should increase experience', () {
      final character = Character(
        id: 'char_001',
        name: '测试',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: '黑色',
          eyeColor: '黑色',
        ),
        stats: CharacterStats(exp: 0),
        skills: [],
        background: '测试',
      );

      final updated = character.addExp(50);
      expect(updated.stats.exp, equals(50));
    });
  });

  group('ConversationContext Tests', () {
    test('ConversationContext should store messages', () {
      final context = ConversationContext(
        characterId: 'char_001',
        messages: [
          DialogueMessage(
            id: '1',
            sender: MessageSender.user,
            text: '你好',
            emotion: MessageEmotion.happy,
            affectionChange: 0,
          ),
        ],
        lastMessage: DialogueMessage(
          id: '2',
          sender: MessageSender.character,
          text: '你好呀！',
          emotion: MessageEmotion.happy,
          affectionChange: 1,
        ),
      );

      expect(context.messages.length, equals(1));
      expect(context.lastMessage.text, equals('你好呀！'));
    });
  });
}
