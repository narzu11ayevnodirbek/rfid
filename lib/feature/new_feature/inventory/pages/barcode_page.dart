import 'package:flutter/material.dart';

class BarcodePage extends StatelessWidget {
  const BarcodePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Отметить найденным по штрихкоду',
            style: TextStyle(fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              TextFormField(),
              const SizedBox(
                height: 12,
              ),
              FilledButton(
                  onPressed: () {}, child: const Text('СЧИТАТЬ ШТРИХКОД')),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                      flex: 2,
                      child: FilledButton(
                          onPressed: () {}, child: const Text('НАЙДЕНО'))),
                  Flexible(
                      child: FilledButton(
                          onPressed: () {}, child: const Text('НАЗАД')))
                ],
              )
            ],
          ),
        ),
      );
}
