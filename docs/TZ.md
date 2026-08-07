# TEXNIK TOPSHIRIQ (TZ)
## "Alifbo & Lug'at" — Ko'p tilli, ko'p alifboli bolalar ta'lim ilovasi

**Platforma:** Android (Google Play), Flutter
**Versiya:** 1.1 (qarorlar bilan yangilangan)
**Sana:** 2026-yil 17-iyul

> Ushbu hujjat 1.0 qoralamasi asosida, loyiha egasi bilan kelishilgan qarorlar (quyida "0. QARORLAR" bo'limida) qo'shilib yangilandi.

---

## 0. QARORLAR (2026-07-17 holatiga ko'ra)

Ilgari "Ochiq savollar" bo'limida qoldirilgan masalalar bo'yicha qabul qilingan qarorlar:

| # | Savol | Qaror |
|---|---|---|
| 1 | 10 ta interfeys tili ro'yxati | Taklif qilingan ro'yxat tasdiqlandi (3.1-bo'limga qarang) |
| 2 | 6 ta alifbo ro'yxati | O'zbek kirill **Koreys alifbosi** bilan almashtirildi (3.2-bo'limga qarang); lug'at moduli ham shunga mos yangilanadi |
| 3 | Stiker rasmlar manbai | MVP bosqichida **placeholder/oddiy ikonkalar** (Flutter Icons yoki oddiy shakllar) ishlatiladi, keyinchalik original stikerlar bilan almashtiriladi |
| 4 | Premium (reklamasiz) versiya | **Yo'q** — hozircha faqat AdMob orqali monetizatsiya, Premium keyingi bosqichlarda ko'rib chiqiladi |
| 5 | iOS versiyasi | **Yo'q** — loyiha faqat Android uchun optimallashtiriladi, cross-platform arxitekturaga alohida vaqt sarflanmaydi |

---

## 1. LOYIHA HAQIDA UMUMIY MA'LUMOT

Ilova bolalarga (va boshlang'ich til o'rganuvchilarga) turli alifbolarni va so'z boyligini (lug'atni) uchta usulda o'rgatadi:

- **Eshitib** (audio orqali tovush/talaffuz)
- **Ko'rib** (rasm/stiker + harf/so'z vizual bog'lanishi)
- **Chizib** (barmoq bilan ekranda harfni/so'zni yozish — trace mashqi)

Ilova interfeysi **10 ta tilda** ishlaydi, foydalanuvchi istalgan interfeys tilidan turib, istalgan **6 ta alifbo/til** ni o'rganishi mumkin. Ya'ni til va o'rganiladigan alifbo bir-biridan mustaqil tanlanadi (masalan: interfeys — rus tilida, o'rganilayotgan alifbo — arab).

### 1.1 Asosiy modullar
1. **Alifbo moduli** — harflarni eshitib/ko'rib/chizib o'rganish
2. **Lug'at (Vocabulary) moduli** — so'zlarni eshitib va ko'rib yodlash (kategoriyalar bo'yicha: hayvonlar, ranglar, sonlar, oila, ovqatlar va h.k.)

---

## 2. MAQSADLI AUDITORIYA

- Asosiy: 3–8 yosh bolalar
- Ikkilamchi: ota-onalar (ular ilovani yuklab oladi, sozlaydi, progress kuzatadi)
- Kengroq: kattalar til o'rganuvchilar (bonus auditoriya, alifbo moduli ular uchun ham foydali)

---

## 3. TILLAR VA ALIFBOLAR

### 3.1 Interfeys tillari (10 ta) — TASDIQLANGAN
O'zbek (lotin), O'zbek (kirill), Rus, Ingliz, Arab, Turk, Qozoq, Tojik, Qirg'iz, Fransuz

### 3.2 O'rganiladigan alifbolar (6 ta) — TASDIQLANGAN
| # | Alifbo | Izoh |
|---|--------|------|
| 1 | O'zbek lotin | Mahalliy asosiy |
| 2 | Koreys (Hangul) | O'zbek kirill o'rniga tanlandi |
| 3 | Rus (kirill) | Mintaqaviy keng tarqalgan |
| 4 | Ingliz (lotin/ABC) | Global eng katta talab |
| 5 | Arab | Diniy va lingvistik ahamiyat, katta auditoriya |
| 6 | Turk | Yaqin til, o'xshash lotin yozuvi |

Har bir alifbo modul sifatida qurilib, kelajakda osongina yangi alifbo (masalan fors, xitoy pinyin) qo'shish mumkin bo'lishi kerak (**plagin-style module architecture**).

---

## 4. FUNKSIONAL TALABLAR

### 4.1 Alifbo moduli

**Ekran oqimi:**
1. Alifbo tanlash ekrani (6 ta karta, har biri milliy bayroq/rang bilan belgilangan)
2. Harflar ro'yxati (grid, har harf — katta, rangli tugma)
3. Harf batafsil ekrani:
   - Katta stiker-uslubidagi rasm (masalan "A" — olma stikeri; MVP bosqichida placeholder ikonka)
   - Harfni bosganda tovushi eshitiladi
   - "Eshitish" tugmasi (qayta tinglash)
   - "Chizish" rejimi — barmoq bilan harf konturini chizish (trace), muvaffaqiyatli chizilganda animatsiya + tabriklovchi ovoz
   - "Ko'rish" rejimi — harf + unga bog'liq bir nechta so'z/rasm (masalan "A" — Anor, Ari, Ayiq)
4. Mini-viktorina — "to'g'ri harfni top" (audio eshittirib, 3-4 variantdan tanlash)
5. Yakunda yulduzcha/status belgilanadi

**Talablar:**
- Har harf uchun: 1 ta audio fayl (yoki TTS orqali generatsiya), 1 ta stiker-rasm (MVP: placeholder ikonka), trace uchun SVG path
- Progress har alifbo bo'yicha alohida saqlanadi (masalan "Koreys alifbosi: 15/24 o'rganildi")

### 4.2 Lug'at (Vocabulary) moduli

**Kategoriyalar (MVP uchun taklif):** Hayvonlar, Ranglar, Sonlar (1-10), Oila a'zolari, Ovqatlar, Kiyimlar, Transport, Tabiat

**Ekran oqimi:**
1. Kategoriya tanlash (rangli kartochkalar, stiker ikonkalari bilan)
2. So'z kartochkasi (flashcard uslubi):
   - Katta stiker-rasm (MVP: placeholder ikonka)
   - So'z (tanlangan alifboda yozilgan) + tarjimasi (interfeys tilida)
   - Ovoz tugmasi — so'zning to'g'ri talaffuzi
   - Svayp qilib keyingi so'zga o'tish
3. "Yozib ko'rish" rejimi — so'zni ekranda barmoq bilan chizish/yozish
4. Eslab qolish testi — rasmga qarab to'g'ri so'zni tanlash (multiple choice) yoki eshitib to'g'ri rasmni tanlash

**Talablar:**
- Har so'z: kategoriya, 6 ta alifboda yozilishi (agar tegishli bo'lsa, shu jumladan Koreys), 10 ta tilda tarjimasi, audio, stiker-rasm
- Boshlang'ich MVP uchun: har kategoriyada 15-20 so'z (jami ~120-150 so'z) yetarli, keyin kengaytiriladi

### 4.3 Umumiy funksiyalar
- **Streak tizimi** — har kuni kamida bitta mashq bajarilsa, "olov" hisoblagichi oshadi
- **Bildirishnomalar** — "Bugun hali mashq qilmadingiz!" (mahalliy push notification, server shart emas)
- **Ota-ona zonasi** — PIN bilan himoyalangan, bu yerda progress statistikasi, sozlamalar, reklama sozlamalari
- **Ovoz balandligi/tezligi sozlamasi**
- **Offline rejim** — barcha kontent ilova ichida (yoki birinchi ishga tushirishda yuklab olinadi), internet bo'lmasa ham ishlaydi (faqat reklama uchun internet kerak)

---

## 5. KONTENT VA MA'LUMOTLAR MANBAI

### 5.1 Nega tayyor online lug'at API mos kelmaydi
Bepul ko'p tilli lug'at API'lari (masalan Wiktionary asosidagi freedictionaryapi.com, yoki Lexicala) mavjud, lekin ular asosan yirik tillar (ingliz, fransuz, nemis va h.k.) uchun sifatli, o'zbek/qirg'iz/tojik/koreys kabi tillar uchun esa juda kambag'al yoki umuman yo'q. Bolalar ilovasi uchun bunday xom, tekshirilmagan ma'lumot ishlatish xavfli (noto'g'ri tarjima/talaffuz bolaga singib qolishi mumkin).

### 5.2 Tavsiya etilgan yondashuv — o'z kurativ dataseti
1. **JSON formatida markazlashgan lug'at bazasi** yarating (masalan `words.json`), har yozuv:
```json
{
  "id": "animal_001",
  "category": "animals",
  "image": "sticker_lion.png",
  "words": {
    "uz_latin": "Sher", "ko": "사자", "ru": "Лев",
    "en": "Lion", "ar": "أسد", "tr": "Aslan"
  },
  "translations": {
    "uz": "Sher", "ru": "Лев", "en": "Lion", "kk": "Арыстан", ...
  },
  "audio": { "uz": "audio/uz/lion.mp3", "en": "audio/en/lion.mp3", ... }
}
```
2. Boshlang'ich tarjimalarni tayyorlashda **Google Translate API** yoki **DeepL API** dan qoralama sifatida foydalanish, so'ng **ona tilli inson tomonidan tekshiruv** (bu bolalar kontenti uchun majburiy bosqich — noto'g'ri tarjima ishonchni yo'qotadi)
3. **Audio uchun TTS (Text-to-Speech)**: Google Cloud TTS yoki Microsoft Azure TTS — ko'p tilni (jumladan koreys) qamrab oladi, arzon (bir martalik generatsiya, keyin fayllar ilova ichida saqlanadi, real-time API chaqiruv shart emas). Bolalar uchun "child-friendly" ovoz tanlash kerak.
4. **Rasmlar (stikerlar)**: MVP bosqichida placeholder/oddiy ikonkalar (Flutter Icons yoki oddiy shakllar) ishlatiladi. Keyingi bosqichda tayyor stiker to'plamlari (masalan Flaticon/Freepik Premium) yoki maxsus dizayner bilan chizdirilgan izchil uslubdagi stikerlar bilan almashtiriladi.

### 5.3 Alfavitlar uchun manba
Har alifbo harflari, tartibi va Unicode kodlari uchun **Unicode CLDR (Common Locale Data Repository)** dan foydalanish mumkin — bu ochiq va ishonchli standart manba. Koreys alifbosi (Hangul) uchun 24 ta asosiy harf (jamo) — 14 undosh + 10 unli — asos qilib olinadi.

---

## 6. TEXNIK ARXITEKTURA

### 6.1 Stack
- **Framework:** Flutter (Dart), faqat Android nishonlanadi
- **State Management:** BLoC (flutter_bloc + bloc paketlari)
- **Lokal ma'lumotlar bazasi:** Hive yoki SQLite (drift) — progress, sozlamalar va offline lug'at kontenti uchun
- **Audio:** just_audio yoki audioplayers paketi
- **Trace/chizish:** custom CustomPainter + GestureDetector (harf konturi ustida chizish aniqligini tekshirish)
- **Reklama:** google_mobile_ads (AdMob rasmiy Flutter plagini)
- **Bildirishnoma:** flutter_local_notifications
- **Lokalizatsiya:** flutter_localizations + intl (10 tilli interfeys uchun ARB fayllar)

### 6.2 BLoC arxitekturasi (taklif qilingan modul tuzilishi)
```
lib/
 ├── core/
 │    ├── theme/
 │    ├── constants/
 │    └── services/ (audio_service, ads_service, storage_service, tts_cache)
 ├── features/
 │    ├── alphabet/
 │    │    ├── bloc/ (alphabet_bloc, alphabet_event, alphabet_state)
 │    │    ├── data/ (repository, models)
 │    │    └── presentation/ (screens, widgets)
 │    ├── vocabulary/
 │    │    ├── bloc/
 │    │    ├── data/
 │    │    └── presentation/
 │    ├── progress/ (streak, statistika BLoC)
 │    ├── settings/ (til, ota-ona zonasi BLoC)
 │    └── onboarding/
 ├── l10n/ (10 ta .arb fayl)
 └── main.dart
```

Har bir BLoC alohida modulga tegishli holatni boshqaradi (masalan `AlphabetBloc` — tanlangan alifbo, harf progress; `VocabularyBloc` — tanlangan kategoriya, kartochka holati; `AudioPlaybackBloc` — global audio holati).

### 6.3 Ma'lumotlar oqimi
- Ilova birinchi ishga tushganda: barcha statik kontent (JSON + rasm + audio) assets ichida keladi (APK hajmini oshiradi, lekin to'liq offline ishlaydi) **YOKI** birinchi ochilishda serverdan (Firebase Storage) yuklab olinadi (APK yengil bo'ladi, lekin internet talab qiladi)
- Tavsiya: **MVP uchun assets ichida** (oddiyroq, tezroq ishlab chiqish), keyingi versiyada Firebase Remote Content'ga o'tish (yangi so'z/alifbo qo'shishni ilova yangilanishisiz qilish imkonini beradi)

---

## 7. DIZAYN TALABLARI (UI/UX)

### 7.1 Umumiy uslub
- **Yorqin, quvnoq rang palitrasi** — asosiy fon och ranglarda (pastel), tugmalar to'yingan/quvnoq ranglarda (sariq, ko'k, pushti, yashil)
- **Yumaloq, yumshoq shakllar** — keskin burchaklardan qochish (bolalar uchun xavfsiz va do'stona ko'rinish)
- **Katta tugmalar** — barmoq bilan bosish uchun kamida 60x60dp, bolalar mo'ljal olishi oson bo'lishi kerak
- **Minimal matn** — bolalar hali o'qishni bilmasligi mumkin, shuning uchun ikonka/rasm asosiy, matn qo'shimcha
- **Maskot xarakter** — ilova bo'ylab kuzatib yuruvchi do'stona qahramon (masalan kichik ayiqcha yoki qush), tabriklaydi, yo'l ko'rsatadi — bolalar ilovalarida retentionni sezilarli oshiradi

### 7.2 Stikerlar (rasmlar)
- **MVP bosqichida:** placeholder/oddiy ikonkalar (Flutter Icons yoki oddiy geometrik shakllar) ishlatiladi
- Keyingi bosqichda har bir harf/so'z uchun rasm **flat-style yoki 3D "sticker" uslubida** bo'lishi kerak: oq/rangli konturli chekka (die-cut sticker effekti), soyalar bilan yengil hajm beriladi
- Stiker bosilganda **kattalashtirish animatsiyasi** (scale + bounce effekt) — masalan Flutter'da `AnimatedScale` yoki `Hero` animation bilan amalga oshiriladi
- Barcha stikerlar **bitta dizayner/bitta uslubda** yaratilishi shart (izchillik uchun) — turli manbalardan aralash uslubdagi rasmlar ilovani "arzon" ko'rsatadi

### 7.3 Shrift
- Bolalar uchun mo'ljallangan, dumaloq, o'qilishi oson shrift (masalan "Baloo 2", "Fredoka", yoki "Nunito") — lotin, kirill, arab **va koreys (Hangul)** yozuvini qo'llab-quvvatlaydigan shrift tanlash muhim (arab uchun alohida shrift kerak bo'lishi mumkin, masalan "Lalezar" yoki "Cairo"; koreys uchun "Noto Sans KR" kabi shrift)

### 7.4 Ovoz dizayni
- Har bir muvaffaqiyatli harakatda (to'g'ri javob, harf chizib bo'lgach) qisqa, quvnoq ovoz effekti
- Fon musiqasi — o'chirib qo'yish imkoniyati bilan, juda zerikarli bo'lmasligi kerak

---

## 8. MONETIZATSIYA (ADMOB)

### 8.1 Muhim: bolalar siyosati
Ilova bolalarga mo'ljallangan bo'lgani uchun, Google Play **Families siyosati** va AdMob'ning **"Ads for children" (COPPA)** talablariga qat'iy rioya qilish shart:
- AdMob konsolida ilova "Child-directed" deb belgilanishi kerak
- Faqat bolalar uchun mos (non-personalized yoki maxsus sertifikatlangan) reklama tarmog'idan foydalanish
- Reklama tarkibi filtrlanishi kerak (zo'ravonlik, kattalar mahsulotlari reklamasi taqiqlanadi)
- Bunga rioya qilinmasa, ilova Google Play'dan olib tashlanishi yoki akkaunt bloklanishi mumkin

### 8.2 Reklama joylashuvi
| Joy | Reklama turi | Izoh |
|-----|--------------|------|
| Ota-ona zonasiga kirish oldidan | Interstitial | Bolalar o'yin paytida to'satdan chiqmaydi |
| Kategoriya/alifbo tugagach | Interstitial (kamdan-kam, masalan har 3-sikldan keyin) | Progress buzilmasligi uchun ehtiyotkorlik |
| Qo'shimcha kontent ochish (masalan yangi alifbo/kategoriya) | Rewarded Ad | "Video ko'rib, yangi bo'limni oching" — eng yuqori CPM, foydalanuvchi tajribasiga eng kam ta'sir |
| Bosh ekran pastida | Banner (ixtiyoriy) | Past daromad, lekin doimiy — bolalar ilovasida hatto banner ham juda kam va katta bo'lmasligi kerak |

### 8.3 Premium versiya
**Qaror:** Hozircha Premium versiya qo'shilmaydi — monetizatsiya faqat AdMob orqali amalga oshiriladi. Kelajakda (talab bo'lsa) freemium modelga qaytish mumkin.

---

## 9. MA'LUMOTLAR BAZASI TUZILISHI (LOKAL)

**Jadval: `progress`**
| Maydon | Tur | Izoh |
|---|---|---|
| alphabet_id | string | qaysi alifbo |
| letter_id | string | qaysi harf |
| status | enum | not_started / learning / mastered |
| stars | int | 0-3 |
| last_practiced | datetime | |

**Jadval: `vocabulary_progress`**
| word_id | string |
| category | string |
| status | enum |
| times_practiced | int |

**Jadval: `settings`**
| interface_language | string |
| child_lock_pin | string (hashed) |
| sound_enabled | bool |
| notification_time | time |

---

## 10. NO-FUNKSIONAL TALABLAR

- APK hajmi: MVP uchun 80-150MB oralig'ida saqlashga harakat qilish (audio/rasm siqilgan formatda: webp rasm, aac/mp3 audio)
- Ishga tushish vaqti: 2 soniyadan kam
- Barcha ekranlar bolalar tomonidan **ota-onasiz** mustaqil foydalanish mumkin bo'lishi kerak (matn minimal, navigatsiya intuitiv)
- Android minimal versiya: API 21+ (Android 5.0), keng qamrov uchun
- To'liq offline ishlash (reklama bundan mustasno)
- iOS versiyasi rejalashtirilmagan — faqat Android uchun optimallashtirish yetarli

---

## 11. MVP BOSQICHLARI (ROADMAP)

**1-bosqich (MVP — taklif 6-8 hafta):**
- 2 ta alifbo (masalan O'zbek lotin + Ingliz)
- 3 ta lug'at kategoriyasi (Hayvonlar, Ranglar, Sonlar)
- 3 ta interfeys tili (O'zbek, Rus, Ingliz)
- Placeholder ikonkalar (real stikerlar keyinroq)
- Asosiy funksiyalar: eshitish, ko'rish, chizish, mini-viktorina, streak, AdMob (Rewarded + Interstitial)

**2-bosqich:**
- Qolgan 4 ta alifbo qo'shiladi (Koreys, Rus, Arab, Turk)
- Qolgan 7 ta interfeys tili qo'shiladi
- Qolgan kategoriyalar (Oila, Ovqatlar, Kiyimlar, Transport, Tabiat)
- Ota-ona statistika paneli
- Placeholder ikonkalar real stikerlar bilan almashtiriladi

**3-bosqich:**
- Yangi kontentni serverdan dinamik yuklash (Firebase Remote Config/Storage)
- Ko'proq mini-o'yinlar, badge/yutuqlar tizimi
- Premium (reklamasiz) versiya masalasi qayta ko'rib chiqiladi
