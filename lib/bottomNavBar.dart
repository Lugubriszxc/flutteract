import 'package:flutter/material.dart';

import 'pages/circle1.dart';
import 'pages/rectangle.dart';
import 'pages/square.dart';
import 'pages/triangle.dart';

class bNavBar extends StatefulWidget {
  const bNavBar({super.key});

  @override
  State<bNavBar> createState() => _bNavBarState();
}

class _bNavBarState extends State<bNavBar> {
  int _selectedIndex = 0;

  void _navigationBottomBar(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const pageCircle(),
    const pageSquare(),
    const pageRectangle(),
    const pageTriangle(),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
      (
        title: const Center(child: Text("Calculator")),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar
      (
        currentIndex: _selectedIndex,
        onTap: _navigationBottomBar,
        type: BottomNavigationBarType.fixed,
        items: 
        const [
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Circle'),
          BottomNavigationBarItem(icon: Icon(Icons.square), label: 'Square'),
          BottomNavigationBarItem(icon: Icon(Icons.rectangle), label: 'Rectangle'),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_upward), label: 'Triangle'),
        ],
      ),
    );
  }
}