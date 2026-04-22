import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rf_id_test/feature/new_feature/inventory/pages/read_items_list_page.dart';
// import 'package:rf_id_test/feature/new_feature/inventory/pages/item_info_page.dart';
// import 'package:rf_id_test/feature/new_feature/inventory/pages/read_items_list_page.dart';
// import 'package:rf_id_test/feature/new_feature/inventory/services/items_service.dart';

import '../controllers/tag_search_controller.dart';
import '../models/tag_model.dart';
import '../services/items_service.dart';
import 'item_info_page.dart';

class AllFromDatabasePage extends StatefulWidget {
  const AllFromDatabasePage({super.key});

  @override
  State<AllFromDatabasePage> createState() => _AllFromDatabasePageState();
}

class _AllFromDatabasePageState extends State<AllFromDatabasePage> {
  final searchController = TextEditingController();
  late final TagSearchController tagController;

  late Future<List<TagModel>> itemsFuture;

  @override
  void initState() {
    super.initState();
    tagController = TagSearchController();
    tagController.load();

    itemsFuture = ItemsService().fetchItems();
  }

  @override
  void dispose() {
    searchController.dispose();
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(
                      text: 'Прогресс',
                    ),
                    Tab(
                      text: 'Подробности',
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Column(
                        children: [
                          const Text('Все единицы'),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: FutureBuilder<List<TagModel>>(
                                  future: itemsFuture,
                                  builder: (context, asyncSnapshot) {
                                    if (asyncSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (asyncSnapshot.hasError) {
                                      return Text(
                                          'Ошибка: ${asyncSnapshot.error}');
                                    }

                                    final items = asyncSnapshot.data ?? [];

                                    final readItems = items
                                        .where((item) => item.hasRfid)
                                        .toList();

                                    return Column(
                                      spacing: 8,
                                      children: [
                                        const Text('Прогресс считывания'),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  const Text('Всего'),
                                                  Text(items.length.toString())
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  Get.to(
                                                      const ReadItemsListPage());
                                                },
                                                child: Column(
                                                  children: [
                                                    const Text('Считано'),
                                                    Text(readItems.length
                                                        .toString())
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  const Text('Чтений меток'),
                                                  Text(readItems.length
                                                      .toString())
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const LinearProgressIndicator(
                                          value: 0,
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.black),
                              child: const Text('ЗАПУСТИТЬ RFID')),
                          const SizedBox(
                            height: 12,
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: const Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                spacing: 8,
                                children: [
                                  Text('Мощность RFID считывателя'),
                                  LinearProgressIndicator(
                                    value: 0.5,
                                  ),
                                  Text('Текущая мощность 50%')
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      DefaultTabController(
                        length: 2,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: searchController,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    tagController.search('');
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                              onChanged: tagController.search,
                            ),
                            const TabBar(
                              tabs: [
                                Tab(
                                  text: 'Все',
                                ),
                                Tab(
                                  text: 'Считано',
                                ),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  ValueListenableBuilder<List<TagModel>>(
                                    valueListenable: tagController.filteredTags,
                                    builder: (context, list, _) {
                                      if (list.isEmpty) {
                                        return const Center(
                                            child: Text('Ничего не найдено'));
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: ListView.separated(
                                          padding: const EdgeInsets.all(10),
                                          itemCount: list.length,
                                          separatorBuilder: (_, __) =>
                                              const SizedBox(height: 10),
                                          itemBuilder: (context, index) {
                                            final item = list[index];

                                            return GestureDetector(
                                                onLongPressStart: (details) {
                                                  showMenu(
                                                    context: context,
                                                    position:
                                                        RelativeRect.fromLTRB(
                                                      details.globalPosition.dx,
                                                      details.globalPosition.dy,
                                                      details.globalPosition.dx,
                                                      details.globalPosition.dy,
                                                    ),
                                                    items: [
                                                      const PopupMenuItem(
                                                          value: 'search',
                                                          child: Text('Поиск')),
                                                      PopupMenuItem(
                                                          value: 'info',
                                                          onTap: () {
                                                            Get.to(ItemInfoPage(
                                                              item: item,
                                                            ));
                                                          },
                                                          child: const Text(
                                                              'Инфо')),
                                                    ],
                                                  );
                                                },
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  color: item.hasRfid
                                                      ? Colors.green
                                                      : Colors.black,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(item.data,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                      Text(item.status,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .white70)),
                                                    ],
                                                  ),
                                                ));
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  ValueListenableBuilder<List<TagModel>>(
                                    valueListenable: tagController.allTags,
                                    builder: (context, _, __) {
                                      final list = tagController.scannedOnly;

                                      if (list.isEmpty) {
                                        return const Center(
                                            child: Text('Ничего не найдено'));
                                      }

                                      return ListView.separated(
                                        padding: const EdgeInsets.all(10),
                                        itemCount: list.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(height: 10),
                                        itemBuilder: (context, index) {
                                          final item = list[index];

                                          return Container(
                                            padding: const EdgeInsets.all(8),
                                            color: Colors.green,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(item.data,
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                                Text(item.status,
                                                    style: const TextStyle(
                                                        color: Colors.white70)),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
