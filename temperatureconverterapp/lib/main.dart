import 'package:flutter/material.dart';

void main() {
  runApp(TemperatureConverterApp());
}

class TemperatureConverterApp extends StatelessWidget {
  const TemperatureConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Converter',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: TemperatureConverterScreen(),
    );
  }
}

class TemperatureConverterScreen extends StatefulWidget {
  const TemperatureConverterScreen({super.key});

  @override
  _TemperatureConverterScreenState createState() =>
      _TemperatureConverterScreenState();
}

enum ConversionType { fToC, cToF }

class _TemperatureConverterScreenState
    extends State<TemperatureConverterScreen> {
  final TextEditingController _tempController = TextEditingController();
  ConversionType _selectedConversion = ConversionType.fToC;
  String _convertedResult = '';
  final List<String> _conversionHistory = [];

  void _convertTemperature() {
    final input = double.tryParse(_tempController.text);
    if (input == null) return;

    double result;
    String record;

    if (_selectedConversion == ConversionType.fToC) {
      result = ((input - 32) * 5 / 9);
      record = "F to C: $input => ${result.toStringAsFixed(2)}";
    } else {
      result = ((input * 9 / 5) + 32);
      record = "C to F: $input => ${result.toStringAsFixed(2)}";
    }

    setState(() {
      _convertedResult = result.toStringAsFixed(2);
      _conversionHistory.insert(0, record);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(title: Text("Converter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isPortrait ? _buildPortraitLayout() : _buildLandscapeLayout(),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildConversionSelector(),
        SizedBox(height: 16),
        _buildInputSection(),
        SizedBox(height: 16),
        _buildResultDisplay(),
        SizedBox(height: 16),
        Text(
          "History:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Expanded(child: _buildHistoryList()),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildConversionSelector(),
              SizedBox(height: 16),
              _buildInputSection(),
              SizedBox(height: 16),
              _buildResultDisplay(),
            ],
          ),
        ),
        SizedBox(width: 24),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "History:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Expanded(child: _buildHistoryList()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConversionSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Conversion:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<ConversionType>(
                title: Text("Fahrenheit to Celsius"),
                value: ConversionType.fToC,
                groupValue: _selectedConversion,
                onChanged: (value) {
                  setState(() => _selectedConversion = value!);
                },
              ),
            ),
            Expanded(
              child: RadioListTile<ConversionType>(
                title: Text("Celsius to Fahrenheit"),
                value: ConversionType.cToF,
                groupValue: _selectedConversion,
                onChanged: (value) {
                  setState(() => _selectedConversion = value!);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _tempController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Enter temperature",
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 12),
        ElevatedButton(onPressed: _convertTemperature, child: Text("CONVERT")),
      ],
    );
  }

  Widget _buildResultDisplay() {
    return Row(
      children: [
        Text(
          "Result: ",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(_convertedResult, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildHistoryList() {
    return _conversionHistory.isEmpty
        ? Center(child: Text("No conversions yet."))
        : ListView.builder(
          itemCount: _conversionHistory.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(_conversionHistory[index]));
          },
        );
  }
}
