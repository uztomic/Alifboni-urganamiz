import 'package:flutter/material.dart';

/// "Bilimdon" savoli: savol va variantlar tabiiy ovozda o'qiladi.
class QuizItem {
  const QuizItem(this.question, this.answer, this.wrong);
  final String question;
  final String answer;
  final List<String> wrong;
}

class QuizTopic {
  const QuizTopic(this.id, this.icon, this.color, this.items);
  final String id; // matn kaliti
  final String icon;
  final Color color;
  final List<QuizItem> items;
}

