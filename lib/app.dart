import 'package:flutter/material.dart';
import 'presentation/pages/esti_home.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Esti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EstiHome(),
    );
  }
}
