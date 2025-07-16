import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimatedContainer Demo',
      home: Scaffold(
        appBar: AppBar(title: Text('AnimatedContainer Demo')),
        body: Center(child: Text('Demo goes here')),
      ),
    );
  }
}
