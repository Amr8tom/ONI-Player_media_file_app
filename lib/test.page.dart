import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  final dynamic arg;
  const TestPage({super.key, required this.arg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("uri : ${arg.toString()}")),
    );
  }
}
