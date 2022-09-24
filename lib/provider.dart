import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_database/firebase_database.dart';

class SavedWords extends ChangeNotifier {
  final _saved = <WordPair>{}; // Set of saved words
  final DatabaseReference _db = FirebaseDatabase.instance.ref('Saves');

  get getSaves {
    return _saved;
  }

  Future<Set<WordPair>> get queryData async {
    final query = <WordPair>{};

    DataSnapshot snapshot = await _db.get();

    // Loop through all the ids
    for (final child in snapshot.children) {
      Map<String, String> test = Map<String, String>.from(child.value as Map);

      // Loop through the words and add them to a list
      List<String> words = [];
      test.forEach((key, value) {
        words.add(value);
      });

      // Convert the word to a WordPair and add them to a list
      query.add(WordPair(words[0], words[1]));
    }

    return query;
  }

  // We're gonne use the notifyListeners()
  // to change the context.watch values
  void add(item) {
    _saved.add(item);

    // Save to firebase with generated id
    DatabaseReference newItem = _db.push();

    // Words are saved separately so they
    // can be added later as a WordPair
    newItem.set({
      "firstWord": item.first,
      "secondWord": item.second,
    });

    notifyListeners();
  }

  void remove(item) {
    _saved.remove(item);
    notifyListeners();
  }
}
