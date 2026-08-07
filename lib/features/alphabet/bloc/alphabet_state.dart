import 'package:equatable/equatable.dart';
import '../data/models/alphabet_model.dart';

class AlphabetState extends Equatable {
  final AlphabetModel? alphabet;
  final Map<String, int> stars;

  const AlphabetState({this.alphabet, this.stars = const {}});

  int get learnedCount => stars.values.where((s) => s > 0).length;
  int get totalCount => alphabet?.letters.length ?? 0;

  AlphabetState copyWith({AlphabetModel? alphabet, Map<String, int>? stars}) {
    return AlphabetState(
      alphabet: alphabet ?? this.alphabet,
      stars: stars ?? this.stars,
    );
  }

  @override
  List<Object?> get props => [alphabet?.id, stars];
}
