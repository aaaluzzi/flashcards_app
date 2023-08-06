import 'package:flashcards/flashcard_data.dart';
import 'package:flashcards/quiz_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_flashcard.dart';

class FlashcardsState extends ChangeNotifier {
  final List<FlashcardData> flashcards = [
    FlashcardData("term1", "definition1"),
    FlashcardData("term2", "definition2")
  ];

  void add(FlashcardData flashcard) {
    flashcards.add(flashcard);
    notifyListeners();
  }
  void removeFlashcard(String term) {
    flashcards.removeWhere((flashcard) => flashcard.term == term);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FlashcardsState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flashcards'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FlashcardsState>();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                for (var flashcard in appState.flashcards)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlashcardRow(
                        term: flashcard.term,
                        definition: flashcard.definition,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizViewPage()),
                );
              },
              tooltip: 'Quiz View',
              child: const Icon(Icons.rectangle),
            ),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddFlashcardPage()),
                );
              },
              tooltip: 'Add Flashcard',
              child: const Icon(Icons.add),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class FlashcardRow extends StatelessWidget {
  final String term;
  final String definition;

  const FlashcardRow({super.key, required this.term, required this.definition});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FlashcardsState>();
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$term  |  $definition",
              style: TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {
                appState.removeFlashcard(term);
              },
            ),
          ],
        ),
      ),
    );
  }
}
