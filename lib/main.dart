import 'package:flutter/material.dart';
import 'App.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jafet\' Toolbox ',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.black
      ),
      home: App(),
    );
  }
}
