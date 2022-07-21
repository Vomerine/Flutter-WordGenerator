import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class SavedWords extends ChangeNotifier {
  final _saved = <WordPair>{}; // Set of saved words

  get getSaves {
    return _saved;
  }

  // We're gonne use the notifyListeners()
  // to change the context.watch values
  void add(item) {
    _saved.add(item);
    notifyListeners();
  }

  void remove(item) {
    _saved.remove(item);
    notifyListeners();
  }
}
