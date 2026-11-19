import 'audio/audio_service.dart';
import 'l10n/strings.dart';


Line uz(String t) => (t, VoiceLang.uz);
Line ru(String t) => (t, VoiceLang.ru);
Line en(String t) => (t, VoiceLang.en);

/// Maqtov va dalda gaplari — interfeys tilida (tabiiy ovoz).
class Praise {
  static final _uzGood = [
    uz('Barakalla!'),
    uz('Ofarin!'),
    uz('Ajoyib!'),
    uz('Zoʻr!'),
    uz('Juda yaxshi!'),
    uz('Toʻgʻri! Barakalla!'),
    uz('Zoʻr, toʻppa-toʻgʻri!'),
    uz('Voy, qanday aqlli!'),
  ];
  static final _uzWrong = [
    uz('Yana bir bor qara. Sen uddalaysan!'),
    uz('Shoshilmay, yana bir bor qara.'),
    uz('Yana urinib koʻr'),
  ];
  static final _ruGood = [
    ru('Отлично!'),
    ru('Верно! Молодец!'),
    ru('Очень хорошо!'),
    ru('Очень красиво!'),
  ];
  static final _ruWrong = [ru('Посмотри ещё раз. У тебя получится!')];
  static final _enGood = [
    en('Great job!'),
    en('Well done!'),
    en('Awesome!'),
    en('Very good!'),
    en('Right! Well done!'),
    en('Wow, so clever!'),
  ];
  static final _enWrong = [en('Try again'), en('Nice try!')];

  static int _i = 0;

  static Line good(UiLang l) {
    final list = switch (l) {
      UiLang.ru => _ruGood,
      UiLang.en => _enGood,
      _ => _uzGood,
    };
    return list[(_i++) % list.length];
  }

  static Line wrong(UiLang l) {
    final list = switch (l) {
      UiLang.ru => _ruWrong,
      UiLang.en => _enWrong,
      _ => _uzWrong,
    };
    return list[(_i++) % list.length];
  }

  static Line lessonDone(UiLang l) => switch (l) {
        UiLang.ru => ru('Молодец! Завтра тебя ждёт новый путь.'),
        UiLang.en => en('Lesson complete'),
        _ => uz('Dars tugadi'),
      };

  static Line allPairs(UiLang l) => switch (l) {
        UiLang.ru => ru('Все пары найдены!'),
        UiLang.en => en('All pairs found!'),
        _ => uz('Hamma juftlar topildi!'),
      };

  static Line listenAndFind(UiLang l) => switch (l) {
        UiLang.ru => ru('Слушай и найди'),
        UiLang.en => en('Listen and find!'),
        _ => uz('Tingla va top!'),
      };
}

/// Ilova bo'ylab ishlatiladigan alohida ovozli gaplar.
abstract final class Lines {
  static final greeting = uz('Keling, tanishamiz!');
  static final letsStart = uz('Qani, boshladik!');
  static final traceMore = uz('Yana ozgina! Harfning hamma joyini chiz.');
  static final traceOut = uz('Chiziq harfdan chiqib ketdi. Iz boʻylab chiz.');
  static final traceHow = uz('Harfni yuqoridan pastga qarab yozamiz.');
  static final traceLook = uz('Harfning shakliga diqqat bilan qara.');
  static final popRight = uz('Toʻgʻri javobli sharni yor!');
  static final trainGo = uz('Ofarin! Poyezd yoʻlga chiqdi!');
  static final memoryIntro = uz('Ikkita bir xil rasmni och!');
  static final memoryMiss = uz('Har xil ekan. Eslab qol va yana och!');
  static final memoryHit = uz('Juftini topding!');
  static final orderIntro = uz('Endi qaysi harf keyin kelishini topamiz.');
  static final taleEnd = uz('Ertak tugadi! Shirin tushlar.');
  static final goodEffort = uz('Yaxshi harakat!');
}
