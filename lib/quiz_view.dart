import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'main.dart';

class QuizViewPage extends StatefulWidget {
  const QuizViewPage({Key? key}) : super(key: key);

  @override
  _QuizViewPageState createState() => _QuizViewPageState();
}

class _QuizViewPageState extends State<QuizViewPage> {
  int currentIndex = 0;
  bool showDefinition = false;
  List<int> visitedIndices = [];
  String? selectedGroupId;

  void toggleShowDefinition() {
    setState(() {
      showDefinition = !showDefinition;
    });
  }

  void toggleRandomFlashcard() {
    var appState = context.read<FlashcardsState>();
    final flashcards = appState.flashcards;

    if (visitedIndices.length == flashcards.length) {
      visitedIndices.clear();
    }

    int randomIndex;
    do {
      randomIndex = Random().nextInt(flashcards.length);
    } while (visitedIndices.contains(randomIndex));

    setState(() {
      currentIndex = randomIndex;
      visitedIndices.add(randomIndex);
      showDefinition = false;
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
      appBar: AppBar(
          title: const Text('Quiz View'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: toggleShowDefinition,
                child: AspectRatio(
                  aspectRatio: 8 / 5,
                  child: Card(
                    elevation: 4,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          showDefinition
                              ? currentFlashcard.definition
                              : currentFlashcard.term,
                          style: const TextStyle(fontSize: 18),
                        ),
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
                  ElevatedButton(
                    onPressed: toggleRandomFlashcard,
                    child: const Text('Randomize'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: toggleShowDefinition,
                child: Text(showDefinition ? 'Show Term' : 'Show Definition'),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedGroupId,
                hint: const Text('Select a group'),
                onChanged: (newValue) {
                  setState(() {
                    selectedGroupId = newValue;
                    currentIndex = 0;
                    visitedIndices.clear();
                    showDefinition = false;
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Groups'),
                  ),
                  ...appState.groups.map((group) {
                    return DropdownMenuItem<String>(
                      value: group.id,
                      child: Text(group.name),
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
