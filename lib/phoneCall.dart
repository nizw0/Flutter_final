import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new Home(),
    );
  }
}

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("View"),
    ),
    body: Center(
      child: FlatButton(
          onPressed: () => url_launcher.launch("tel://21213123123"),
          child: Text("Call me")),
    ),
  );
}

void main() {
  runApp(
    MyApp(),
  );
}