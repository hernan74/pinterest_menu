import 'package:flutter/material.dart';
import 'package:pinterest_menu/pages/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: ' Titulo',
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
      },
    );
  }
}
