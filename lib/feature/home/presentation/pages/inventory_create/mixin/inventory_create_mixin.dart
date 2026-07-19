part of 'package:rfid/feature/home/presentation/pages/inventory_create/inventory_create_page.dart';

mixin InventoryCreateMixin on State<InventoryCreatePage> {
  late final TextEditingController _nameTextController;
  final FocusNode _nameFocusNode = FocusNode();
  final ValueNotifier<String?> _nameError = ValueNotifier(null);

  final ValueNotifier<bool> _typeError = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _nameTextController.addListener(() {
      _nameError.value = _nameTextController.text.isEmpty ? 'Поле не может быть пустым' : null;
    });
  }
}

class InventoryCreateArgs {
  const InventoryCreateArgs({
    this.id,
    this.isCreate = true,
  });

  final String? id;
  final bool isCreate;
}
