import 'package:flutter/material.dart';

enum VocabCategoryId {
  animals,
  colors,
  numbers,
  family,
  food,
  clothes,
  transport,
  nature,
}

class CategoryModel {
  final VocabCategoryId id;
  final String emoji;
  final Color color;

  /// Whether this category has real word content at all. Categories
  /// without content yet (no [available]) show as "coming soon" and are
  /// never tappable, regardless of [requiresUnlock].
  final bool available;

  /// Whether this category must be unlocked with a rewarded ad before its
  /// flashcards can be opened (see TZ 8.2 "Rewarded Ad" placement). Only
  /// meaningful when [available] is true.
  final bool requiresUnlock;

  const CategoryModel({
    required this.id,
    required this.emoji,
    required this.color,
    this.available = true,
    this.requiresUnlock = false,
  });
}
