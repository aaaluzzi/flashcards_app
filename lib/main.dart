import 'package:flashcards/flashcard_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlashcardsState extends ChangeNotifier {
  final List<FlashcardData> flashcards = [
    FlashcardData("term1", "definition1"),
    FlashcardData("term2", "definition2")
  ];

  void add(FlashcardData flashcard) {
    flashcards.add(flashcard);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FlashcardsState(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FlashcardsState>();

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var flashcard in appState.flashcards)
                Text("${flashcard.term} - ${flashcard.definition}"),
            ],
          ),
        ),
      ),
    );
  }
}
