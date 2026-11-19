import 'dart:math';

import 'package:alifbo/core/audio/voice_key.dart';
import 'package:alifbo/core/l10n/strings.dart';
import 'package:alifbo/core/utils/translit.dart';
import 'package:alifbo/data/content/alphabets.dart';
import 'package:alifbo/data/content/emoji_index.dart';
import 'package:alifbo/data/content/lessons.dart';
import 'package:alifbo/data/content/quizzes.dart';
import 'package:alifbo/domain/entities/alphabet.dart';
import 'package:alifbo/domain/services/lesson_engine.dart';
import 'package:alifbo/domain/services/quiz_builder.dart';
import 'package:alifbo/domain/services/text_units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('voiceKey — Ziyrak bilan bir xil FNV-1a xesh', () {
    expect(voiceKey('Qaysi biri «A» harfi?'), 'f9427b07b9b2e2ca');
    expect(voiceKey('Barakalla!'), 'cb36b0ea3166e27f');
    expect(voiceKey('oʻrdak'), 'f8bfe2f529b7e717');
    expect(voiceKey('A'), 'af63fc4c860222ec');
  });

  test('lotin → kirill', () {
    expect(latinToCyrillic('oʻrdak'), 'ўрдак');
    expect(latinToCyrillic('Shamol'), 'Шамол');
    expect(latinToCyrillic('yulduz'), 'юлдуз');
    expect(latinToCyrillic('echki'), 'эчки');
    expect(latinToCyrillic('gʻisht'), 'ғишт');
    expect(latinToCyrillic('choynak'), 'чойнак');
  });

  test('lotin → yangi lotin (2027)', () {
    expect(latinToNewLatin('oʻrdak'), 'ördak');
    expect(latinToNewLatin('Shamol'), 'Şamol');
    expect(latinToNewLatin('choynak'), 'çoynak');
    expect(latinToNewLatin('gʻisht'), 'ğişt');
  });

  test("so'zni harflarga bo'lish", () {
    expect(splitUnits('shapka', uzLatin), ['sh', 'a', 'p', 'k', 'a']);
    expect(splitUnits('oʻrdak', uzLatin), ['oʻ', 'r', 'd', 'a', 'k']);
    expect(splitUnits('bodring', uzLatin), ['b', 'o', 'd', 'r', 'i', 'n', 'g']);
  });

  test("alifbolar to'g'ri tuzilgan", () {
    expect(uzLatin.realLetters.length, 28);
    expect(uzNew.letters.map((l) => l.upper), containsAll(['Ö', 'Ğ', 'Ş', 'Ç']));
    expect(uzCyrl.letters.length, 35);
    expect(russian.letters.length, 33);
    expect(english.letters.length, 26);
    for (final a in allAlphabets) {
      expect(a.vowels.length, greaterThanOrEqualTo(3), reason: a.id.name);
      expect(a.consonants.length, greaterThanOrEqualTo(3), reason: a.id.name);
    }
  });

  test('har bir alifbo va dars turi uchun savollar tuziladi', () {
    for (final a in allAlphabets) {
      for (final type in LessonType.values) {
        for (var seed = 0; seed < 5; seed++) {
          final engine = LessonEngine(
            alphabet: a,
            s: S(UiLang.uz),
            hasVoice: (_, __) => seed.isEven,
            sentences: sentences,
            emojiFor: emojiForWord,
            random: Random(seed),
          );
          final qs = engine.build(type, introOffset: seed);
          expect(qs, isNotEmpty, reason: '${a.id.name}/${type.name}');
          for (final q in qs) {
            if (q is ChoiceQuestion) {
              expect(q.correct, inInclusiveRange(0, q.options.length - 1), reason: '${a.id.name}/${type.name}');
              final labels = q.options.map((o) => '${o.label}|${o.emoji}').toSet();
              expect(labels.length, q.options.length, reason: 'takroriy variant: ${a.id.name}/${type.name} ${q.text}');
            }
            if (q is BuildQuestion) {
              for (final t in q.target) {
                expect(q.pool.map((p) => p.toLowerCase()), contains(t.toLowerCase()));
              }
            }
          }
        }
      }
    }
  });

  test('Bilimdon savollari', () {
    for (final t in quizTopics) {
      final qs = buildQuiz(t, s: S(UiLang.uz), emojiFor: emojiForWord, random: Random(1));
      expect(qs, isNotEmpty);
      for (final q in qs) {
        final c = q as ChoiceQuestion;
        expect(c.options.map((o) => o.label).toSet().length, c.options.length);
      }
    }
  });

  test('barcha matn kalitlari 3 tilda', () {
    for (final l in UiLang.values) {
      final s = S(l);
      expect(s.t('appName'), isNot('appName'));
      expect(s.t('q_find', ['A']), contains('A'));
    }
  });
}
