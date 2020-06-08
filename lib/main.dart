import 'package:flutter/material.dart';
import 'package:mobile/src/routes.dart';

import 'src/pages/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color(0xFFF0F0F5),
      ),
      initialRoute: "home",
      routes: routes,
    );
  }
}
