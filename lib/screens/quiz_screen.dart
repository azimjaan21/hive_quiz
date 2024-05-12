// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/quiz.dart';
import '../providers/quiz_provider.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: FutureBuilder(
        future: QuizProvider.getQuizBox(),
        builder: (context, AsyncSnapshot<Box<Quiz>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final quizBox = snapshot.data!;
              final quizzes = quizBox.values.toList();
              return ListView.builder(
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return QuizCard(quiz: quiz);
                },
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class QuizCard extends StatefulWidget {
  final Quiz quiz;

  const QuizCard({Key? key, required this.quiz}) : super(key: key);

  @override
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  int? selectedOptionIndex;
  void clear() async{
await QuizProvider.clearAllQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              widget.quiz.question,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          ...widget.quiz.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedOptionIndex = index;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: selectedOptionIndex == index
                      ? MaterialStateProperty.resolveWith<Color>(
                          (states) => index == widget.quiz.correctOptionIndex
                              ? Colors.red
                              : Colors.green,
                        )
                      : null,
                ),
                child: Text(option),
              ),
            );
          }).toList(),
          ElevatedButton(onPressed:clear , child: Text('Clear'))
        ],
      ),
    );
  }
}
