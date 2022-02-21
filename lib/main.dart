import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Learning flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String label = "";

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  final textFieldController = TextEditingController();

  void onTextFieldChange(String text) {
    setState(() {
      label = text;
    });
  }

  void onSearchButtonPressed() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child:
                    Container(
                      height: 80,
                      child:
                        TextField(
                            controller: textFieldController,
                            onChanged: onTextFieldChange,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Titel eines Wikipedia-Artikels"
                            )
                        )
                    )
                  ),
                  Expanded(
                    flex: 1,
                    child:
                      Container(
                        height: 60,
                        child:
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.fromHeight(40),
                            ),
                            onPressed: () {},
                            child: Text('Suche'),
                          )
                      )
                  )
                ],
              )
            ),
            Text(
              textFieldController.text,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
