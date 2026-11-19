import 'package:flutter/material.dart';

import '../../core/voice_lines.dart';
import '../../domain/entities/lesson.dart';

export '../../domain/entities/lesson.dart';

final List<LessonDef> lessons = [
  LessonDef(LessonType.intro, 'l_intro', 'abc', const Color(0xFF0E8C86), () => [
        uz('Alifbo — bu harflarning tartibli qatori.'),
        uz('Barakalla! Endi harflarni tanib olamiz.'),
      ]),
  LessonDef(LessonType.find, 'l_find', 'magnifier', const Color(0xFF2EA8FF), () => [
        uz('Endi men aytgan harfni topasan!'),
      ]),
  LessonDef(LessonType.vowels, 'l_vowels', 'speaking_head', const Color(0xFFFF6B5B), () => [
        uz('Salom! Bugun ochiq tovushlar bilan tanishamiz.'),
        uz('A, O, U, E, I, Oʻ — bular unli tovushlar.'),
        uz('Zoʻr! Endi unli harflarni topamiz.'),
      ]),
  LessonDef(LessonType.consonants, 'l_consonants', 'speech', const Color(0xFF7C5CFF), () => [
        uz('Endi undosh tovushlarni oʻrganamiz.'),
        uz('B, D, M, N, S, T — bular undosh tovushlar.'),
      ]),
  LessonDef(LessonType.bigSmall, 'l_case', 'letters', const Color(0xFFE84A8A), () => [
        uz('Har bir harfning kattasi va kichigi bor.'),
        uz('Endi katta va kichik harflarni juftlaymiz!'),
      ]),
  LessonDef(LessonType.order, 'l_order', 'locomotive', const Color(0xFFFFB627), () => [
        uz('A, B, D, E, F, G… — har bir harfning oʻz joyi bor.'),
        uz('Endi qaysi harf keyin kelishini topamiz.'),
      ]),
  LessonDef(LessonType.firstLetter, 'l_first', 'ear', const Color(0xFF3DBE6B), () => [
        uz('Har bir soʻzni ovoz chiqarib ayt va birinchi tovushga quloq sol.'),
      ]),
  LessonDef(LessonType.syllables, 'l_syllable', 'puzzle', const Color(0xFF0E8C86), () => [
        uz('Soʻzlar boʻlaklardan iborat. Ularni boʻgʻin deymiz.'),
        uz('Tingla: ol-ma. Ikki marta chapak chalamiz — ikki boʻgʻin.'),
      ]),
  LessonDef(LessonType.buildWord, 'l_word', 'brick', const Color(0xFFFF6B5B), () => [
        uz('Harflarni birlashtirsak — soʻz chiqadi.'),
        uz('Harflarni bittadan oʻqib, keyin birlashtir.'),
      ]),
  LessonDef(LessonType.read, 'l_read', 'book', const Color(0xFF2EA8FF), () => [
        uz('Endi soʻzni oʻqib, rasmini topamiz!'),
      ]),
  LessonDef(LessonType.sentence, 'l_sentence', 'memo', const Color(0xFF7C5CFF), () => [
        uz('Soʻzlar birlashsa — gap boʻladi.'),
        uz('Gap katta harf bilan boshlanadi va nuqta bilan tugaydi.'),
      ]),
  LessonDef(LessonType.write, 'l_write', 'pencil', const Color(0xFFE84A8A), () => [
        uz('Har bir harfni avval katta qilib yoz, keyin kichik.'),
        uz('Harfni yuqoridan pastga qarab yozamiz.'),
      ]),
];

final List<SentenceItem> sentences = [
  SentenceItem(uz('Gapni toʻldir: Ari ___ yigʻadi.'), 'asal', ['tosh', 'qum'], uz('Ari asal yigʻadi.')),
  SentenceItem(uz('Gapni toʻldir: Baliq ___ suzadi.'), 'suvda', ['osmonda', 'daraxtda'], uz('Baliq suvda suzadi.')),
  SentenceItem(uz('Gapni toʻldir: Biz maktabga ___ boramiz.'), 'ertalab', ['kechasi'], uz('Biz maktabga ertalab boramiz.')),
  SentenceItem(uz('Gapni toʻldir: Men har kuni tishimni ___.'), 'yuvaman', ['uchaman', 'yeyman'], uz('Men har kuni tishimni yuvaman.')),
  SentenceItem(uz('Gapni toʻldir: Qishda ___ yogʻadi.'), 'qor', ['olma', 'non'], uz('Qishda qor yogʻadi.')),
  SentenceItem(uz('Gapni toʻldir: Qush ___ uchadi.'), 'osmonda', ['suvda', 'qumda'], uz('Qush osmonda uchadi.')),
  SentenceItem(uz('Gapni toʻldir: Sigir bizga ___ beradi.'), 'sut', ['tuz', 'qum'], uz('Sigir bizga sut beradi.')),
  SentenceItem(uz('Gapni toʻldir: Ziko bozordan ___ oldi.'), 'olma', ['bulut', 'quyosh'], uz('Ziko bozordan olma oldi.')),
  SentenceItem(uz('Gapni toʻldir: Mushuk ___ ichdi.'), 'sut', ['tosh', 'qum'], uz('Mushuk sut ichdi.')),
  SentenceItem(uz('Gapni toʻldir: Ukam ___ bilan rasm chizdi.'), 'qalam', ['qoshiq', 'choynak'], uz('Ukam qalam bilan rasm chizdi.')),
  SentenceItem(uz('Gapni toʻldir: Kechasi osmonda ___ chiqadi.'), 'oy', ['quyosh', 'kamalak'], uz('Kechasi osmonda oy chiqadi.')),
  SentenceItem(uz('Gapni toʻldir: Bahorda ___ ochiladi.'), 'gullar', ['qor', 'muz'], uz('Bahorda gullar ochiladi.')),
  SentenceItem(uz('Gapni toʻldir: Quyosh ___ chiqadi.'), 'ertalab', ['kechasi', 'kechqurun'], uz('Quyosh ertalab chiqadi.')),
  SentenceItem(uz('Gapni toʻldir: Poyezd ___ yuradi.'), 'relsda', ['osmonda', 'suvda'], uz('Poyezd relsda yuradi.')),
  SentenceItem(uz('Gapni toʻldir: Qushlar ___ in quradi.'), 'daraxtga', ['suvga', 'ariqqa'], uz('Qushlar daraxtga in quradi.')),
  SentenceItem(uz('Gapni toʻldir: Buvim mazali ___ pishirdi.'), 'osh', ['qor', 'tosh']  , uz('Buvim mazali osh pishirdi.')),
];

/// Gap mashqlaridagi variantlar uchun qo'shimcha rasmlar.
const Map<String, String> sentenceEmoji = {
  'relsda': '🛤️', 'gullar': '💐', 'muz': '🧊', 'qoshiq': '🥄', 'qalam': '✏️',
  'ertalab': '🌅', 'kechasi': '🌙', 'kechqurun': '🌆', 'yuvaman': '🪥',
  'uchaman': '🕊️', 'yeyman': '🍽️', 'tuz': '🧂', 'qum': '🏖️', 'asal': '🍯',
  'sut': '🥛', 'osh': '🍛', 'tosh': '🪨', 'olma': '🍎', 'non': '🍞', 'qor': '❄️',
  'bulut': '☁️', 'quyosh': '☀️', 'oy': '🌙', 'kamalak': '🌈', 'choynak': '🫖',
  'osmonda': '🌤️', 'suvda': '🌊', 'qumda': '🏖️', 'daraxtda': '🌳',
  'daraxtga': '🌳', 'suvga': '🌊', 'ariqqa': '💧',
};
