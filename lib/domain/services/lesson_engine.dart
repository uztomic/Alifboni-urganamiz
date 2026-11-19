import 'dart:math';

import 'dart:ui' show Color;

import '../../core/l10n/strings.dart';
import '../../core/utils/translit.dart';
import '../../core/voice_lines.dart';
import '../entities/alphabet.dart';
import '../entities/lesson.dart';
import '../entities/voice_lang.dart';
import 'text_units.dart';

enum OptionStyle { letter, picture, word }

class Option {
  const Option({required this.label, this.emoji = '', this.swatch, this.say});
  final String label;
  final String emoji;
  final Color? swatch;

  /// Variant bosilganda o'qiladigan matn (bo'lsa).
  final Line? say;
}

/// Savolning yuqori qismidagi asosiy ko'rinish.
class QuestionHero {
  const QuestionHero({this.letter, this.emoji, this.swatch, this.text, this.arrowFrom});

  /// Katta harf (masalan "Xuddi shunday harfni top" uchun).
  final String? letter;
  final String? emoji;
  final Color? swatch;

  /// O'qiladigan so'z yoki gap.
  final String? text;

  /// "A → ?" ko'rinishi uchun.
  final String? arrowFrom;
}

sealed class Question {
  const Question({required this.text, required this.voice});

  /// Ekrandagi topshiriq matni.
  final String text;

  /// Savol ochilganda o'qiladigan ovoz (ketma-ket).
  final List<Line> voice;
}

class ChoiceQuestion extends Question {
  const ChoiceQuestion({
    required super.text,
    required super.voice,
    required this.options,
    required this.correct,
    required this.style,
    this.hero,
    this.onCorrect,
  });

  final List<Option> options;
  final int correct;
  final OptionStyle style;
  final QuestionHero? hero;

  /// To'g'ri javobdan keyin o'qiladigan ovoz (so'z, to'liq gap).
  final Line? onCorrect;
}

/// Bo'laklardan (harf yoki bo'g'in) so'z yig'ish.
class BuildQuestion extends Question {
  const BuildQuestion({
    required super.text,
    required super.voice,
    required this.target,
    required this.pool,
    required this.emoji,
    required this.word,
    required this.syllables,
  });

  final List<String> target;
  final List<String> pool;
  final String emoji;
  final Line word;
  final bool syllables;
}

class TraceQuestion extends Question {
  const TraceQuestion({required super.text, required super.voice, required this.letter, required this.glyph});
  final Letter letter;
  final String glyph;
}

/// Tanishuv kartochkasi: harf + so'z, faqat tinglash va "Keyingi".
class IntroQuestion extends Question {
  const IntroQuestion({required super.text, required super.voice, required this.letter});
  final Letter letter;
}

/// Tanlangan alifbo va dars turi bo'yicha savollar tuzadi.
class LessonEngine {
  LessonEngine({
    required this.alphabet,
    required this.s,
    required this.hasVoice,
    this.sentences = const [],
    this.emojiFor = _noEmoji,
    Random? random,
  }) : r = random ?? Random();

  final Alphabet alphabet;
  final S s;
  final Random r;

  /// Shu matn uchun tabiiy ovoz bormi (ovoz servisidan uzatiladi).
  final bool Function(String text, VoiceLang lang) hasVoice;

  /// "Gapni to'ldir" mashqlari (kontent qatlamidan uzatiladi).
  final List<SentenceItem> sentences;

  /// So'z uchun rasm (emoji) topuvchi.
  final String Function(String uzWord) emojiFor;

  static String _noEmoji(String _) => '';

  bool get _uz => alphabet.id.isUzbek;
  VoiceLang get _lang => alphabet.voiceLang;
  List<Letter> get _letters => alphabet.realLetters;

  /// Ovozli shablon ilovada bo'lsa — o'sha, bo'lmasa — zaxira gaplar.
  List<Line> _voiceOr(Line primary, List<Line> fallback) =>
      hasVoice(primary.$1, primary.$2) ? [primary] : fallback;

  Line _letterSay(Letter l) => (l.say, l.sayLang);

  /// Letter nomining ingliz TTS uchun ko'rinishi.
  String _spoken(Letter l) => alphabet.id == ScriptId.en ? l.say : l.upper;

  List<T> _pick<T>(List<T> from, int n, {T? exclude, bool Function(T)? where}) {
    final pool = from.where((e) => e != exclude && (where == null || where(e))).toList()..shuffle(r);
    return pool.take(n).toList();
  }

  ChoiceQuestion _letterChoice({
    required Letter target,
    required List<Letter> distractors,
    required String text,
    required List<Line> voice,
    QuestionHero? hero,
    bool lower = false,
    Line? onCorrect,
  }) {
    final opts = [target, ...distractors]..shuffle(r);
    return ChoiceQuestion(
      text: text,
      voice: voice,
      style: OptionStyle.letter,
      hero: hero,
      onCorrect: onCorrect,
      correct: opts.indexOf(target),
      options: [
        for (final l in opts) Option(label: lower ? l.lower : l.upper, say: _letterSay(l)),
      ],
    );
  }

  List<Question> build(LessonType type, {int introOffset = 0}) {
    switch (type) {
      case LessonType.intro:
        return _intro(introOffset);
      case LessonType.find:
        return List.generate(8, (i) => _find(i.isEven));
      case LessonType.vowels:
        return List.generate(8, (_) => _vowelQ(true));
      case LessonType.consonants:
        return List.generate(8, (_) => _vowelQ(false));
      case LessonType.bigSmall:
        return List.generate(8, (i) => _caseQ(i.isEven));
      case LessonType.order:
        return _orderQs();
      case LessonType.firstLetter:
        return _firstLetterQs();
      case LessonType.syllables:
        return _uz ? _syllableQs() : _listenPictureQs();
      case LessonType.buildWord:
        return _buildWordQs();
      case LessonType.read:
        return _readQs();
      case LessonType.sentence:
        return _uz ? _sentenceQs() : _listenPictureQs();
      case LessonType.write:
        return _writeQs();
    }
  }

  // --- 1. Tanishuv ---
  List<Question> _intro(int offset) {
    final all = _letters;
    final start = (offset * 6) % all.length;
    final group = [for (var i = 0; i < 6; i++) all[(start + i) % all.length]];
    final cards = <Question>[
      for (final l in group)
        IntroQuestion(
          text: s.t('tapToHear'),
          letter: l,
          voice: [_letterSay(l), if (l.mainWord != null) (l.mainWord!.say, l.mainWord!.lang)],
        ),
    ];
    final checks = _pick(group, 2);
    for (final t in checks) {
      cards.add(_findQuestion(t, _pick(group, 3, exclude: t), same: false));
    }
    return cards;
  }

  // --- 2. Harfni top ---
  Question _find(bool same) {
    final t = _letters[r.nextInt(_letters.length)];
    return _findQuestion(t, _pick(_letters, 3, exclude: t), same: same);
  }

  ChoiceQuestion _findQuestion(Letter t, List<Letter> distractors, {required bool same}) {
    final key = t.uzKey;
    List<Line> voice;
    if (_uz && key != null) {
      voice = same
          ? _voiceOr(uz('Bu — «$key» harfi. Xuddi shunday harfni top!'), [_letterSay(t)])
          : _voiceOr(uz('Qaysi biri «$key» harfi?'), [_letterSay(t)]);
    } else if (_lang == VoiceLang.ru) {
      voice = [ru('Найди букву ${t.upper}')];
    } else if (_lang == VoiceLang.en) {
      voice = [en('Find the letter ${_spoken(t)}')];
    } else {
      voice = [_letterSay(t)];
    }
    return _letterChoice(
      target: t,
      distractors: distractors,
      text: same ? s.t('q_same') : s.t('q_find', [t.upper]),
      voice: voice,
      hero: same ? QuestionHero(letter: t.upper) : null,
    );
  }

  // --- 3/4. Unli va undosh ---
  Question _vowelQ(bool vowel) {
    final right = vowel ? alphabet.vowels : alphabet.consonants;
    final wrong = vowel ? alphabet.consonants : alphabet.vowels;
    final t = right[r.nextInt(right.length)];
    final List<Line> voice = _uz
        ? [uz(vowel ? 'Qaysi biri unli harf?' : 'Qaysi biri undosh harf?')]
        : _lang == VoiceLang.ru
            ? [ru(vowel ? 'Какая буква гласная?' : 'Какая буква согласная?')]
            : [en(vowel ? 'Which one is a vowel?' : 'Which one is a consonant?')];
    return _letterChoice(
      target: t,
      distractors: _pick(wrong, 3),
      text: s.t(vowel ? 'q_vowel' : 'q_consonant'),
      voice: voice,
      onCorrect: _letterSay(t),
    );
  }

  // --- 5. Katta va kichik ---
  Question _caseQ(bool findLower) {
    final cands = _letters.where((l) => l.upper != l.lower).toList();
    final t = cands[r.nextInt(cands.length)];
    final key = t.uzKey;
    List<Line> voice;
    if (_uz && key != null) {
      voice = findLower
          ? _voiceOr(uz('«$key» harfining kichigini top!'), [_letterSay(t)])
          : _voiceOr(uz('«${key.toLowerCase()}» harfining kattasini top!'), [_letterSay(t)]);
    } else if (_lang == VoiceLang.ru) {
      voice = [ru(findLower ? 'Найди маленькую букву ${t.upper}' : 'Найди большую букву ${t.upper}')];
    } else {
      voice = [en(findLower ? 'Find the small letter ${_spoken(t)}' : 'Find the capital letter ${_spoken(t)}')];
    }
    final distractors = _pick(cands, 3, exclude: t);
    return _letterChoice(
      target: t,
      distractors: distractors,
      text: findLower ? s.t('q_lower', [t.upper]) : s.t('q_upper', [t.lower]),
      voice: voice,
      hero: QuestionHero(letter: findLower ? t.upper : t.lower),
      lower: findLower,
    );
  }

  // --- 6. Alifbo tartibi ---
  List<Question> _orderQs() {
    final seq = _letters;
    final idxs = List.generate(seq.length - 1, (i) => i)..shuffle(r);
    return [
      for (final i in idxs.take(8))
        () {
          final from = seq[i];
          final t = seq[i + 1];
          final key = from.uzKey;
          List<Line> voice;
          if (_uz && key != null) {
            voice = _voiceOr(uz('«$key» harfidan keyin qaysi harf keladi?'), [_letterSay(from)]);
          } else if (_lang == VoiceLang.ru) {
            voice = [ru('Какая буква идёт после ${from.upper}?')];
          } else {
            voice = [en('Which letter comes after ${_spoken(from)}?')];
          }
          return _letterChoice(
            target: t,
            distractors: _pick(seq, 3, exclude: t, where: (l) => l != from),
            text: s.t('q_next', [from.upper]),
            voice: voice,
            hero: QuestionHero(arrowFrom: from.upper),
            onCorrect: _letterSay(t),
          );
        }(),
    ];
  }

  /// Shu harf bilan boshlanadigan so'zlar (birinchi birlik — aynan shu harf).
  List<(Letter, Word)> _startWords() {
    final out = <(Letter, Word)>[];
    for (final l in _letters) {
      for (final w in l.words) {
        final units = splitUnits(w.text, alphabet);
        if (units.isNotEmpty && units.first.toLowerCase() == l.lower.toLowerCase()) out.add((l, w));
      }
    }
    return out;
  }

  // --- 7. Birinchi harf ---
  List<Question> _firstLetterQs() {
    final pairs = _startWords()..shuffle(r);
    final usedLetters = <Letter>{};
    final out = <Question>[];
    for (final (l, w) in pairs) {
      if (usedLetters.contains(l)) continue;
      usedLetters.add(l);
      List<Line> voice;
      if (_uz) {
        voice = _voiceOr(uz('«${w.say}» soʻzi qaysi harf bilan boshlanadi?'), [(w.say, w.lang)]);
      } else if (_lang == VoiceLang.ru) {
        voice = [ru('С какой буквы начинается слово ${w.say}?')];
      } else {
        voice = [en('What letter does ${w.say} start with?')];
      }
      out.add(_letterChoice(
        target: l,
        distractors: _pick(_letters, 3, exclude: l),
        text: s.t('q_first', [w.text]),
        voice: voice,
        hero: QuestionHero(emoji: w.emoji),
        onCorrect: (w.say, w.lang),
      ));
      if (out.length == 8) break;
    }
    return out;
  }

  // --- 8. Bo'g'inlar ---
  List<Question> _syllableQs() {
    final words = <Word>[
      for (final l in _letters)
        for (final w in l.words)
          if (w.syllables != null && w.syllables!.contains('-')) w,
    ]..shuffle(r);
    final seen = <String>{};
    final allSyl = {for (final w in words) ...w.syllables!.split('-')}.toList();
    final out = <Question>[];
    for (final w in words) {
      if (!seen.add(w.say)) continue;
      final target = w.syllables!.split('-');
      final extra = _pick(allSyl, 1, where: (x) => !target.contains(x));
      out.add(BuildQuestion(
        text: s.t('q_syllables'),
        voice: [(w.say, w.lang)],
        target: target,
        pool: [...target, ...extra]..shuffle(r),
        emoji: w.emoji,
        word: (w.say, w.lang),
        syllables: true,
      ));
      if (out.length == 8) break;
    }
    return out;
  }

  // --- 9. So'z yig'ish ---
  List<Question> _buildWordQs() {
    final cands = <Word>[
      for (final l in _letters)
        for (final w in l.words)
          if (isPlainWord(w.text, alphabet) && splitUnits(w.text, alphabet).length <= 6) w,
    ];
    // Avval qisqa so'zlar
    cands.shuffle(r);
    cands.sort((a, b) => splitUnits(a.text, alphabet).length.compareTo(splitUnits(b.text, alphabet).length));
    final seen = <String>{};
    final chosen = <Word>[];
    for (final w in cands) {
      if (seen.add(w.text.toLowerCase())) chosen.add(w);
      if (chosen.length == 8) break;
    }
    chosen.shuffle(r);
    return [
      for (final w in chosen)
        () {
          final target = splitUnits(w.text, alphabet).map((u) => u.toLowerCase()).toList();
          final extra = _pick(_letters, 2, where: (l) => !target.contains(l.lower)).map((l) => l.lower);
          return BuildQuestion(
            text: s.t('q_build'),
            voice: [(w.say, w.lang)],
            target: target,
            pool: [...target, ...extra]..shuffle(r),
            emoji: w.emoji,
            word: (w.say, w.lang),
            syllables: false,
          );
        }(),
    ];
  }

  List<Word> get _allWords {
    final seen = <String>{};
    return [
      for (final l in _letters)
        for (final w in l.words)
          if (seen.add(w.emoji)) w,
    ];
  }

  // --- 10. O'qish ---
  List<Question> _readQs() {
    final words = _allWords..shuffle(r);
    return [
      for (final w in words.take(8))
        () {
          final others = _pick(_allWords, 2, where: (x) => x.emoji != w.emoji);
          final opts = [w, ...others]..shuffle(r);
          return ChoiceQuestion(
            text: s.t('q_read'),
            voice: const [],
            style: OptionStyle.picture,
            hero: QuestionHero(text: w.text),
            correct: opts.indexOf(w),
            onCorrect: (w.say, w.lang),
            options: [for (final o in opts) Option(label: '', emoji: o.emoji)],
          );
        }(),
    ];
  }

  // --- Tingla va rasmni top (rus/ingliz uchun) ---
  List<Question> _listenPictureQs() {
    final words = _allWords..shuffle(r);
    return [
      for (final w in words.take(8))
        () {
          final others = _pick(_allWords, 2, where: (x) => x.emoji != w.emoji);
          final opts = [w, ...others]..shuffle(r);
          return ChoiceQuestion(
            text: s.t('q_listen'),
            voice: [(w.say, w.lang)],
            style: OptionStyle.picture,
            correct: opts.indexOf(w),
            onCorrect: (w.say, w.lang),
            options: [for (final o in opts) Option(label: '', emoji: o.emoji)],
          );
        }(),
    ];
  }

  String _uzScript(String latin) => switch (alphabet.id) {
        ScriptId.uzCyrl => latinToCyrillic(latin),
        ScriptId.uzNew => latinToNewLatin(latin),
        _ => latin,
      };

  // --- 11. Gap ---
  List<Question> _sentenceQs() {
    final items = [...sentences]..shuffle(r);
    return [
      for (final it in items.take(8))
        () {
          final opts = [it.answer, ...it.wrong]..shuffle(r);
          return ChoiceQuestion(
            text: s.t('q_sentence'),
            voice: [it.prompt],
            style: OptionStyle.word,
            hero: QuestionHero(text: _uzScript(it.display)),
            correct: opts.indexOf(it.answer),
            onCorrect: it.full,
            options: [
              for (final o in opts) Option(label: _uzScript(o), emoji: emojiFor(o), say: uz(o)),
            ],
          );
        }(),
    ];
  }

  // --- 12. Yozish ---
  List<Question> _writeQs() {
    final picks = _pick(_letters, 4);
    return [
      for (final l in picks)
        TraceQuestion(
          text: s.t('q_trace'),
          voice: [_letterSay(l), if (_uz) Lines.traceLook],
          letter: l,
          glyph: l.upper,
        ),
    ];
  }
}
