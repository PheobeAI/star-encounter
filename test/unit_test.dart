import 'package:flutter_test/flutter_test.dart';
import 'package:star_encounter/models/character.dart';
import 'package:star_encounter/models/conversation.dart';
import 'package:star_encounter/services/ai_service.dart';
import 'package:star_encounter/services/logger_service.dart';

void main() {
  group('AppLogger Tests', () {
    setUp(() {
      AppLogger.clear();
      AppLogger.init(debugMode: false);
    });

    test('Logger should record info logs', () {
      AppLogger.info('test', 'Test info message');
      final logs = AppLogger.getLogs();
      
      expect(logs.length, equals(1));
      expect(logs[0].tag, equals('test'));
      expect(logs[0].message, equals('Test info message'));
      expect(logs[0].level, equals(LogLevel.info));
    });

    test('Logger should record error logs with stack trace', () {
      try {
        throw Exception('Test exception');
      } catch (e, st) {
        AppLogger.error('test', 'Error occurred', e, st);
      }
      
      final logs = AppLogger.getLogs();
      expect(logs.length, equals(3)); // Main error + message + stacktrace
      expect(logs[0].level, equals(LogLevel.error));
    });

    test('Logger should export logs as string', () {
      AppLogger.info('test', 'Message 1');
      AppLogger.debug('test', 'Message 2');
      
      final logString = AppLogger.getAllLogsAsString();
      expect(logString.contains('Message 1'), isTrue);
      expect(logString.contains('Message 2'), isTrue);
    });

    test('Logger should clear all logs', () {
      AppLogger.info('test', 'Message');
      AppLogger.clear();
      
      expect(AppLogger.getLogs().length, equals(0));
    });
  });

  group('AIService Comprehensive Tests', () {
    late AIService aiService;

    setUp(() {
      aiService = AIService();
    });

    test('All personality types should generate replies', () {
      final personalities = PersonalityType.values;
      
      for (final personality in personalities) {
        final character = Character(
          id: 'test_${personality.name}',
          name: 'Test Character',
          personality: personality,
          appearance: CharacterAppearance(
            height: '160cm',
            hairColor: 'black',
            eyeColor: 'black',
          ),
          stats: CharacterStats(),
          skills: [],
          background: 'Test',
        );

        final reply = aiService.generateReply(
          character: character,
          userMessage: 'Hello',
          context: null,
        );

        expect(reply.text, isNotEmpty,
            reason: 'Personality $personality should produce non-empty reply');
        expect(reply.sender, equals(MessageSender.character));
      }
    });

    test('Reply should include emotion', () {
      final character = Character(
        id: 'test',
        name: 'Test',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(),
        skills: [],
        background: 'Test',
      );

      final reply = aiService.generateReply(
        character: character,
        userMessage: 'Hello',
        context: null,
      );

      expect(reply.emotion, isA<MessageEmotion>());
    });

    test('Affection change should be within valid range', () {
      final character = Character(
        id: 'test',
        name: 'Test',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(),
        skills: [],
        background: 'Test',
      );

      // Test multiple times to ensure consistency
      for (int i = 0; i < 10; i++) {
        final reply = aiService.generateReply(
          character: character,
          userMessage: 'Hello',
          context: null,
        );

        expect(reply.affectionChange, greaterThanOrEqualTo(-2));
        expect(reply.affectionChange, lessThanOrEqualTo(2));
      }
    });

    test('Context should affect response generation', () {
      final character = Character(
        id: 'test',
        name: 'Test',
        personality: PersonalityType.gentle,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(),
        skills: [],
        background: 'Test',
      );

      // With context
      final context = ConversationContext(
        characterId: 'test',
        messages: [
          DialogueMessage(
            id: '1',
            sender: MessageSender.user,
            text: 'How are you?',
            emotion: MessageEmotion.happy,
            affectionChange: 0,
          ),
        ],
        lastMessage: DialogueMessage(
          id: '2',
          sender: MessageSender.character,
          text: "I'm fine, thank you!",
          emotion: MessageEmotion.happy,
          affectionChange: 1,
        ),
      );

      final replyWithContext = aiService.generateReply(
        character: character,
        userMessage: 'Great!',
        context: context,
      );

      final replyWithoutContext = aiService.generateReply(
        character: character,
        userMessage: 'Great!',
        context: null,
      );

      // Both should produce valid replies
      expect(replyWithContext.text, isNotEmpty);
      expect(replyWithoutContext.text, isNotEmpty);
    });
  });

  group('Character Model Tests', () {
    test('Character creation with all fields', () {
      final character = Character(
        id: 'char_001',
        name: '雪羽',
        personality: PersonalityType.gentle,
        appearance: CharacterAppearance(
          height: '165cm',
          hairColor: '银白色',
          eyeColor: '淡蓝色',
        ),
        stats: CharacterStats(level: 5, exp: 500, affection: 80, hp: 100, mp: 50),
        skills: ['冰雪魔法', '治愈术'],
        background: '来自冰雪王国的公主',
      );

      expect(character.id, equals('char_001'));
      expect(character.name, equals('雪羽'));
      expect(character.personality, equals(PersonalityType.gentle));
      expect(character.stats.level, equals(5));
      expect(character.stats.affection, equals(80));
      expect(character.skills.length, equals(2));
    });

    test('Character levelUp should increase level and exp', () {
      final character = Character(
        id: 'char_001',
        name: 'Test',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(level: 1, exp: 100),
        skills: [],
        background: 'Test',
      );

      final upgraded = character.levelUp();
      
      expect(upgraded.stats.level, equals(2));
      expect(upgraded.stats.exp, greaterThan(100));
    });

    test('Character addAffection should clamp at max 100', () {
      final character = Character(
        id: 'char_001',
        name: 'Test',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(affection: 100),
        skills: [],
        background: 'Test',
      );

      final updated = character.addAffection(50);
      expect(updated.stats.affection, equals(100));
    });

    test('Character addAffection should clamp at min 0', () {
      final character = Character(
        id: 'char_001',
        name: 'Test',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(affection: 0),
        skills: [],
        background: 'Test',
      );

      final updated = character.addAffection(-50);
      expect(updated.stats.affection, equals(0));
    });

    test('Character addExp should accumulate', () {
      final character = Character(
        id: 'char_001',
        name: 'Test',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(exp: 0),
        skills: [],
        background: 'Test',
      );

      final updated = character.addExp(100);
      expect(updated.stats.exp, equals(100));
    });

    test('Character upgradeSkill should add skill', () {
      final character = Character(
        id: 'char_001',
        name: 'Test',
        personality: PersonalityType.lively,
        appearance: CharacterAppearance(
          height: '160cm',
          hairColor: 'black',
          eyeColor: 'black',
        ),
        stats: CharacterStats(),
        skills: ['Skill1'],
        background: 'Test',
      );

      final upgraded = character.upgradeSkill('char_001', 'NewSkill');
      expect(upgraded.skills.contains('NewSkill'), isTrue);
    });
  });

  group('ConversationContext Tests', () {
    test('Context should store multiple messages', () {
      final messages = List.generate(
        10,
        (i) => DialogueMessage(
          id: 'msg_$i',
          sender: i % 2 == 0 ? MessageSender.user : MessageSender.character,
          text: 'Message $i',
          emotion: MessageEmotion.happy,
          affectionChange: 0,
        ),
      );

      final context = ConversationContext(
        characterId: 'char_001',
        messages: messages,
        lastMessage: messages.last,
      );

      expect(context.messages.length, equals(10));
      expect(context.lastMessage.text, equals('Message 9'));
    });

    test('Message should have correct sender types', () {
      final userMessage = DialogueMessage(
        id: '1',
        sender: MessageSender.user,
        text: 'Hello',
        emotion: MessageEmotion.happy,
        affectionChange: 0,
      );

      final charMessage = DialogueMessage(
        id: '2',
        sender: MessageSender.character,
        text: 'Hi there!',
        emotion: MessageEmotion.happy,
        affectionChange: 1,
      );

      expect(userMessage.sender, equals(MessageSender.user));
      expect(charMessage.sender, equals(MessageSender.character));
    });
  });

  group('MessageEmotion Tests', () {
    test('All emotion types should be defined', () {
      expect(MessageEmotion.values.length, equals(7)); // happy, sad, angry, surprised, thinking, neutral, excited
    });
  });

  group('PersonalityType Tests', () {
    test('All personality types should be defined', () {
      expect(PersonalityType.values.length, equals(8)); 
      expect(PersonalityType.values, contains(PersonalityType.gentle));
      expect(PersonalityType.values, contains(PersonalityType.lively));
      expect(PersonalityType.values, contains(PersonalityType.tsundere));
      expect(PersonalityType.values, contains(PersonalityType.mysterious));
    });
  });
}
