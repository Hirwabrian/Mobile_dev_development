import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Implicit Animation Demo',
      home: ImplicitAnimationScreen(),
    );
  }
}

class ImplicitAnimationScreen extends StatefulWidget {
  @override
  _ImplicitAnimationScreenState createState() =>
      _ImplicitAnimationScreenState();
}

class _ImplicitAnimationScreenState extends State<ImplicitAnimationScreen> {
  double _width = 100;
  double _height = 100;
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Implicit Animation'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _width = _width == 100 ? 200 : 100;
              _height = _height == 100 ? 200 : 100;
              _color = _color == Colors.blue ? Colors.red : Colors.blue;
            });
          },
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: _width,
            height: _height,
            color: _color,
            child: Center(
              child: Text(
                'Tap Me!',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
