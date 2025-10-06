import 'package:flutter/material.dart';

class TransitionPage extends StatefulWidget {
  const TransitionPage({super.key});

  @override
  State<TransitionPage> createState() => _TransitionPageState();
}

class _TransitionPageState extends State<TransitionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Перемещение'),
      ),
    );
  }
}
