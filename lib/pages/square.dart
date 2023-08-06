import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class pageSquare extends StatefulWidget {
  const pageSquare({super.key});

  @override
  State<pageSquare> createState() => _pageSquareState();
}

class _pageSquareState extends State<pageSquare> {
  String tfieldValue = "0"; // radius
  final textController1 = TextEditingController();

void performDivision() {
    double num1 = double.tryParse(textController1.text) ?? 0.0;

    if (num1 != 0) {
      double result = num1 * num1;
      setState(() {
        tfieldValue = result.toStringAsFixed(2);
        textController1.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Area of a Square',
            style: TextStyle(
                color: Colors.black,
                fontSize: 40,
              ),
            ),
            Text(
              tfieldValue,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: textController1,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                decoration: InputDecoration(
                  hintText: "Enter a value",
                  suffix: IconButton(
                      onPressed: () {
                        textController1.clear();
                      },
                      icon: const Icon(Icons.close)),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.black,
                    width: 10,
                    style: BorderStyle.solid,
                  )),
                ),
              ),
            ),
            Padding(
                  padding: const EdgeInsets.all(30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Center(
                      child: MaterialButton(
                        onPressed: performDivision,
                        color: Colors.orange,
                        minWidth: 250,
                            height: 50,
                        child: const Text("Calculate"),
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}