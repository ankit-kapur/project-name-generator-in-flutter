import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project name generator',
      home: RandomWords(),
      theme: new ThemeData.dark()
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  // Empty list of type WordPair
  final _suggestions = <WordPair>[];

  // Saved set of words
  final _saved = new Set<WordPair>(); // Add this line

  /* Prefixing an identifier with an underscore enforces privacy in the Dart language. */
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildRow(WordPair pair) {
    // to ensure that a word pairing has not already been added to favorites.
    // i.e. whether to color-in the heart or not
    final bool alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        // Load material icon
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        // In Flutter's reactive style framework, calling setState()
        // triggers a call to the build() method for the State object,
        // resulting in an update to the UI.
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider();
          /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  /* When the favorites-list icon is pushed */
  void _pushSaved() {
    /* We build a route and push it to the Navigator's stack.
     * This action changes the screen to display the new route. */
    Navigator.of(context).push(
      /* The content for the new page is built in MaterialPageRoute's
       * builder property, in an anonymous function.*/
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          /* The builder property returns a Scaffold, containing the app bar for the new route,
           * named "Saved Suggestions." The body of the new route consists of a ListView
           * containing the ListTiles rows; each row is separated by a divider. */
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Saved ideas'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Name Generator'),
        actions: <Widget>[
          // Add 3 lines from here...
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
}

/* Stateful widget. Just creates the state. */
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
