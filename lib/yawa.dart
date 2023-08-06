import 'package:flutter/material.dart';

class testing extends StatefulWidget {
  const testing({super.key});

  @override
  State<testing> createState() => _testingState();
}

class _testingState extends State<testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const Center(child: Text("",
        style: TextStyle(fontStyle: FontStyle.normal,
        fontSize: 50,
        color: Colors.amber
        ),
        )),
      ),
    );
  }
}