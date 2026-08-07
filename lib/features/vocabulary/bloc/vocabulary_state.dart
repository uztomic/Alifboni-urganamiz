import 'package:equatable/equatable.dart';
import '../data/models/category_model.dart';
import '../data/models/word_model.dart';

class VocabularyState extends Equatable {
  final CategoryModel? category;
  final List<WordModel> words;
  final Map<String, int> practiceCounts;

  const VocabularyState({
    this.category,
    this.words = const [],
    this.practiceCounts = const {},
  });

  int get learnedCount =>
      practiceCounts.values.where((c) => c > 0).length;
  int get totalCount => words.length;

  VocabularyState copyWith({
    CategoryModel? category,
    List<WordModel>? words,
    Map<String, int>? practiceCounts,
  }) {
    return VocabularyState(
      category: category ?? this.category,
      words: words ?? this.words,
      practiceCounts: practiceCounts ?? this.practiceCounts,
    );
  }

  @override
  List<Object?> get props => [category?.id, words, practiceCounts];
}
