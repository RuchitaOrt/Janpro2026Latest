import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
 const CounterScreen({super.key});
  @override
  _CounterScreenState createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Value is ${value}"),

        ElevatedButton(
          onPressed: () {
            setState(() {
              value++;
            });
          },
          child: Text("+"),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              value--;
            });
          },
          child: Text("-"),
        ),
      ],
    );
  }
}
