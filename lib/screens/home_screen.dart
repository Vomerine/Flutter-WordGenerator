import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'saved_screen.dart';
import 'package:provider/provider.dart';
import 'package:test_project/provider.dart';

// Creates the State, the function name to be called
class RandomWords extends StatefulWidget {
  const RandomWords({super.key});

  @override
  State<RandomWords> createState() => _RandomWordsState();
}

// RandomWords function that holds the logic
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; // list of widget
  Map<dynamic, dynamic> _map = {};
  final _biggerFont = const TextStyle(fontSize: 18);
  var _lastId = 1;

  // Function for calling the provider for adding or removing an item
  void changeSavedWords(BuildContext context, isSaved, item, id) {
    // Check if the word is already saved
    if (isSaved) {
      Provider.of<SavedWords>(context, listen: false).remove(item, id);
    } else {
      Provider.of<SavedWords>(context, listen: false).add(item, id);
    }
  }

  void getSaves() async {
    _map = await Provider.of<SavedWords>(context, listen: false)
        .queryData; // Await on your future.

    var len = _map.length;
    setState(() {
      _lastId = len == 0 ? len : int.parse(_map.keys.elementAt(len - 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    //final saved = context.watch<SavedWords>().getSaves; // get saved words
    getSaves();
    return Scaffold(
      // Scaffold is the 'page' of the screen

      appBar: AppBar(
        // AppBar is the 'Navbar' at the top
        title: const Text('Startup Name Generator'),
        actions: [
          // Contains the Menu button
          // Calls the second screen
          IconButton(
            icon: const Icon(Icons.favorite),
            color: Colors.red,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedScreens(_map)),
              );
            },
            tooltip: 'Favorites', // For mouse hover
          ),
        ],
      ),
      body: ListView.builder(
        // ListView is a widget with scroll functionality
        // ListView just displays a finite state of item so
        // the ListView.builder is used to create an infinite list
        padding: const EdgeInsets.all(16.0),

        // Prints out all the item, there's an invisible foreach
        itemBuilder: (context, i) {
          //print('length: ${_suggestions.length} i: ${i}');

          // Insert a line between item
          if (i.isOdd) return const Divider();

          // Since the line divider is also counted as a widget,
          // we divide the index by 2
          // and then round off the value to an int (~/)
          final index = i ~/ 2;

          // If we got to to the last item, we generate another 10
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          // Check if the word is in the database
          // If not add 1 to id to set as the next word primary id.
          var id = _map.keys.firstWhere(
              (k) => _map[k] == _suggestions[index].toString(),
              orElse: () => '${_lastId + 1}');

          // If id is less than or equal to lastId,
          // the word is in the database
          final isSaved = int.parse(id) <= _lastId;

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: IconButton(
                icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border),
                color: isSaved ? Colors.red : null,
                onPressed: () => {
                      changeSavedWords(
                          context, isSaved, _suggestions[index], id),
                      getSaves(),
                    }),
          );
        },
      ),
    );
  }
}
