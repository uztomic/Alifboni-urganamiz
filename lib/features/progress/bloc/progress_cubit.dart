import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/storage_service.dart';
import 'progress_state.dart';

/// Tracks the daily "streak" (olov) counter described in TZ 4.3.
class ProgressCubit extends Cubit<ProgressState> {
  final StorageService _storage;

  ProgressCubit({StorageService? storage})
      : _storage = storage ?? StorageService.instance,
        super(ProgressState(streak: (storage ?? StorageService.instance).streakCount));

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  /// Call whenever the child completes any exercise (letter, quiz, flashcard).
  Future<void> recordPractice() async {
    final today = _isoDate(DateTime.now());
    final last = _storage.lastPracticedDate;

    if (last == today) return; // already counted today

    int newStreak;
    if (last == null) {
      newStreak = 1;
    } else {
      final yesterday = _isoDate(DateTime.now().subtract(const Duration(days: 1)));
      newStreak = last == yesterday ? _storage.streakCount + 1 : 1;
    }

    await _storage.setStreakCount(newStreak);
    await _storage.setLastPracticedDate(today);
    emit(state.copyWith(streak: newStreak));
  }
}
