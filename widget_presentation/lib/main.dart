import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnimatedContainer Demo',
      home: AnimatedBoxDemo(),
    );
  }
}

class AnimatedBoxDemo extends StatelessWidget {
  const AnimatedBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AnimatedContainer Demo')),
      body: Center(
        child: GestureDetector(
          onTap: () {},
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: 100,
            height: 100,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
