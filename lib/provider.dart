import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:firebase_database/firebase_database.dart';

class SavedWords extends ChangeNotifier {
  final _saved = <WordPair>{}; // Set of saved words
  final Map<String, dynamic> _map = {};
  final DatabaseReference _db = FirebaseDatabase.instance.ref('Saves');

  get getSaves {
    return _saved;
  }

  Future<Map> get queryData async {
    DataSnapshot snapshot = await _db.get();
    _map.clear();
    // Loop through all the ids
    for (final child in snapshot.children) {
      Map<String, String> test = Map<String, String>.from(child.value as Map);

      // Loop through the words and add them to a list
      List<String> words = [];
      test.forEach((key, value) {
        words.add(value);
      });

      // Save the words as with their id as key-value pair

      _map[child.key ?? '1'] = words[0] + words[1];
    }
    return _map;
  }

  // We're gonne use the notifyListeners()
  // to change the context.watch values
  void add(item, id) {
    // Save to firebase with generated id
    DatabaseReference newItem = _db;

    // Words are saved separately so they
    // can be added later as a WordPair
    newItem.child(id).set({
      "firstWord": item.first,
      "secondWord": item.second,
    });

    notifyListeners();
  }

  void remove(item, id) {
    _saved.remove(item);

    // Remove the word from the database
    DatabaseReference newItem = _db;
    newItem.child(id).set({});

    notifyListeners();
  }
}
