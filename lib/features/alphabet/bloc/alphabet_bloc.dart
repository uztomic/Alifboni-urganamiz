import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/storage_service.dart';
import '../data/alphabet_data.dart';
import 'alphabet_event.dart';
import 'alphabet_state.dart';

class AlphabetBloc extends Bloc<AlphabetEvent, AlphabetState> {
  final StorageService _storage;

  AlphabetBloc({StorageService? storage})
      : _storage = storage ?? StorageService.instance,
        super(const AlphabetState()) {
    on<LoadAlphabet>(_onLoadAlphabet);
    on<MarkLetterStars>(_onMarkLetterStars);
  }

  void _onLoadAlphabet(LoadAlphabet event, Emitter<AlphabetState> emit) {
    final alphabet = alphabetById(event.id);
    final stars = <String, int>{
      for (final letter in alphabet.letters)
        letter.character: _storage.starsForLetter(alphabet.id.name, letter.character),
    };
    emit(AlphabetState(alphabet: alphabet, stars: stars));
  }

  Future<void> _onMarkLetterStars(
      MarkLetterStars event, Emitter<AlphabetState> emit) async {
    final alphabet = state.alphabet;
    if (alphabet == null) return;
    await _storage.setStarsForLetter(alphabet.id.name, event.letterChar, event.stars);
    final current = state.stars[event.letterChar] ?? 0;
    final newStars = event.stars > current ? event.stars : current;
    final updated = Map<String, int>.from(state.stars)
      ..[event.letterChar] = newStars;
    emit(state.copyWith(stars: updated));
  }
}
