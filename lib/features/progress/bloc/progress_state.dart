import 'package:equatable/equatable.dart';

class ProgressState extends Equatable {
  final int streak;

  const ProgressState({this.streak = 0});

  ProgressState copyWith({int? streak}) => ProgressState(streak: streak ?? this.streak);

  @override
  List<Object?> get props => [streak];
}
