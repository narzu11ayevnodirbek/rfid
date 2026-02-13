import 'package:flutter/foundation.dart';
import '../models/tag_model.dart';
import '../services/items_service.dart';

class TagSearchController extends ChangeNotifier {
  TagSearchController();

  final ItemsService _service = ItemsService();

  final ValueNotifier<List<TagModel>> allTags =
      ValueNotifier<List<TagModel>>([]);

  final ValueNotifier<List<TagModel>> filteredTags =
      ValueNotifier<List<TagModel>>([]);

  Future<void> load() async {
    final data = await _service.fetchItems();
    allTags.value = data;
    filteredTags.value = data;
  }

  void search(String query) {
    if (query.isEmpty) {
      filteredTags.value = allTags.value;
      return;
    }

    final q = query.toLowerCase();

    filteredTags.value =
        allTags.value.where((e) => e.data.toLowerCase().contains(q)).toList();
  }

  List<TagModel> get scannedOnly =>
      allTags.value.where((e) => e.hasRfid).toList();

  @override
  void dispose() {
    super.dispose();
    allTags.dispose();
    filteredTags.dispose();
  }
}
