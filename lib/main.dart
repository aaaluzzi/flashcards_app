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
      title: 'Flashcards',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flashcards Home Page'),
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
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var flashcard in appState.flashcards)
                Text("${flashcard.term} - ${flashcard.definition}"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddFlashcardPage()));
          },
          tooltip: 'Add Flashcard',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddFlashcardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Add New Flashcard"),
      ),
    );
  }
}
