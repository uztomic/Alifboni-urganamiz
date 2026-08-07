import 'package:equatable/equatable.dart';
import '../data/models/category_model.dart';

abstract class VocabularyEvent extends Equatable {
  const VocabularyEvent();
  @override
  List<Object?> get props => [];
}

class LoadCategory extends VocabularyEvent {
  final VocabCategoryId id;
  const LoadCategory(this.id);
  @override
  List<Object?> get props => [id];
}

class MarkWordPracticed extends VocabularyEvent {
  final String wordId;
  const MarkWordPracticed(this.wordId);
  @override
  List<Object?> get props => [wordId];
}
