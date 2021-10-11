// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          // backgroundColor: Colors.blueAccent[200],
          backgroundColor: Colors.green[800],
          // foregroundColor: Colors.black,
        ),
      ),
      home: RandomWords(),
    );
  }
// #enddocregion build
}
// #enddocregion MyApp

// #docregion RWS-var
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = generateWordPairs().take(50).toList();
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return Column(children: [
      Flexible(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          children: _suggestions.map((e) => _buildRow(e)).toList(),
        ),
      ),
      TextButton(
        child: Text(
          "Refresh",
          style: TextStyle(
            color: Colors.green[800],
          ),
        ),
        onPressed: () {
          setState(() {
            _suggestions.clear();
            _suggestions.addAll(generateWordPairs().take(50).toList());
          });
        },
      )
    ]);
  }

  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      onLongPress: () {
        _showDialog(pair);
      },
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: IconButton(
        icon: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.green[800] : null,
          semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
        ),
        onPressed: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        },
      ),
      onTap: () {
        _reverseText(pair);
      },
    );
  }

  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  // #enddocregion RWS-build

  Future<void> _showDialog(WordPair pair) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this item?'),
          // content: SingleChildScrollView(
          //   child: ListBody(
          //     children: const <Widget>[
          //       Text('This is a demo alert dialog.'),
          //       Text('Would you like to approve of this message?'),
          //     ],
          //   ),
          // ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  color: Colors.green[800],
                ),
              ),
              onPressed: () {
                setState(() {
                  _suggestions.remove(pair);
                  if (_saved.contains(pair)) {
                    _saved.remove(pair);
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.green[800],
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // NEW lines from here...
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList()
              : <Widget>[];

          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }, //...to here.
      ),
    );
  }

  void _reverseText(WordPair pair) {
    final index = _suggestions.indexOf(pair);
    setState(() {
      _suggestions.removeAt(index);
      _suggestions.insert(
          index,
          WordPair(pair.second.split('').reversed.join(''),
              pair.first.split('').reversed.join('')));
    });
  }
// #docregion RWS-var
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
