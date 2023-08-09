import 'package:flashcards/flashcard_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'group_view_data.dart';
import 'main.dart';

class AddFlashcardPage extends StatelessWidget {
  const AddFlashcardPage({super.key});
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FlashcardsState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Add New Flashcard"),
      ),
      body: Center(
        child: AddFlashcardForm(
          onSubmit: (term, definition, selectedGroup) {
            appState.add(
              FlashcardData(term, definition, groupId: selectedGroup?.id), // Pass the group ID
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class AddFlashcardForm extends StatefulWidget {
  final void Function(String term, String definition, GroupData? selectedGroup) onSubmit;

  const AddFlashcardForm({super.key, required this.onSubmit});

  @override
  AddFlashcardFormState createState() => AddFlashcardFormState();
}

class AddFlashcardFormState extends State<AddFlashcardForm> {
  final _formKey = GlobalKey<FormState>();
  String term = '';
  String definition = '';
  GroupData? selectedGroup;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.onSubmit(term, definition, selectedGroup);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<FlashcardsState>();
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Term'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a term';
                }
                return null;
              },
              onSaved: (value) {
                term = value!;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Definition'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a definition';
                }
                return null;
              },
              onSaved: (value) {
                definition = value!;
              },
            ),
            DropdownButton<GroupData>(
              value: selectedGroup,
              hint: const Text('Select a group'),
              onChanged: (newValue) {
                setState(() {
                  selectedGroup = newValue;
                });
              },
              items: appState.groups.map((group) {
                return DropdownMenuItem<GroupData>(
                  value: group,
                  child: Text(group.name),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Flashcard'),
            ),
          ],
        ),
      ),
    );
  }
}
