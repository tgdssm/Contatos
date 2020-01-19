import 'package:contatos/ui/contact_page.dart';
import 'package:contatos/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionColor: Colors.white,
        brightness: Brightness.dark
      ),
      home: HomePage(),
    );
  }
}
