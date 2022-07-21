import 'package:flutter/material.dart';

void pushSaved(BuildContext context, saved, biggerFont) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) {
        // Make a map (foreach) and convert it to widget
        // Maybe moving it to diff file cause it to
        // forgot that it is a widget?
        final tiles = saved.map<Widget>(
          // Return a ListTile() foreach pair of saved words
          (pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: biggerFont,
              ),
            );
          },
        );
        final divided = tiles.isNotEmpty
            // Print each tiles with a line divider
            // with the .divideTiles() method
            ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
            : <Widget>[];

        // Then the page is loaded
        return Scaffold(
          appBar: AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16.0),
            children: divided,
          ),
        );
      },
    ),
  );
}
