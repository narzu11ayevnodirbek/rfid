import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

part 'mixin/home_mixin.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeMixin {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('RFID reader test')),
        body: ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (_, loading, __) => loading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _start();
                        },
                        child: loading
                            ? const SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
                              )
                            : const Text('Start NFC Scan'),
                      ),
                      const SizedBox(height: 40),
                      ValueListenableBuilder(
                        valueListenable: nfcReaderResult,
                        builder: (_, value, __) => Text('result: $value'),
                      ),
                      const SizedBox(height: 40),
                      ValueListenableBuilder(
                        valueListenable: scannedText,
                        builder: (_, scanned, __) => Text('qr scanner result: $scanned'),
                      ),
                    ],
                  ),
                ),
        ),
      );
}
