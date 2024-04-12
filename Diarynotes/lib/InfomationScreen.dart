import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen(BuildContext context, {super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.navigate_next
        ),
        onPressed: () {
          Navigator.pushNamed(context, "/secondInfo");
        },
      ),
      body: Container(
        child: Center(
          child: Text("This is information Screen some data here....."),
        ),
      ),
    );
  }
}
