# Alifboni o'rganamiz 2.0

Bolalar (3–8 yosh) uchun alifbo ilovasi — Uztomic. Flutter, Android (Google Play: `uz.uztomic.alifbo`).

## Nimalar bor
- **5 alifbo:** o'zbek lotin, **yangi o'zbek alifbosi (2027, Ö Ğ Ş Ç)**, o'zbek kirill, rus, ingliz.
- **Tabiiy inson ovozi** (Ziyrak ilovasidan): 2 700+ o'zbekcha, 400+ inglizcha va ruscha yozuv. Internetsiz ishlaydi.
- **Harflar vodiysi — 12 dars** (Ziyrak "Harflar" darslari asosida): tanishuv, harfni top, unli, undosh, katta-kichik, alifbo tartibi, birinchi harf, bo'g'in, so'z yig'ish, o'qish, gap to'ldirish, harf yozish.
- **Harf yozish** — barmoq bilan (Andika savod shrifti).
- **4 o'yin:** Harf ovi (sharlar), Juftini top, Harf poyezdi, Rasmli o'yin.
- **So'zlar** — 14 bo'lim, 200+ so'z, 3 tilda (o'zbek/rus/ingliz), 3D rasmlar.
- **Bilimdon** — Ziyrak'dan 8 mavzuda savol-javob.
- **44 ertak** tabiiy ovozda.
- Ota-onalar bo'limi (tekshiruv bilan), natijalar, interfeys: o'zbek (lotin/kirill), rus, ingliz.

## Arxitektura (Clean Architecture + BLoC)
```
lib/
  core/          ovoz, reklama, tarjima, tema, yordamchilar
  domain/        entities, repositories (shartnomalar), services (dars mexanizmi)
  data/          content (alifbo, so'zlar, darslar...), sources (Hive), repositories
  presentation/  bloc (Cubit'lar), screens, widgets
```

## Ovoz qo'shish
Ovoz fayli nomi — matnning FNV-1a xeshi. Kontentda ovozi yo'q matnlarni tekshirish va yangi
ovoz qo'shish:
```
python3 tools/voice_tool.py check
python3 tools/voice_tool.py add uz "Matn aynan shunday" yozuv.mp3
```

## Yig'ish
```
flutter pub get
flutter build appbundle --release
```
`android/key.properties` va upload keystore kerak (repo'da yo'q).

3D rasmlar: Microsoft Fluent Emoji (MIT). Ziko maskoti, ovozlar va ertaklar — Ziyrak (Uztomic).
