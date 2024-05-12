// lib/providers/quiz_provider.dart
import 'package:hive/hive.dart';

import '../models/quiz.dart';

class QuizProvider {
  static Future<void> initialize() async {
    final quizBox = await Hive.openBox<Quiz>('quizzes');
    if (quizBox.isNotEmpty) {
      await quizBox.addAll([
        Quiz(
          question: "서울의 수도는?",
          options: ["Tokyo", "Beijing", "Seoul", "Bangkok"],
          correctOptionIndex: 2,
        ),
        // Add more quiz questions here
      ]);
    }
  }

  static Future<Box<Quiz>> getQuizBox() async {
    await Hive.openBox<Quiz>('quizzes');
    if (Hive.isBoxOpen('quizzes')) {
      return Hive.box<Quiz>('quizzes');
    }
    throw HiveError('Quiz box is not open');
  }

  static clearAllQuizzes() {}
}
