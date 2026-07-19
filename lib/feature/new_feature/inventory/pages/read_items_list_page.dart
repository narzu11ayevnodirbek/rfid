import 'package:flutter/material.dart';

import 'package:rfid/feature/new_feature/inventory/models/tag_model.dart';
import 'package:rfid/feature/new_feature/inventory/services/items_service.dart';

class ReadItemsListPage extends StatefulWidget {
  const ReadItemsListPage({super.key});

  @override
  State<ReadItemsListPage> createState() => _ReadItemsListPageState();
}

class _ReadItemsListPageState extends State<ReadItemsListPage> {
  List<TagModel> items = [];
  bool isLoadingItems = true;

  List<TagModel> get readedItems => items.where((item) => item.hasRfid).toList();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final result = await ItemsService().fetchItems();
    setState(() {
      items = result;
      isLoadingItems = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: isLoadingItems
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, index) {
                    final item = readedItems[index];

                    return Container(
                      padding: const EdgeInsets.all(8),
                      width: double.infinity,
                      color: Colors.green,
                      child: Text(
                        'Объект: ${item.name.toString()}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 8,
                      ),
                  itemCount: readedItems.length),
        ),
      );
}
