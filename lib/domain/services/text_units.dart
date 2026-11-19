import '../entities/alphabet.dart';

/// So'zni alifbo birliklariga ajratadi: "shapka" → [sh, a, p, k, a],
/// "oʻrdak" → [oʻ, r, d, a, k]. Alifboda yo'q belgilar (tire, bo'shliq)
/// alohida birlik bo'lib qoladi.
List<String> splitUnits(String word, Alphabet a) {
  final units = <String>{
    for (final l in a.letters)
      if (l.kind != LetterKind.sign || l.lower.isNotEmpty) l.lower,
  }.where((u) => u.isNotEmpty).toList()
    ..sort((x, y) => y.length.compareTo(x.length));

  final lower = word.toLowerCase();
  final out = <String>[];
  var i = 0;
  while (i < lower.length) {
    String? hit;
    for (final u in units) {
      // "Ng" birikmasini so'z bo'lishda ishlatmaymiz: "bodring" → b-o-d-r-i-n-g
      if (u == 'ng') continue;
      if (lower.startsWith(u, i)) {
        hit = u;
        break;
      }
    }
    final len = hit?.length ?? 1;
    out.add(word.substring(i, i + len));
    i += len;
  }
  return out;
}

/// So'z faqat alifbo harflaridan iboratmi (bo'shliq, tire va hokazosiz).
bool isPlainWord(String word, Alphabet a) {
  final letters = {for (final l in a.letters) l.lower};
  return splitUnits(word, a).every((u) => letters.contains(u.toLowerCase()));
}
