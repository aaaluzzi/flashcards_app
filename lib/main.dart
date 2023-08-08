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

  void updateFlashcard(String term, String newTerm, String newDefinition) {
    final flashcardIndex = flashcards.indexWhere((flashcard) =>
    flashcard.term == term);
    if (flashcardIndex != -1) {
      flashcards[flashcardIndex] = FlashcardData(newTerm, newDefinition);
      notifyListeners();
    }
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(title),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                for (var flashcard in appState.flashcards)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FlashcardRow(
                        term: flashcard.term,
                        definition: flashcard.definition,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueGrey,
          shape: const CircularNotchedRectangle(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 3),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.rectangle),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const QuizViewPage()),
                            );
                          },
                        ),
                        const Text(
                          'Quiz View',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.menu),
                          color: Colors.white,
                          onPressed: () {
                            // TO DO
                          },
                        ),
                        const Text(
                          'Show Groups',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add),
                          color: Colors.white,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AddFlashcardPage()),
                            );
                          },
                        ),
                        const Text(
                          'Add Flashcard',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
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
            Expanded(
              child: Text(
                "$term  |  $definition",
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    String newTerm = term;
                    String newDefinition = definition;

                    return AlertDialog(
                      title: const Text('Edit Flashcard'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            initialValue: term,
                            onChanged: (value) => newTerm = value,
                            decoration: const InputDecoration(labelText: 'Term'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            initialValue: definition,
                            onChanged: (value) => newDefinition = value,
                            decoration: const InputDecoration(labelText: 'Definition'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            appState.updateFlashcard(term, newTerm, newDefinition);
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.deepOrangeAccent,
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
