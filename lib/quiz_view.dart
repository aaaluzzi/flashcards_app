import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class QuizViewPage extends StatefulWidget {
  const QuizViewPage({Key? key}) : super(key: key);

  @override
  _QuizViewPageState createState() => _QuizViewPageState();
}

class _QuizViewPageState extends State<QuizViewPage> {
  int currentIndex = 0;
  bool showDefinition = false;

  void toggleShowDefinition() {
    setState(() {
      showDefinition = !showDefinition;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FlashcardsState>();
    final flashcards = appState.flashcards;

    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz View')),
        body: const Center(
          child: Text('No flashcards available.'),
        ),
      );
    }

    final currentFlashcard = flashcards[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz View')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: toggleShowDefinition,
                child: Card(
                  elevation: 4,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        showDefinition ? currentFlashcard.definition : currentFlashcard.term,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = (currentIndex - 1) % flashcards.length;
                        if (currentIndex < 0) {
                          currentIndex = flashcards.length - 1;
                        }
                        showDefinition = false;
                      });
                    },
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = (currentIndex + 1) % flashcards.length;
                        showDefinition = false;
                      });
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: toggleShowDefinition,
                child: Text(showDefinition ? 'Show Term' : 'Show Definition'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

