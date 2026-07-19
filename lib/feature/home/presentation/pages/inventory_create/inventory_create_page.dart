import 'package:flutter/material.dart';
import 'package:rfid/core/extension/extension.dart';
import 'package:rfid/presentation/components/custom_app_bar.dart';
import 'package:rfid/presentation/components/custom_text_field.dart';

part 'mixin/inventory_create_mixin.dart';

class InventoryCreatePage extends StatefulWidget {
  const InventoryCreatePage({super.key, required this.args});

  final InventoryCreateArgs args;

  @override
  State<InventoryCreatePage> createState() => _InventoryCreatePageState();
}

class _InventoryCreatePageState extends State<InventoryCreatePage> with InventoryCreateMixin {
  final items = ['Olma', 'Anor', 'Banan', 'Uzum', 'Gilos'];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: widget.args.isCreate ? 'Добавить новую инвентаризацию' : 'Редактирование инвентаризации',
          isBottomSheet: true,
        ),
        body: ListView(
          padding: 16.kPaddingHorizontal,
          controller: ScrollController(),
          children: [
            12.kBoxHeight,
            AnimatedBuilder(
              animation: Listenable.merge([_nameFocusNode, _nameError]),
              builder: (_, __) => CustomTextField(
                controller: _nameTextController,
                focusNode: _nameFocusNode,
                errorText: _nameError.value,
                title: 'Название',
              ),
            ),
            12.kBoxHeight,
            DropdownMenu(
              label: const Text('Meva tanlang'),
              enableFilter: true,
              requestFocusOnTap: true,
              trailingIcon: const Icon(Icons.arrow_drop_down),
              selectedTrailingIcon: const Icon(Icons.arrow_drop_up),
              onSelected: (value) => debugPrint('Tanlangan: $value'),
              dropdownMenuEntries: items.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
            ),
            ValueListenableBuilder(
              valueListenable: _typeError,
              builder: (_, typeError, __) => Autocomplete(
                optionsBuilder: (value) {
                  if (value.text.isEmpty) return const Iterable<String>.empty();
                  return items.where((element) => element.toLowerCase().contains(value.text.toLowerCase()));
                },
                fieldViewBuilder: (
                  context,
                  controller,
                  focusNode,
                  onEditingComplete,
                ) =>
                    CustomTextField(
                  controller: controller,
                  focusNode: focusNode,
                  errorText: typeError ? '' : null,
                  title: 'Тип ',
                  hintText: 'Выберите тип',
                ),
                onSelected: (value) {},
                optionsViewBuilder: (context, onSelected, options) => Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, i) {
                          final option = options.elementAt(i);
                          return ListTile(
                            title: Text(option),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            12.kBoxHeight,
          ],
        ),
        bottomNavigationBar: Padding(
          padding: 16.kPaddingHorizontal.copyWith(bottom: 16 + context.padding.bottom),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Сохранить'),
          ),
        ),
      );
}
