import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'models/category_model.dart';
import 'models/word_model.dart';

final List<CategoryModel> kAllCategories = [
  const CategoryModel(id: VocabCategoryId.animals, emoji: '🦁', color: AppColors.green),
  const CategoryModel(id: VocabCategoryId.colors, emoji: '🎨', color: AppColors.pink),
  const CategoryModel(id: VocabCategoryId.numbers, emoji: '🔢', color: AppColors.blue),
  const CategoryModel(
    id: VocabCategoryId.family,
    emoji: '👨‍👩‍👧‍👦',
    color: AppColors.yellow,
    requiresUnlock: true,
  ),
  const CategoryModel(
    id: VocabCategoryId.food,
    emoji: '🍉',
    color: AppColors.primary,
    requiresUnlock: true,
  ),
  const CategoryModel(id: VocabCategoryId.clothes, emoji: '👕', color: AppColors.purple, available: false),
  const CategoryModel(id: VocabCategoryId.transport, emoji: '🚗', color: AppColors.secondary, available: false),
  const CategoryModel(id: VocabCategoryId.nature, emoji: '🌳', color: AppColors.green, available: false),
];

WordModel _w(
  String id,
  VocabCategoryId cat,
  String emoji,
  String uzLatin,
  String english,
  String uz,
  String ru,
  String en, {
  Color? swatch,
}) {
  return WordModel(
    id: id,
    category: cat,
    emoji: emoji,
    swatchColor: swatch,
    spellings: {'uzLatin': uzLatin, 'english': english},
    translations: {'uz': uz, 'ru': ru, 'en': en},
  );
}

final List<WordModel> kAnimalWords = [
  _w('animal_lion', VocabCategoryId.animals, '🦁', 'Sher', 'Lion', 'Sher', 'Лев', 'Lion'),
  _w('animal_elephant', VocabCategoryId.animals, '🐘', 'Fil', 'Elephant', 'Fil', 'Слон', 'Elephant'),
  _w('animal_cat', VocabCategoryId.animals, '🐱', 'Mushuk', 'Cat', 'Mushuk', 'Кот', 'Cat'),
  _w('animal_dog', VocabCategoryId.animals, '🐶', 'It', 'Dog', 'It', 'Собака', 'Dog'),
  _w('animal_fish', VocabCategoryId.animals, '🐟', 'Baliq', 'Fish', 'Baliq', 'Рыба', 'Fish'),
  _w('animal_bird', VocabCategoryId.animals, '🐦', 'Qush', 'Bird', 'Qush', 'Птица', 'Bird'),
  _w('animal_rabbit', VocabCategoryId.animals, '🐰', 'Quyon', 'Rabbit', 'Quyon', 'Заяц', 'Rabbit'),
  _w('animal_bear', VocabCategoryId.animals, '🐻', 'Ayiq', 'Bear', 'Ayiq', 'Медведь', 'Bear'),
  _w('animal_fox', VocabCategoryId.animals, '🦊', 'Tulki', 'Fox', 'Tulki', 'Лиса', 'Fox'),
  _w('animal_wolf', VocabCategoryId.animals, '🐺', "Boʻri", 'Wolf', "Boʻri", 'Волк', 'Wolf'),
  _w('animal_horse', VocabCategoryId.animals, '🐴', 'Ot', 'Horse', 'Ot', 'Лошадь', 'Horse'),
  _w('animal_cow', VocabCategoryId.animals, '🐄', 'Sigir', 'Cow', 'Sigir', 'Корова', 'Cow'),
  _w('animal_sheep', VocabCategoryId.animals, '🐑', "Qoʻy", 'Sheep', "Qoʻy", 'Овца', 'Sheep'),
  _w('animal_duck', VocabCategoryId.animals, '🦆', 'Ordak', 'Duck', 'Ordak', 'Утка', 'Duck'),
  _w('animal_tiger', VocabCategoryId.animals, '🐯', "Yoʻlbars", 'Tiger', "Yoʻlbars", 'Тигр', 'Tiger'),
];

final List<WordModel> kColorWords = [
  _w('color_red', VocabCategoryId.colors, '🔴', 'Qizil', 'Red', 'Qizil', 'Красный', 'Red', swatch: const Color(0xFFE53935)),
  _w('color_orange', VocabCategoryId.colors, '🟠', "Toʻq sariq", 'Orange', "Toʻq sariq", 'Оранжевый', 'Orange', swatch: const Color(0xFFFB8C00)),
  _w('color_yellow', VocabCategoryId.colors, '🟡', 'Sariq', 'Yellow', 'Sariq', 'Жёлтый', 'Yellow', swatch: const Color(0xFFFDD835)),
  _w('color_green', VocabCategoryId.colors, '🟢', 'Yashil', 'Green', 'Yashil', 'Зелёный', 'Green', swatch: const Color(0xFF43A047)),
  _w('color_blue', VocabCategoryId.colors, '🔵', "Koʻk", 'Blue', "Koʻk", 'Синий', 'Blue', swatch: const Color(0xFF1E88E5)),
  _w('color_lightblue', VocabCategoryId.colors, '🩵', 'Zangori', 'Light blue', 'Zangori', 'Голубой', 'Light blue', swatch: const Color(0xFF4FC3F7)),
  _w('color_purple', VocabCategoryId.colors, '🟣', 'Binafsha', 'Purple', 'Binafsha', 'Фиолетовый', 'Purple', swatch: const Color(0xFF8E24AA)),
  _w('color_pink', VocabCategoryId.colors, '🩷', 'Pushti', 'Pink', 'Pushti', 'Розовый', 'Pink', swatch: const Color(0xFFEC407A)),
  _w('color_brown', VocabCategoryId.colors, '🟤', 'Jigarrang', 'Brown', 'Jigarrang', 'Коричневый', 'Brown', swatch: const Color(0xFF6D4C41)),
  _w('color_black', VocabCategoryId.colors, '⚫', 'Qora', 'Black', 'Qora', 'Чёрный', 'Black', swatch: const Color(0xFF212121)),
  _w('color_white', VocabCategoryId.colors, '⚪', 'Oq', 'White', 'Oq', 'Белый', 'White', swatch: const Color(0xFFFAFAFA)),
  _w('color_gray', VocabCategoryId.colors, '🩶', 'Kulrang', 'Gray', 'Kulrang', 'Серый', 'Gray', swatch: const Color(0xFF9E9E9E)),
];

const _numberEmoji = [
  '1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '🔟'
];
const _numberUz = [
  'Bir', 'Ikki', 'Uch', "Toʻrt", 'Besh', 'Olti', 'Yetti', 'Sakkiz', "Toʻqqiz", "Oʻn"
];
const _numberEn = [
  'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten'
];
const _numberRu = [
  'Один', 'Два', 'Три', 'Четыре', 'Пять', 'Шесть', 'Семь', 'Восемь', 'Девять', 'Десять'
];

final List<WordModel> kNumberWords = List.generate(10, (i) {
  return _w(
    'number_${i + 1}',
    VocabCategoryId.numbers,
    _numberEmoji[i],
    _numberUz[i],
    _numberEn[i],
    _numberUz[i],
    _numberRu[i],
    _numberEn[i],
  );
});

final List<WordModel> kFamilyWords = [
  _w('family_father', VocabCategoryId.family, '👨', 'Ota', 'Father', 'Ota', 'Отец', 'Father'),
  _w('family_mother', VocabCategoryId.family, '👩', 'Ona', 'Mother', 'Ona', 'Мать', 'Mother'),
  _w('family_grandmother', VocabCategoryId.family, '👵', 'Buvi', 'Grandmother', 'Buvi', 'Бабушка', 'Grandmother'),
  _w('family_grandfather', VocabCategoryId.family, '👴', 'Bobo', 'Grandfather', 'Bobo', 'Дедушка', 'Grandfather'),
  _w('family_brother', VocabCategoryId.family, '👦', 'Aka', 'Brother', 'Aka', 'Брат', 'Brother'),
  _w('family_sister', VocabCategoryId.family, '👧', 'Opa', 'Sister', 'Opa', 'Сестра', 'Sister'),
  _w('family_son', VocabCategoryId.family, '🧒', "Oʻgʻil", 'Son', "Oʻgʻil", 'Сын', 'Son'),
  _w('family_daughter', VocabCategoryId.family, '👧', 'Qiz', 'Daughter', 'Qiz', 'Дочь', 'Daughter'),
  _w('family_baby', VocabCategoryId.family, '👶', 'Chaqaloq', 'Baby', 'Chaqaloq', 'Малыш', 'Baby'),
  _w('family_family', VocabCategoryId.family, '👨‍👩‍👧‍👦', 'Oila', 'Family', 'Oila', 'Семья', 'Family'),
];

final List<WordModel> kFoodWords = [
  _w('food_bread', VocabCategoryId.food, '🍞', 'Non', 'Bread', 'Non', 'Хлеб', 'Bread'),
  _w('food_milk', VocabCategoryId.food, '🥛', 'Sut', 'Milk', 'Sut', 'Молоко', 'Milk'),
  _w('food_egg', VocabCategoryId.food, '🥚', 'Tuxum', 'Egg', 'Tuxum', 'Яйцо', 'Egg'),
  _w('food_carrot', VocabCategoryId.food, '🥕', 'Sabzi', 'Carrot', 'Sabzi', 'Морковь', 'Carrot'),
  _w('food_potato', VocabCategoryId.food, '🥔', 'Kartoshka', 'Potato', 'Kartoshka', 'Картофель', 'Potato'),
  _w('food_meat', VocabCategoryId.food, '🍖', "Goʻsht", 'Meat', "Goʻsht", 'Мясо', 'Meat'),
  _w('food_soup', VocabCategoryId.food, '🍲', "Shoʻrva", 'Soup', "Shoʻrva", 'Суп', 'Soup'),
  _w('food_tomato', VocabCategoryId.food, '🍅', 'Pomidor', 'Tomato', 'Pomidor', 'Помидор', 'Tomato'),
  _w('food_honey', VocabCategoryId.food, '🍯', 'Asal', 'Honey', 'Asal', 'Мёд', 'Honey'),
  _w('food_tea', VocabCategoryId.food, '🍵', 'Choy', 'Tea', 'Choy', 'Чай', 'Tea'),
];

final Map<VocabCategoryId, List<WordModel>> kWordsByCategory = {
  VocabCategoryId.animals: kAnimalWords,
  VocabCategoryId.colors: kColorWords,
  VocabCategoryId.numbers: kNumberWords,
  VocabCategoryId.family: kFamilyWords,
  VocabCategoryId.food: kFoodWords,
};

List<WordModel> wordsForCategory(VocabCategoryId id) =>
    kWordsByCategory[id] ?? const [];
