import 'package:equatable/equatable.dart';
import '../data/models/alphabet_model.dart';

abstract class AlphabetEvent extends Equatable {
  const AlphabetEvent();
  @override
  List<Object?> get props => [];
}

class LoadAlphabet extends AlphabetEvent {
  final AlphabetId id;
  const LoadAlphabet(this.id);
  @override
  List<Object?> get props => [id];
}

class MarkLetterStars extends AlphabetEvent {
  final String letterChar;
  final int stars;
  const MarkLetterStars(this.letterChar, this.stars);
  @override
  List<Object?> get props => [letterChar, stars];
}
