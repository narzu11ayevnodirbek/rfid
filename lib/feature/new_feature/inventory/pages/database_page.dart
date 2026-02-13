import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'all_from_database_page.dart';

class DatabasePage extends StatelessWidget {
  const DatabasePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(const AllFromDatabasePage());
                    },
                    child: Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          'ВСЕ ЕДИНИЦЫ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    color: Colors.black,
                    child: const Center(
                      child: Text(
                        'ОБМЕН',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
