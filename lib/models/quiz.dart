// lib/models/quiz.dart
import 'package:hive/hive.dart';

part 'quiz.g.dart';

@HiveType(typeId: 0)
class Quiz extends HiveObject {
  @HiveField(0)
  late String question;

  @HiveField(1)
  late List<String> options;

  @HiveField(2)
  late int correctOptionIndex;

  Quiz({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });
}
