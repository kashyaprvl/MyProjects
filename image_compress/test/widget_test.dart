import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BottomNavWithFab extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Widget fabWidget;

  const BottomNavWithFab({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.fabWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          // Your app's content goes here
          Center(
            child: Text(
              'Page ${currentIndex + 1}',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(

        shape: CircularNotchedRectangle(),
        notchMargin: 2.0,
        child: BottomNavigationBar(
           type: BottomNavigationBarType.fixed,

          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: fabWidget,
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavWithFab(

      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      fabWidget: FloatingActionButton(
        onPressed: () {
          // Handle FloatingActionButton press
          Fluttertoast.showToast(msg: "msg");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
