import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';

void main() {
  runApp(const MyApp());
}

class ColorManager {
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: ColorManager.createMaterialColor(
            const Color.fromRGBO(22, 23, 52, 1.0)),
      ),
      home: const MyHomePage(title: 'Small Wikipedia Browser'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Article {
  String title = "";
  String content = "";

  Article(this.title, this.content);

  bool isLoaded() {
    return title.isNotEmpty && content.isNotEmpty;
  }

  void unload() {
    title = "";
    content = "";
  }
}

class _ArticleWidget {

}

class _MyHomePageState extends State<MyHomePage> {
  String label = "";

  final textFieldController = TextEditingController();

  void onTextFieldChange(String text) {
    setState(() {
      label = text;
    });
  }

  late Article currentArticle = Article("", "");

  void fetchArticle(String title) async {
    String query = sprintf(
        'https://de.wikipedia.org/w/api.php?action=query&format=json&prop=revisions&prop=extracts&explaintext=True&titles=%s',
        [title.replaceAll(" ", "_")]);
    final response = await http.get(Uri.parse(query));

    if (response.statusCode == 200) {
      Map<String, dynamic> json =
          jsonDecode(response.body) as Map<String, dynamic>;
      Map<String, dynamic> responseQuery = json['query'];
      Map<String, dynamic> responsePages = responseQuery['pages'];
      String firstKey = responsePages.keys.elementAt(0);
      String title = responsePages[firstKey]['title'].toString();
      String content = responsePages[firstKey]['extract'].toString();

      setState(() {
        currentArticle = Article(title, content);
      });
    } else {
      throw Exception('Failed to load album');
    }
  }

  void onSearchButtonPressed() {
    fetchArticle(label);
  }

  List<Widget> getFoo() {
    if (currentArticle.isLoaded()) {
      return [
        Text(
          currentArticle.title,
          style: Theme.of(context).textTheme.headline4,
        ),
        Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(currentArticle.content)))
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 3,
                    child: SizedBox(
                        height: 80,
                        child: TextField(
                            controller: textFieldController,
                            onChanged: onTextFieldChange,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Titel eines Wikipedia-Artikels")))),
                Expanded(
                    flex: 1,
                    child: SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed: onSearchButtonPressed,
                          child: const Text('Suche'),
                        )))
              ],
            ),
            ...getFoo()
          ],
        ),
      )),
    );
  }
}
