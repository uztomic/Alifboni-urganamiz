import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/storage_service.dart';
import '../data/vocabulary_data.dart';
import 'vocabulary_event.dart';
import 'vocabulary_state.dart';

class VocabularyBloc extends Bloc<VocabularyEvent, VocabularyState> {
  final StorageService _storage;

  VocabularyBloc({StorageService? storage})
      : _storage = storage ?? StorageService.instance,
        super(const VocabularyState()) {
    on<LoadCategory>(_onLoadCategory);
    on<MarkWordPracticed>(_onMarkWordPracticed);
  }

  void _onLoadCategory(LoadCategory event, Emitter<VocabularyState> emit) {
    final category = kAllCategories.firstWhere((c) => c.id == event.id);
    final words = wordsForCategory(event.id);
    final counts = <String, int>{
      for (final w in words) w.id: _storage.timesPracticedForWord(w.id),
    };
    emit(VocabularyState(category: category, words: words, practiceCounts: counts));
  }

  Future<void> _onMarkWordPracticed(
      MarkWordPracticed event, Emitter<VocabularyState> emit) async {
    await _storage.incrementWordPracticed(event.wordId);
    final updated = Map<String, int>.from(state.practiceCounts);
    updated[event.wordId] = (updated[event.wordId] ?? 0) + 1;
    emit(state.copyWith(practiceCounts: updated));
  }
}
