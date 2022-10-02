import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_project/provider.dart';

// ignore: must_be_immutable
class SavedScreens extends StatefulWidget {
  Map<dynamic, dynamic> map;
  SavedScreens(this.map, {Key? key}) : super(key: key);

  //const SavedScreens({super.key});

  @override
  State<SavedScreens> createState() => _SavedScreensState();
}

class _SavedScreensState extends State<SavedScreens> {
  void removeSavedWords(BuildContext context, id, item) {
    Provider.of<SavedWords>(context, listen: false).remove(item, id);
  }

  void getSaves() async {
    late Map<dynamic, dynamic> query = {};
    query = await Provider.of<SavedWords>(context, listen: false)
        .queryData; // Await on your query future.

    // The if statement is required since
    // the response from the server arrives
    // after the widget is disposed when going back to first screen.
    if (mounted) {
      // setState to update the map and
      // the screen after deleting an item
      setState(() {
        widget.map = query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getSaves();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Suggestions'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: widget.map.length,
        itemBuilder: (context, i) {
          var id = widget.map.keys.elementAt(i);
          var item = widget.map[id];

          return ListTile(
            title: Text(
              item,
              style: const TextStyle(fontSize: 18),
            ),
            trailing: IconButton(
                icon: const Icon(Icons.delete),
                color: null,
                onPressed: () => {
                      removeSavedWords(context, id, item),
                      getSaves(),
                    }),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}
