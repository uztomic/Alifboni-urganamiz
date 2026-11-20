import 'package:flutter/widgets.dart';

import '../utils/translit.dart';

/// Interfeys tillari.
enum UiLang {
  uz('uz', "Oʻzbekcha", Locale('uz')),
  uzc('uzc', 'Ўзбекча', Locale('uz')),
  ru('ru', 'Русский', Locale('ru')),
  en('en', 'English', Locale('en'));

  const UiLang(this.code, this.selfName, this.locale);
  final String code;
  final String selfName;
  final Locale locale;

  static UiLang fromCode(String? c) =>
      UiLang.values.firstWhere((l) => l.code == c, orElse: () => UiLang.uz);
}

/// Ilova matnlari. Har bir kalit uchun: [o'zbek lotin, rus, ingliz].
/// O'zbek kirill matni lotindan avtomatik o'giriladi.
/// O'rinbosarlar: %1, %2 ...
class S {
  S(this.lang);
  final UiLang lang;

  static final Map<UiLang, Map<String, String>> _cache = {};

  String t(String key, [List<Object?> args = const []]) {
    final row = _strings[key];
    if (row == null) return key;
    String v;
    switch (lang) {
      case UiLang.uz:
        v = display(row[0]);
      case UiLang.uzc:
        final c = _cache.putIfAbsent(lang, () => {});
        v = c.putIfAbsent(key, () => latinToCyrillic(row[0]));
      case UiLang.ru:
        v = display(row[1]);
      case UiLang.en:
        v = display(row[2]);
    }
    for (var i = 0; i < args.length; i++) {
      v = v.replaceAll('%${i + 1}', '${args[i]}');
    }
    return v;
  }

  /// O'zbekcha matnni (masalan so'z yoki gap) joriy interfeys yozuviga
  /// moslab qaytaradi: kirill interfeysda — kirillda.
  String uzText(String latin) =>
      lang == UiLang.uzc ? latinToCyrillic(latin) : display(latin);

  /// Ekranda ko'rsatish uchun: Nunito shriftida ʻ (U+02BB) belgisi juda
  /// keng chiziladi ("O ʻzbek"), shuning uchun ingichka ‘ bilan almashtiramiz.
  /// Ovoz kalitlari o'zgarmaydi — bu faqat ko'rinish.
  static String display(String latin) => latin.replaceAll('ʻ', '‘');

  bool get isUzbek => lang == UiLang.uz || lang == UiLang.uzc;
}

const Map<String, List<String>> _strings = {
  // --- Umumiy ---
  'appName': ["Alifboni oʻrganamiz", 'Учим алфавит', "Let's Learn the Alphabet"],
  'tagline': ["Eshit · Koʻr · Yoz", 'Слушай · Смотри · Пиши', 'Listen · Look · Write'],
  'start': ['Boshlash', 'Начать', 'Start'],
  'continue': ['Davom etish', 'Продолжить', 'Continue'],
  'next': ['Keyingi', 'Дальше', 'Next'],
  'back': ['Orqaga', 'Назад', 'Back'],
  'again': ['Yana bir bor', 'Ещё раз', 'Play again'],
  'done': ['Tayyor', 'Готово', 'Done'],
  'close': ['Yopish', 'Закрыть', 'Close'],
  'cancel': ['Bekor qilish', 'Отмена', 'Cancel'],
  'yes': ['Ha', 'Да', 'Yes'],
  'no': ["Yoʻq", 'Нет', 'No'],
  'listen': ['Tinglash', 'Слушать', 'Listen'],
  'stars': ['yulduz', 'звёзд', 'stars'],
  'starsN': ['%1 yulduz', '%1 ★', '%1 stars'],
  'daysStreak': ['%1 kun ketma-ket', '%1 дн. подряд', '%1 days in a row'],

  // --- Bosh sahifa ---
  'hello': ['Salom!', 'Привет!', 'Hi!'],
  'helloName': ['Salom, %1!', 'Привет, %1!', 'Hi, %1!'],
  'homeQuestion': ["Bugun nimani oʻrganamiz?", 'Что будем учить сегодня?', 'What shall we learn today?'],
  'secAlphabet': ['Alifbo', 'Алфавит', 'Alphabet'],
  'secAlphabetSub': ['Harflar bilan tanish', 'Знакомься с буквами', 'Meet the letters'],
  'secLessons': ['Darslar', 'Уроки', 'Lessons'],
  'secLessonsSub': ['Harflar vodiysi', 'Долина букв', 'Letter Valley'],
  'secGames': ["Oʻyinlar", 'Игры', 'Games'],
  'secGamesSub': ["Oʻynab oʻrgan", 'Учись играя', 'Learn by playing'],
  'secWords': ["Soʻzlar", 'Слова', 'Words'],
  'secWordsSub': ["Rasm va soʻzlar", 'Картинки и слова', 'Pictures and words'],
  'secQuiz': ['Bilimdon', 'Знайка', 'Quiz time'],
  'secQuizSub': ['Savol-javob', 'Вопросы и ответы', 'Questions and answers'],
  'secTales': ['Ertaklar', 'Сказки', 'Fairy tales'],
  'secTalesSub': ['Tabiiy ovozda', 'Живым голосом', 'Read aloud'],
  'parents': ['Ota-onalar', 'Родителям', 'Parents'],

  // --- Alifbolar ---
  'scriptUzLatin': ["Oʻzbek alifbosi", 'Узбекский (латиница)', 'Uzbek (Latin)'],
  'scriptUzLatinShort': ['Lotin', 'Латиница', 'Latin'],
  'scriptUzNew': ['Yangi alifbo', 'Новый алфавит', 'New alphabet'],
  'scriptUzNewShort': ['Yangi lotin', 'Новая латиница', 'New Latin'],
  'scriptUzCyrl': ["Oʻzbek kirill", 'Узбекский (кириллица)', 'Uzbek (Cyrillic)'],
  'scriptUzCyrlShort': ['Kirill', 'Кириллица', 'Cyrillic'],
  'scriptRu': ['Rus alifbosi', 'Русский алфавит', 'Russian alphabet'],
  'scriptRuShort': ['Ruscha', 'Русский', 'Russian'],
  'scriptEn': ['Ingliz alifbosi', 'Английский алфавит', 'English alphabet'],
  'scriptEnShort': ['Inglizcha', 'Английский', 'English'],
  'chooseScript': ['Qaysi alifbo?', 'Какой алфавит?', 'Which alphabet?'],
  'newAlphabetNote': [
    "2027-yil 22-apreldan rasmiy alifbo: Ö (Oʻ), Ğ (Gʻ), Ş (Sh), Ç (Ch).",
    'Официальный алфавит с 22.04.2027: Ö (Oʻ), Ğ (Gʻ), Ş (Sh), Ç (Ch).',
    'Official from 22 April 2027: Ö (Oʻ), Ğ (Gʻ), Ş (Sh), Ç (Ch).'
  ],
  'lettersCount': ['%1 ta harf', '%1 букв', '%1 letters'],
  'learnedOf': ["%1 / %2 oʻrganildi", 'Изучено %1 из %2', '%1 of %2 learned'],

  // --- Harf sahifasi ---
  'tabLetter': ['Harf', 'Буква', 'Letter'],
  'tabWrite': ['Yozish', 'Писать', 'Write'],
  'tabWords': ["Soʻzlar", 'Слова', 'Words'],
  'vowel': ['Unli', 'Гласная', 'Vowel'],
  'consonant': ['Undosh', 'Согласная', 'Consonant'],
  'sign': ['Belgi', 'Знак', 'Sign'],
  'digraph': ['Harf birikmasi', 'Буквосочетание', 'Letter pair'],
  'bigSmall': ['Katta va kichik', 'Большая и маленькая', 'Big and small'],
  'traceHint': ['Barmogʻing bilan harf ustidan yoz', 'Обведи букву пальцем', 'Trace the letter with your finger'],
  'traceGood': ['Barakalla! Juda chiroyli!', 'Молодец! Очень красиво!', 'Well done! Beautiful!'],
  'traceMore': ['Yana ozgina! Harfning hamma joyini chiz.', 'Ещё немного! Обведи всю букву.', 'Almost! Trace the whole letter.'],
  'clear': ['Tozalash', 'Стереть', 'Clear'],
  'upper': ['Katta', 'Большая', 'Capital'],
  'lower': ['Kichik', 'Маленькая', 'Small'],
  'tapToHear': ['Bos va eshit', 'Нажми и послушай', 'Tap to listen'],

  // --- Darslar ---
  'lessonsTitle': ['Harflar vodiysi', 'Долина букв', 'Letter Valley'],
  'lessonsIntro': [
    "Darslarni tartib bilan oʻt — har biri 8 ta savol. Har bir darsdan 3 tagacha yulduz olasan!",
    'Проходи уроки по порядку — в каждом 8 вопросов. За урок можно получить до 3 звёзд!',
    'Go through the lessons in order — 8 questions each. Earn up to 3 stars per lesson!'
  ],
  'l_intro': ['Alifbo bilan tanishuv', 'Знакомство с алфавитом', 'Meet the alphabet'],
  'l_find': ['Harfni top', 'Найди букву', 'Find the letter'],
  'l_vowels': ['Unli tovushlar', 'Гласные звуки', 'Vowel sounds'],
  'l_consonants': ['Undosh tovushlar', 'Согласные звуки', 'Consonant sounds'],
  'l_case': ['Katta va kichik', 'Большие и маленькие', 'Big and small'],
  'l_order': ['Alifbo tartibi', 'Порядок букв', 'Alphabet order'],
  'l_first': ['Birinchi harf', 'Первая буква', 'First letter'],
  'l_syllable': ["Boʻgʻinlar", 'Слоги', 'Syllables'],
  'l_word': ["Soʻz yigʻamiz", 'Собираем слово', 'Build a word'],
  'l_read': ["Oʻqiymiz", 'Читаем', "Let's read"],
  'l_sentence': ['Gap tuzamiz', 'Составляем предложение', 'Make a sentence'],
  'l_write': ['Harf yozamiz', 'Пишем буквы', 'Write letters'],
  'lessonOf': ['%1-dars', 'Урок %1', 'Lesson %1'],
  'questionOf': ['%1 / %2', '%1 / %2', '%1 / %2'],

  // Savol matnlari
  'q_find': ['«%1» harfini top', 'Найди букву «%1»', 'Find the letter «%1»'],
  'q_same': ['Xuddi shunday harfni top', 'Найди такую же букву', 'Find the same letter'],
  'q_next': ['«%1» dan keyin qaysi harf keladi?', 'Какая буква идёт после «%1»?', 'Which letter comes after «%1»?'],
  'q_lower': ['«%1» harfining kichigini top', 'Найди маленькую «%1»', 'Find the small «%1»'],
  'q_upper': ['«%1» harfining kattasini top', 'Найди большую «%1»', 'Find the capital «%1»'],
  'q_vowel': ['Qaysi biri unli harf?', 'Какая буква гласная?', 'Which one is a vowel?'],
  'q_consonant': ['Qaysi biri undosh harf?', 'Какая буква согласная?', 'Which one is a consonant?'],
  'q_first': ['«%1» qaysi harf bilan boshlanadi?', 'С какой буквы начинается «%1»?', 'What letter does «%1» start with?'],
  'q_pic': ['«%1» harfi bilan boshlanadigan rasmni top', 'Найди картинку на букву «%1»', 'Find the picture that starts with «%1»'],
  'q_build': ["Harflardan soʻz yigʻ", 'Собери слово из букв', 'Build the word from letters'],
  'q_syllables': ["Boʻgʻinlarni qoʻshib oʻqi", 'Сложи слоги и прочитай', 'Join the syllables and read'],
  'q_read': ["Soʻzni oʻqi va rasmini top", 'Прочитай слово и найди картинку', 'Read the word and find the picture'],
  'q_sentence': ["Gapni toʻldir", 'Дополни предложение', 'Complete the sentence'],
  'q_trace': ['Harfni chiz', 'Обведи букву', 'Trace the letter'],
  'q_listen': ['Tingla va top', 'Слушай и найди', 'Listen and find'],
  'tapLettersInOrder': ['Harflarni tartib bilan bos', 'Нажимай буквы по порядку', 'Tap the letters in order'],

  // Natija
  'resGreat': ['Ajoyib!', 'Отлично!', 'Awesome!'],
  'resGood': ['Yaxshi!', 'Хорошо!', 'Good job!'],
  'resTry': ['Yana urinib koʻramiz!', 'Попробуем ещё раз!', "Let's try again!"],
  'resCorrect': ["%1 / %2 toʻgʻri", '%1 из %2 верно', '%1 of %2 correct'],
  'toMenu': ['Menyuga', 'В меню', 'Menu'],
  'nextLesson': ['Keyingi dars', 'Следующий урок', 'Next lesson'],
  'quitTitle': ['Darsni toʻxtatamizmi?', 'Остановить урок?', 'Stop the lesson?'],
  'quitBody': ['Natija saqlanmaydi.', 'Результат не сохранится.', "Progress won't be saved."],
  'quitYes': ['Ha, chiqish', 'Да, выйти', 'Yes, leave'],
  'quitNo': ['Davom etamiz', 'Продолжим', 'Keep going'],

  // --- O'yinlar ---
  'g_balloons': ['Harf ovi', 'Охота на буквы', 'Letter hunt'],
  'g_balloonsSub': ["Toʻgʻri harfli sharni yor", 'Лопай шарики с нужной буквой', 'Pop the balloons with the right letter'],
  'g_memory': ['Juftini top', 'Найди пару', 'Find the pair'],
  'g_memorySub': ['Katta va kichik harfni juftla', 'Соедини большую и маленькую', 'Match capital and small letters'],
  'g_train': ['Harf poyezdi', 'Поезд букв', 'Letter train'],
  'g_trainSub': ['Vagonlarni alifbo tartibida ula', 'Собери вагоны по алфавиту', 'Line up the wagons in ABC order'],
  'g_picture': ["Rasmli oʻyin", 'Игра с картинками', 'Picture game'],
  'g_pictureSub': ['Rasm qaysi harfdan boshlanadi?', 'С какой буквы картинка?', 'Which letter does it start with?'],
  'popLetter': ['«%1» harfli sharlarni yor!', 'Лопай шарики с «%1»!', 'Pop the «%1» balloons!'],
  'allPairs': ['Hamma juftlar topildi!', 'Все пары найдены!', 'All pairs found!'],
  'moves': ['%1 urinish', 'Ходов: %1', '%1 moves'],
  'trainReady': ["Ofarin! Poyezd yoʻlga chiqdi!", 'Ура! Поезд поехал!', 'Hooray! The train is off!'],
  'score': ['Ochko: %1', 'Очки: %1', 'Score: %1'],
  'round': ['%1-bosqich', 'Раунд %1', 'Round %1'],

  // --- So'zlar ---
  'wordsTitle': ["Soʻzlar", 'Слова', 'Words'],
  'wordsQuiz': ['Tingla va top', 'Слушай и найди', 'Listen and find'],
  'wordsLearn': ["Koʻrib chiqish", 'Смотреть', 'Browse'],
  'c_animals': ['Hayvonlar', 'Животные', 'Animals'],
  'c_birds': ['Qushlar va hasharotlar', 'Птицы и насекомые', 'Birds and insects'],
  'c_food': ['Meva va sabzavotlar', 'Фрукты и овощи', 'Fruits and vegetables'],
  'c_professions': ['Kasblar', 'Профессии', 'Jobs'],
  'c_transport': ['Transport', 'Транспорт', 'Transport'],
  'c_home': ["Uy-roʻzgʻor", 'Дом', 'At home'],
  'c_clothes': ['Kiyimlar', 'Одежда', 'Clothes'],
  'c_colors': ['Ranglar', 'Цвета', 'Colours'],
  'c_nature': ['Tabiat', 'Природа', 'Nature'],
  'c_music': ['Musiqa asboblari', 'Музыкальные инструменты', 'Musical instruments'],
  'c_body': ["Tana aʼzolari", 'Части тела', 'Body parts'],
  'c_time': ['Kunlar va oylar', 'Дни и месяцы', 'Days and months'],
  'c_family': ['Oila', 'Семья', 'Family'],
  'c_numbers': ['Sonlar', 'Числа', 'Numbers'],

  // --- Bilimdon ---
  'quizTitle': ['Bilimdon', 'Знайка', 'Quiz time'],
  'quizIntro': [
    "Ziyrak darslaridan savollar — tingla, oʻyla va top!",
    'Вопросы из уроков Ziyrak — слушай, думай и отвечай!',
    'Questions from Ziyrak lessons — listen, think and answer!'
  ],
  'z_professions': ['Kasblar', 'Профессии', 'Jobs'],
  'z_seasons': ['Fasllar va oylar', 'Времена года', 'Seasons and months'],
  'z_world': ['Atrofimizdagi olam', 'Мир вокруг нас', 'The world around us'],
  'z_safety': ['Xavfsizlik', 'Безопасность', 'Safety'],
  'z_health': ['Salomatlik', 'Здоровье', 'Health'],
  'z_riddles': ['Topishmoqlar', 'Загадки', 'Riddles'],
  'z_compare': ['Katta-kichik', 'Больше-меньше', 'Big and small'],
  'z_colors': ['Ranglar', 'Цвета', 'Colours'],
  'onlyUzbek': [
    "Savollar oʻzbek tilida ovozlanadi.",
    'Вопросы озвучены на узбекском языке.',
    'Questions are voiced in Uzbek.'
  ],

  // --- Ertaklar ---
  'talesTitle': ['Ertaklar', 'Сказки', 'Fairy tales'],
  'talesIntro': [
    "Ziko ertaklarni tabiiy ovozda aytib beradi. Uxlashdan oldin birga tinglang!",
    'Зико рассказывает сказки на узбекском живым голосом. Слушайте вместе перед сном!',
    'Ziko tells Uzbek fairy tales in a real voice. Listen together at bedtime!'
  ],
  'minutesShort': ['%1 daq', '%1 мин', '%1 min'],

  // --- Ota-onalar ---
  'gateTitle': ['Ota-onalar uchun', 'Для родителей', 'For parents'],
  'gateBody': ["Davom etish uchun javobni tanlang:", 'Чтобы продолжить, выберите ответ:', 'To continue, choose the answer:'],
  'gateWrong': ["Notoʻgʻri. Qaytadan urinib koʻring.", 'Неверно. Попробуйте ещё раз.', 'Wrong. Please try again.'],
  'settings': ['Sozlamalar', 'Настройки', 'Settings'],
  'uiLanguage': ['Interfeys tili', 'Язык интерфейса', 'App language'],
  'defaultScript': ['Asosiy alifbo', 'Основной алфавит', 'Main alphabet'],
  'sound': ['Tovush', 'Звук', 'Sound'],
  'voiceGuide': ["Ovozli yoʻriqnoma", 'Голосовые подсказки', 'Voice guidance'],
  'effects': ['Effekt tovushlari', 'Звуковые эффекты', 'Sound effects'],
  'music': ['Fon musiqasi', 'Фоновая музыка', 'Background music'],
  'childName': ['Bolaning ismi', 'Имя ребёнка', "Child's name"],
  'childNameHint': ['Masalan: Aziza', 'Например: Азиза', 'e.g. Aziza'],
  'progress': ['Natijalar', 'Успехи', 'Progress'],
  'lettersLearned': ["Oʻrganilgan harflar", 'Изучено букв', 'Letters learned'],
  'lessonsDone': ['Tugatilgan darslar', 'Пройдено уроков', 'Lessons completed'],
  'totalStars': ['Jami yulduzlar', 'Всего звёзд', 'Total stars'],
  'gamesPlayed': ["Oʻynalgan oʻyinlar", 'Сыграно игр', 'Games played'],
  'streak': ['Ketma-ket kunlar', 'Дней подряд', 'Day streak'],
  'resetProgress': ['Natijalarni tozalash', 'Сбросить прогресс', 'Reset progress'],
  'resetConfirm': [
    "Barcha yulduzlar va natijalar oʻchiriladi. Davom etasizmi?",
    'Все звёзды и результаты будут удалены. Продолжить?',
    'All stars and results will be deleted. Continue?'
  ],
  'privacy': ['Maxfiylik', 'Конфиденциальность', 'Privacy'],
  'privacyBody': [
    "Ilova hech qanday shaxsiy maʼlumot yigʻmaydi. Barcha natijalar faqat shu telefonda saqlanadi. Ilova internetsiz toʻliq ishlaydi; internet faqat bolalar uchun moslashtirilgan reklama koʻrsatish uchun ishlatiladi.",
    'Приложение не собирает личные данные. Все результаты хранятся только на этом телефоне. Приложение полностью работает без интернета; интернет нужен только для детской рекламы.',
    'The app collects no personal data. All progress stays on this phone. The app works fully offline; the internet is used only to show child-safe ads.'
  ],
  'about': ['Ilova haqida', 'О приложении', 'About'],
  'aboutBody': [
    "Uztomic tomonidan ishlab chiqilgan. Ovozlar va Ziko maskoti — Ziyrak ilovasidan.",
    'Разработано Uztomic. Голоса и талисман Зико — из приложения Ziyrak.',
    'Made by Uztomic. Voices and the Ziko mascot come from the Ziyrak app.'
  ],
  'version': ['Versiya %1', 'Версия %1', 'Version %1'],

  // --- Baho so'rash ---
  'reviewTitle': ["Ilova yoqdimi?", 'Нравится приложение?', 'Enjoying the app?'],
  'reviewBody': [
    "Ota-onalar, Play Marketda baho va izoh qoldiring — bu boshqa oilalarga ilovani topishga va bizga uni yanada yaxshilashga yordam beradi. Rahmat!",
    'Родители, оставьте оценку и отзыв в Play Маркете — это поможет другим семьям найти приложение, а нам — сделать его лучше. Спасибо!',
    'Parents, please leave a rating and review on Google Play — it helps other families find the app and helps us make it better. Thank you!'
  ],
  'reviewYes': ['Baho berish', 'Оценить', 'Rate the app'],
  'reviewLater': ['Keyinroq', 'Позже', 'Later'],
  'rateApp': ['Ilovani baholash', 'Оценить приложение', 'Rate the app'],

  // --- Tanishuv (onboarding) ---
  'obWelcome': ['Xush kelibsiz!', 'Добро пожаловать!', 'Welcome!'],
  'obWelcomeBody': [
    "Men Zikoman! Birga harflarni oʻrganamiz, oʻynaymiz va ertak tinglaymiz.",
    'Я Зико! Вместе будем учить буквы, играть и слушать сказки.',
    "I'm Ziko! Together we'll learn letters, play games and listen to stories."
  ],
  'obLang': ['Tilni tanlang', 'Выберите язык', 'Choose a language'],
  'obName': ['Bolangizning ismi', 'Как зовут ребёнка?', "What's your child's name?"],
  'obNameBody': ["Ziko bolangizga ismi bilan murojaat qiladi. Ixtiyoriy.", 'Зико будет обращаться к ребёнку по имени. Необязательно.', 'Ziko will greet your child by name. Optional.'],
  'obScript': ['Qaysi alifbodan boshlaymiz?', 'С какого алфавита начнём?', 'Which alphabet first?'],
  'obScriptBody': ["Keyin istalgan vaqtda almashtirish mumkin.", 'Его можно сменить в любой момент.', 'You can switch at any time.'],
  'obGo': ['Boshladik!', 'Поехали!', "Let's go!"],
  'skip': ["Oʻtkazib yuborish", 'Пропустить', 'Skip'],
};
