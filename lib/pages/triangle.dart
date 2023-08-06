import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class pageTriangle extends StatefulWidget {
  const pageTriangle({super.key});

  @override
  State<pageTriangle> createState() => _pageTriangleState();
}

class _pageTriangleState extends State<pageTriangle> {
  String tfieldValue = "0"; // radius
  final textController1 = TextEditingController();
  final textController2 = TextEditingController();

void performDivision() {
    double num1 = double.tryParse(textController1.text) ?? 0.0;
    double num2 = double.tryParse(textController2.text) ?? 0.0;

    double result = (num1 * num2) / 2;
    setState(() {
      tfieldValue = result.toStringAsFixed(2);
      textController1.clear();
      textController2.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('Area of a Triangle',
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
                  hintText: "Enter a base value",
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
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: textController2,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
                decoration: InputDecoration(
                  hintText: "Enter a height value",
                  suffix: IconButton(
                      onPressed: () {
                        textController2.clear();
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