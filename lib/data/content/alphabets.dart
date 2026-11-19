import '../../core/audio/audio_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/translit.dart';
import '../../domain/entities/alphabet.dart';

/// O'zbek alifbosining asosiy ma'lumoti (joriy lotin yozuvida). Yangi
/// lotin va kirill alifbolari shundan avtomatik quriladi, shuning uchun
/// so'zlar va ovozlar uchala yozuvda bir xil.
///
/// Har bir so'z uchun ilovada tabiiy ovoz yozuvi bor (tools/voice_tool.py
/// bilan tekshiriladi).
const List<(String, LetterKind, List<(String, String, String?)>)> _uzBase = [
  ('A', LetterKind.vowel, [('ari', '🐝', 'a-ri'), ('ayiq', '🐻', 'a-yiq'), ('avtobus', '🚌', 'av-to-bus'), ('asal', '🍯', 'a-sal')]),
  ('B', LetterKind.consonant, [('baliq', '🐟', 'ba-liq'), ('banan', '🍌', 'ba-nan'), ('bulut', '☁️', 'bu-lut'), ('bodring', '🥒', 'bod-ring')]),
  ('D', LetterKind.consonant, [('daraxt', '🌳', 'da-raxt'), ('deraza', '🪟', 'de-ra-za'), ('daryo', '🏞️', 'dar-yo')]),
  ('E', LetterKind.vowel, [('echki', '🐐', 'ech-ki'), ('eshik', '🚪', 'e-shik'), ('ertak', '📖', 'er-tak')]),
  ('F', LetterKind.consonant, [('fil', '🐘', null), ('futbolka', '👕', 'fut-bol-ka'), ('fotoapparat', '📷', null)]),
  ('G', LetterKind.consonant, [('gul', '🌸', null), ('gazeta', '📰', 'ga-ze-ta'), ('guruch', '🍚', 'gu-ruch')]),
  ('H', LetterKind.consonant, [('haydovchi', '🚕', 'hay-dov-chi'), ('havorang', '🩵', 'ha-vo-rang')]),
  ('I', LetterKind.vowel, [('it', '🐕', null), ('ildiz', '🌱', 'il-diz'), ('issiq', '🔥', 'is-siq')]),
  ('J', LetterKind.consonant, [('jirafa', '🦒', 'ji-ra-fa'), ('jun', '🧶', null), ('juma', '📅', 'ju-ma')]),
  ('K', LetterKind.consonant, [('kapalak', '🦋', 'ka-pa-lak'), ('kitob', '📕', 'ki-tob'), ('koptok', '⚽', 'kop-tok'), ('kema', '🚢', 'ke-ma'), ('kaktus', '🌵', 'kak-tus')]),
  ('L', LetterKind.consonant, [('limon', '🍋', 'li-mon'), ('likopcha', '🍽️', 'li-kop-cha'), ('laylak', '🕊️', 'lay-lak')]),
  ('M', LetterKind.consonant, [('mushuk', '🐱', 'mu-shuk'), ('mashina', '🚗', 'ma-shi-na'), ('muz', '🧊', null), ('meva', '🍇', 'me-va')]),
  ('N', LetterKind.consonant, [('non', '🍞', null), ('nok', '🍐', null), ('novvoy', '👨‍🍳', 'nov-voy')]),
  ('O', LetterKind.vowel, [('olma', '🍎', 'ol-ma'), ('oy', '🌙', null), ('ot', '🐎', null), ('ona', '👩', 'o-na')]),
  ('P', LetterKind.consonant, [('pingvin', '🐧', 'ping-vin'), ('poyezd', '🚂', 'po-yezd'), ('pomidor', '🍅', 'po-mi-dor'), ('paypoq', '🧦', 'pay-poq')]),
  ('Q', LetterKind.consonant, [('qush', '🐦', null), ('quyosh', '☀️', 'qu-yosh'), ('qalam', '✏️', 'qa-lam'), ('quyon', '🐰', 'qu-yon'), ('qurbaqa', '🐸', 'qur-ba-qa')]),
  ('R', LetterKind.consonant, [('rassom', '🎨', 'ras-som'), ('radio', '📻', 'ra-di-o'), ('rasm', '🖼️', null)]),
  ('S', LetterKind.consonant, [('sigir', '🐄', 'si-gir'), ('soat', '⏰', 'so-at'), ('samolyot', '✈️', 'sa-mol-yot'), ('sabzi', '🥕', 'sab-zi'), ('sut', '🥛', null)]),
  ('T', LetterKind.consonant, [('tarvuz', '🍉', 'tar-vuz'), ('tovuq', '🐔', 'to-vuq'), ('toshbaqa', '🐢', 'tosh-ba-qa'), ('tuxum', '🥚', 'tu-xum'), ('tulki', '🦊', 'tul-ki')]),
  ('U', LetterKind.vowel, [('uy', '🏠', null), ('uzum', '🍇', 'u-zum'), ('uchuvchi', '👨‍✈️', 'u-chuv-chi'), ('uka', '👦', 'u-ka')]),
  ('V', LetterKind.consonant, [('velosiped', '🚲', 've-lo-si-ped'), ('veterinar', '🐾', 've-te-ri-nar')]),
  ('X', LetterKind.consonant, [('xoʻroz', '🐓', 'xoʻ-roz'), ('xonanda', '🎤', 'xo-nan-da')]),
  ('Y', LetterKind.consonant, [('yulduz', '⭐', 'yul-duz'), ('yomgʻir', '🌧️', 'yom-gʻir'), ('yashil', '🟩', 'ya-shil')]),
  ('Z', LetterKind.consonant, [('zargar', '💍', 'zar-gar'), ('zarafa', '🦒', 'za-ra-fa')]),
  ('Oʻ', LetterKind.vowel, [('oʻrdak', '🦆', 'oʻr-dak'), ('oʻrik', '🍑', 'oʻ-rik'), ('oʻyinchoq', '🧸', 'oʻ-yin-choq'), ('oʻrgimchak', '🕷️', 'oʻr-gim-chak')]),
  ('Gʻ', LetterKind.consonant, [('gʻisht', '🧱', null), ('gʻijjak', '🎻', 'gʻij-jak')]),
  ('Sh', LetterKind.consonant, [('sher', '🦁', null), ('shapka', '🧢', 'shap-ka'), ('shamol', '🌬️', 'sha-mol'), ('sharf', '🧣', null)]),
  ('Ch', LetterKind.consonant, [('chumoli', '🐜', 'chu-mo-li'), ('choynak', '🫖', 'choy-nak'), ('chiroq', '💡', 'chi-roq'), ('chana', '🛷', 'cha-na')]),
  ('Ng', LetterKind.digraph, [('bodring', '🥒', 'bod-ring')]),
  ('ʼ', LetterKind.sign, []),
];

List<Word> _uzWords(List<(String, String, String?)> raw, String Function(String) conv) => [
      for (final (w, e, syl) in raw)
        Word(conv(w), e, say: w, lang: VoiceLang.uz, syllables: syl == null ? null : conv(syl)),
    ];

String _lowerUz(String l) => l == 'ʼ' ? 'ʼ' : l.toLowerCase();

final Alphabet uzLatin = Alphabet(
  id: ScriptId.uzLatin,
  titleKey: 'scriptUzLatin',
  shortKey: 'scriptUzLatinShort',
  badge: 'Aa',
  color: AppColors.teal,
  voiceLang: VoiceLang.uz,
  letters: [
    for (final (l, k, w) in _uzBase)
      Letter(
        upper: l,
        lower: _lowerUz(l),
        say: l == 'ʼ' ? 'tutuq belgisi' : l,
        sayLang: VoiceLang.uz,
        kind: k,
        words: _uzWords(w, (s) => s),
        uzKey: l,
      ),
  ],
);

/// 2027-yil 22-apreldan kuchga kiradigan yangi lotin alifbosi
/// (O'RQ-1184): Oʻ→Ö, Gʻ→Ğ, Sh→Ş, Ch→Ç. 28 harf va tutuq belgisi.
/// Qonunning rasmiy tartibi e'lon qilinguncha yangi harflar Z dan keyin.
final Alphabet uzNew = Alphabet(
  id: ScriptId.uzNew,
  titleKey: 'scriptUzNew',
  shortKey: 'scriptUzNewShort',
  badge: 'Öö',
  color: AppColors.grape,
  voiceLang: VoiceLang.uz,
  letters: [
    for (final (l, k, w) in _uzBase)
      Letter(
        upper: latinToNewLatin(l),
        lower: latinToNewLatin(_lowerUz(l)),
        say: l == 'ʼ' ? 'tutuq belgisi' : l,
        sayLang: VoiceLang.uz,
        kind: k,
        words: _uzWords(w, latinToNewLatin),
        uzKey: l,
      ),
  ],
);

/// O'zbek kirill alifbosi (35 harf). Lotinda mos harfi bor harflar shu
/// harfning tabiiy ovozi bilan o'qiladi; Е, Ё, Ю, Я, Ц — rus TTS orqali.
final Alphabet uzCyrl = Alphabet(
  id: ScriptId.uzCyrl,
  titleKey: 'scriptUzCyrl',
  shortKey: 'scriptUzCyrlShort',
  badge: 'Ўў',
  color: AppColors.coral,
  voiceLang: VoiceLang.uz,
  letters: [
    for (final (cyr, latin, kind, ruSay, extra) in _cyrl)
      Letter(
        upper: cyr,
        lower: _cyrLower[cyr] ?? cyr.toLowerCase(),
        say: ruSay ?? latin ?? '',
        sayLang: ruSay != null ? VoiceLang.ru : VoiceLang.uz,
        kind: kind,
        words: extra.isNotEmpty || latin == null
            ? _uzWords(extra, latinToCyrillic)
            : _uzWords(_baseWordsFor(latin), latinToCyrillic),
        uzKey: latin,
      ),
  ],
);

const Map<String, String> _cyrLower = {'Ў': 'ў', 'Қ': 'қ', 'Ғ': 'ғ', 'Ҳ': 'ҳ', 'Ё': 'ё'};

List<(String, String, String?)> _baseWordsFor(String latin) =>
    _uzBase.firstWhere((e) => e.$1 == latin).$3;

/// (kirill harf, mos lotin harf, turi, rus TTS bilan o'qish, qo'shimcha so'zlar)
const List<(String, String?, LetterKind, String?, List<(String, String, String?)>)> _cyrl = [
  ('А', 'A', LetterKind.vowel, null, []),
  ('Б', 'B', LetterKind.consonant, null, []),
  ('В', 'V', LetterKind.consonant, null, []),
  ('Г', 'G', LetterKind.consonant, null, []),
  ('Д', 'D', LetterKind.consonant, null, []),
  ('Е', null, LetterKind.vowel, 'е', [('yettita', '7️⃣', 'yet-ti-ta')]),
  ('Ё', null, LetterKind.vowel, 'ё', [('yoz', '🏖️', null)]),
  ('Ж', 'J', LetterKind.consonant, null, []),
  ('З', 'Z', LetterKind.consonant, null, []),
  ('И', 'I', LetterKind.vowel, null, []),
  ('Й', 'Y', LetterKind.consonant, null, [('yigit', '🧑', 'yi-git')]),
  ('К', 'K', LetterKind.consonant, null, []),
  ('Л', 'L', LetterKind.consonant, null, []),
  ('М', 'M', LetterKind.consonant, null, []),
  ('Н', 'N', LetterKind.consonant, null, []),
  ('О', 'O', LetterKind.vowel, null, []),
  ('П', 'P', LetterKind.consonant, null, []),
  ('Р', 'R', LetterKind.consonant, null, []),
  ('С', 'S', LetterKind.consonant, null, []),
  ('Т', 'T', LetterKind.consonant, null, []),
  ('У', 'U', LetterKind.vowel, null, []),
  ('Ф', 'F', LetterKind.consonant, null, []),
  ('Х', 'X', LetterKind.consonant, null, []),
  ('Ц', null, LetterKind.consonant, 'цэ', []),
  ('Ч', 'Ch', LetterKind.consonant, null, []),
  ('Ш', 'Sh', LetterKind.consonant, null, []),
  ('Ъ', null, LetterKind.sign, 'твёрдый знак', []),
  ('Ь', null, LetterKind.sign, 'мягкий знак', []),
  ('Э', 'E', LetterKind.vowel, null, []),
  ('Ю', null, LetterKind.vowel, 'ю', [('yulduz', '⭐', 'yul-duz')]),
  ('Я', null, LetterKind.vowel, 'я', [('yashil', '🟩', 'ya-shil'), ('yanvar', '❄️', 'yan-var')]),
  ('Ў', 'Oʻ', LetterKind.vowel, null, []),
  ('Қ', 'Q', LetterKind.consonant, null, []),
  ('Ғ', 'Gʻ', LetterKind.consonant, null, []),
  ('Ҳ', 'H', LetterKind.consonant, null, []),
];

/// Rus alifbosi — ovoz rus tilida (yozuv bo'lsa tabiiy ovoz, bo'lmasa TTS).
final Alphabet russian = Alphabet(
  id: ScriptId.ru,
  titleKey: 'scriptRu',
  shortKey: 'scriptRuShort',
  badge: 'Бб',
  color: AppColors.sky,
  voiceLang: VoiceLang.ru,
  letters: [
    for (final (l, name, kind, words) in _ru)
      Letter(
        upper: l,
        lower: l.toLowerCase(),
        say: name,
        sayLang: VoiceLang.ru,
        kind: kind,
        words: [for (final (w, e) in words) Word(w, e, say: w, lang: VoiceLang.ru)],
      ),
  ],
);

const List<(String, String, LetterKind, List<(String, String)>)> _ru = [
  ('А', 'а', LetterKind.vowel, [('арбуз', '🍉'), ('аквариум', '🐠')]),
  ('Б', 'бэ', LetterKind.consonant, [('банан', '🍌'), ('бабочка', '🦋')]),
  ('В', 'вэ', LetterKind.consonant, [('волк', '🐺'), ('виноград', '🍇')]),
  ('Г', 'гэ', LetterKind.consonant, [('гриб', '🍄'), ('гусь', '🪿')]),
  ('Д', 'дэ', LetterKind.consonant, [('дом', '🏠'), ('дерево', '🌳')]),
  ('Е', 'е', LetterKind.vowel, [('ель', '🌲'), ('енот', '🦝')]),
  ('Ё', 'ё', LetterKind.vowel, [('ёж', '🦔'), ('ёлка', '🎄')]),
  ('Ж', 'жэ', LetterKind.consonant, [('жираф', '🦒'), ('жук', '🪲')]),
  ('З', 'зэ', LetterKind.consonant, [('зебра', '🦓'), ('зонт', '☂️')]),
  ('И', 'и', LetterKind.vowel, [('игрушка', '🧸'), ('индюк', '🦃')]),
  ('Й', 'и краткое', LetterKind.consonant, [('йогурт', '🥛')]),
  ('К', 'ка', LetterKind.consonant, [('кот', '🐱'), ('кит', '🐳')]),
  ('Л', 'эль', LetterKind.consonant, [('лиса', '🦊'), ('лимон', '🍋')]),
  ('М', 'эм', LetterKind.consonant, [('мяч', '⚽'), ('мышь', '🐭')]),
  ('Н', 'эн', LetterKind.consonant, [('нос', '👃'), ('носки', '🧦')]),
  ('О', 'о', LetterKind.vowel, [('облако', '☁️'), ('огурец', '🥒')]),
  ('П', 'пэ', LetterKind.consonant, [('пингвин', '🐧'), ('птичка', '🐦')]),
  ('Р', 'эр', LetterKind.consonant, [('рыба', '🐟'), ('ракета', '🚀')]),
  ('С', 'эс', LetterKind.consonant, [('солнце', '☀️'), ('собака', '🐕')]),
  ('Т', 'тэ', LetterKind.consonant, [('тигр', '🐯'), ('торт', '🎂')]),
  ('У', 'у', LetterKind.vowel, [('утка', '🦆'), ('улитка', '🐌')]),
  ('Ф', 'эф', LetterKind.consonant, [('флаг', '🚩'), ('фонарь', '🏮')]),
  ('Х', 'ха', LetterKind.consonant, [('хлеб', '🍞'), ('хомяк', '🐹')]),
  ('Ц', 'цэ', LetterKind.consonant, [('цветок', '🌸'), ('цыплёнок', '🐥')]),
  ('Ч', 'че', LetterKind.consonant, [('чай', '🍵'), ('часы', '⌚')]),
  ('Ш', 'ша', LetterKind.consonant, [('шар', '🎈'), ('шапка', '🧢')]),
  ('Щ', 'ща', LetterKind.consonant, [('щенок', '🐶'), ('щётка', '🪥')]),
  ('Ъ', 'твёрдый знак', LetterKind.sign, []),
  ('Ы', 'ы', LetterKind.vowel, [('сыр', '🧀'), ('мыло', '🧼')]),
  ('Ь', 'мягкий знак', LetterKind.sign, [('конь', '🐴')]),
  ('Э', 'э', LetterKind.vowel, [('эскимо', '🍦'), ('экскаватор', '🚜')]),
  ('Ю', 'ю', LetterKind.vowel, [('юбка', '👗'), ('юла', '🌀')]),
  ('Я', 'я', LetterKind.vowel, [('яблоко', '🍎'), ('ягоды', '🍓')]),
];

/// Ingliz alifbosi.
final Alphabet english = Alphabet(
  id: ScriptId.en,
  titleKey: 'scriptEn',
  shortKey: 'scriptEnShort',
  badge: 'Ab',
  color: AppColors.berry,
  voiceLang: VoiceLang.en,
  letters: [
    for (final (l, name, words) in _en)
      Letter(
        upper: l,
        lower: l.toLowerCase(),
        say: name,
        sayLang: VoiceLang.en,
        kind: 'AEIOU'.contains(l) ? LetterKind.vowel : LetterKind.consonant,
        words: [for (final (w, e) in words) Word(w, e, say: w, lang: VoiceLang.en)],
      ),
  ],
);

const List<(String, String, List<(String, String)>)> _en = [
  ('A', 'ay', [('apple', '🍎'), ('apricot', '🍑'), ('aquarium', '🐠')]),
  ('B', 'bee', [('ball', '⚽'), ('bear', '🐻'), ('banana', '🍌'), ('bird', '🐦')]),
  ('C', 'see', [('cat', '🐱'), ('cow', '🐄'), ('car', '🚗'), ('cherry', '🍒')]),
  ('D', 'dee', [('dog', '🐕'), ('duck', '🦆')]),
  ('E', 'ee', [('ear', '👂'), ('eye', '👁️'), ('eight', '8️⃣')]),
  ('F', 'ef', [('fish', '🐟'), ('frog', '🐸'), ('flower', '🌸')]),
  ('G', 'jee', [('grapes', '🍇'), ('green', '🟩'), ('gloves', '🧤')]),
  ('H', 'aitch', [('house', '🏠'), ('horse', '🐴'), ('hat', '🎩')]),
  ('I', 'eye', [('ice cream', '🍦'), ('igloo', '🛖')]),
  ('J', 'jay', [('jacket', '🧥'), ('juice', '🧃')]),
  ('K', 'kay', [('kite', '🪁'), ('key', '🔑')]),
  ('L', 'el', [('lion', '🦁'), ('leg', '🦵'), ('lemon', '🍋')]),
  ('M', 'em', [('moon', '🌙'), ('mouth', '👄'), ('mother', '👩')]),
  ('N', 'en', [('nose', '👃'), ('nest', '🪺'), ('nine', '9️⃣')]),
  ('O', 'oh', [('orange', '🍊'), ('owl', '🦉')]),
  ('P', 'pee', [('pear', '🍐'), ('pomegranate', '🍎')]),
  ('Q', 'cue', [('queen', '👑'), ('question', '❓')]),
  ('R', 'ar', [('rabbit', '🐰'), ('red', '🟥'), ('rainbow', '🌈')]),
  ('S', 'ess', [('sun', '☀️'), ('star', '⭐'), ('socks', '🧦')]),
  ('T', 'tee', [('tree', '🌳'), ('ten', '🔟'), ('trousers', '👖')]),
  ('U', 'you', [('umbrella', '☂️'), ('unicorn', '🦄')]),
  ('V', 'vee', [('violin', '🎻'), ('van', '🚐')]),
  ('W', 'double you', [('watermelon', '🍉'), ('white', '⬜')]),
  ('X', 'ex', [('fox', '🦊'), ('box', '📦')]),
  ('Y', 'why', [('yellow', '🟨'), ('yo-yo', '🪀')]),
  ('Z', 'zee', [('zebra', '🦓'), ('zoo', '🦁')]),
];

final List<Alphabet> allAlphabets = [uzLatin, uzNew, uzCyrl, russian, english];

Alphabet alphabetOf(ScriptId id) => switch (id) {
      ScriptId.uzLatin => uzLatin,
      ScriptId.uzNew => uzNew,
      ScriptId.uzCyrl => uzCyrl,
      ScriptId.ru => russian,
      ScriptId.en => english,
    };
