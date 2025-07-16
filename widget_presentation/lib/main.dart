import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ConstrainedBox Visual Demo',
      home: ConstrainedBoxDemo(),
    );
  }
}

class ConstrainedBoxDemo extends StatefulWidget {
  const ConstrainedBoxDemo({super.key});

  @override
  _ConstrainedBoxDemoState createState() => _ConstrainedBoxDemoState();
}

class _ConstrainedBoxDemoState extends State<ConstrainedBoxDemo> {
  double _size = 100;
  Color _color = Colors.blue;

  void _increaseSize() {
    setState(() {
      _size += 40;
      if (_size > 400) {
        _size = 100;
      }
      _color = _color == Colors.blue ? Colors.red : Colors.blue;
    });
  }

  Widget buildLabeledBox({required String label, required Widget child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ConstrainedBox vs Unconstrained')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Tap either box. One stops growing due to constraints, the other grows freely.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Constrained Box
                buildLabeledBox(
                  label: 'Constrained Box',
                  child: GestureDetector(
                    onTap: _increaseSize,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 200,
                          maxHeight: 200,
                          minWidth: 80,
                          minHeight: 80,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: _size,
                          height: _size,
                          color: _color,
                          alignment: Alignment.center,
                          child: const Text(
                            'Tap Me!',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                // Unconstrained Box
                buildLabeledBox(
                  label: 'Unconstrained Box',
                  child: GestureDetector(
                    onTap: _increaseSize,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: _size,
                      height: _size,
                      color: _color.withOpacity(0.8),
                      alignment: Alignment.center,
                      child: const Text(
                        'Tap Me!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Current Size: ${_size.toInt()} × ${_size.toInt()}'),
          ],
        ),
      ),
    );
  }
}
