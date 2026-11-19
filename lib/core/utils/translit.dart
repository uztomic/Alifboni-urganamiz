/// O'zbek lotin yozuvini kirill yozuviga o'giradi.
///
/// Interfeys matnlari va so'zlar faqat lotinda yoziladi, kirill versiyasi
/// shu funksiya orqali avtomatik olinadi — shu sababli ikki yozuv hech
/// qachon bir-biridan farq qilib qolmaydi.
String latinToCyrillic(String input) {
  final s = _normalizeApostrophes(input);
  final out = StringBuffer();
  var i = 0;
  bool isWordStart(int idx) {
    if (idx == 0) return true;
    final prev = s[idx - 1];
    return !_isLetter(prev);
  }

  while (i < s.length) {
    final c = s[i];
    final next = i + 1 < s.length ? s[i + 1] : '';
    final lower = c.toLowerCase();
    final upper = c != lower;
    final nextUpper = next.isNotEmpty && next != next.toLowerCase();

    String emit(String cyr) => upper
        ? (nextUpper || (next.isEmpty || !_isLetter(next))
            ? cyr.toUpperCase()
            : cyr[0].toUpperCase() + cyr.substring(1))
        : cyr;

    // Ikki harfli birikmalar
    if (lower == 'o' && next == 'ʻ') {
      out.write(upper ? 'Ў' : 'ў');
      i += 2;
      continue;
    }
    if (lower == 'g' && next == 'ʻ') {
      out.write(upper ? 'Ғ' : 'ғ');
      i += 2;
      continue;
    }
    if (lower == 's' && next.toLowerCase() == 'h') {
      out.write(upper ? 'Ш' : 'ш');
      i += 2;
      continue;
    }
    if (lower == 'c' && next.toLowerCase() == 'h') {
      out.write(upper ? 'Ч' : 'ч');
      i += 2;
      continue;
    }
    if (lower == 'y' && next.isNotEmpty) {
      final n = next.toLowerCase();
      const map = {'a': 'я', 'u': 'ю', 'o': 'ё', 'e': 'е'};
      // "yoʻ" — ё emas, йў
      final afterNext = i + 2 < s.length ? s[i + 2] : '';
      if (map.containsKey(n) && !(n == 'o' && afterNext == 'ʻ')) {
        out.write(emit(map[n]!));
        i += 2;
        continue;
      }
    }
    if (lower == 'e') {
      out.write(upper ? (isWordStart(i) ? 'Э' : 'Е') : (isWordStart(i) ? 'э' : 'е'));
      i++;
      continue;
    }
    if (c == 'ʼ') {
      out.write('ъ');
      i++;
      continue;
    }
    final single = _single[lower];
    if (single != null) {
      out.write(upper ? single.toUpperCase() : single);
    } else {
      out.write(c);
    }
    i++;
  }
  return out.toString();
}

const Map<String, String> _single = {
  'a': 'а', 'b': 'б', 'd': 'д', 'f': 'ф', 'g': 'г', 'h': 'ҳ', 'i': 'и',
  'j': 'ж', 'k': 'к', 'l': 'л', 'm': 'м', 'n': 'н', 'o': 'о', 'p': 'п',
  'q': 'қ', 'r': 'р', 's': 'с', 't': 'т', 'u': 'у', 'v': 'в', 'x': 'х',
  'y': 'й', 'z': 'з',
};

bool _isLetter(String ch) => ch.toLowerCase() != ch.toUpperCase() || ch == 'ʻ';

/// Turli apostroflarni (', ‘, ’, `) o'zbekcha ʻ belgisiga keltiradi —
/// faqat o va g dan keyin; boshqa joylarda tutuq belgisi ʼ bo'ladi.
String _normalizeApostrophes(String s) {
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (c == "'" || c == '‘' || c == '’' || c == '`' || c == 'ʻ' || c == 'ʼ') {
      final prev = i > 0 ? s[i - 1].toLowerCase() : '';
      b.write(prev == 'o' || prev == 'g' ? 'ʻ' : (c == 'ʻ' ? 'ʻ' : 'ʼ'));
    } else {
      b.write(c);
    }
  }
  return b.toString();
}

/// Joriy lotin yozuvini 2027-yildan kuchga kiradigan yangi lotin yozuviga
/// o'giradi (O'RQ-1184: Oʻ→Ö, Gʻ→Ğ, Sh→Ş, Ch→Ç).
String latinToNewLatin(String input) {
  final s = _normalizeApostrophes(input);
  final out = StringBuffer();
  var i = 0;
  while (i < s.length) {
    final c = s[i];
    final next = i + 1 < s.length ? s[i + 1] : '';
    final lower = c.toLowerCase();
    final upper = c != lower;
    if (lower == 'o' && next == 'ʻ') {
      out.write(upper ? 'Ö' : 'ö');
      i += 2;
    } else if (lower == 'g' && next == 'ʻ') {
      out.write(upper ? 'Ğ' : 'ğ');
      i += 2;
    } else if (lower == 's' && next.toLowerCase() == 'h') {
      out.write(upper ? 'Ş' : 'ş');
      i += 2;
    } else if (lower == 'c' && next.toLowerCase() == 'h') {
      out.write(upper ? 'Ç' : 'ç');
      i += 2;
    } else {
      out.write(c);
      i++;
    }
  }
  return out.toString();
}
