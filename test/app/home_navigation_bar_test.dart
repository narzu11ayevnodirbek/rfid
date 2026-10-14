import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/app/shell/home_navigation_bar.dart';
import 'package:rfid/core/theme/app_theme.dart';

const _labels = {
  'ru': ['Инвентаризация', 'Маркировка', 'Перемещение', 'Настройки'],
  'uz': ['Inventarizatsiya', 'Markirovka', 'Ko‘chirish', 'Sozlamalar'],
};

const _icons = [
  Icons.inventory_2,
  Icons.sell_outlined,
  Icons.swap_horiz,
  Icons.settings_outlined,
];

void main() {
  for (final width in [360.0, 411.0]) {
    for (final scale in [1.0, 1.1, 1.3]) {
      for (final MapEntry(key: language, value: labels) in _labels.entries) {
        testWidgets(
          'tabs stay aligned: $language, ${width}dp, font x$scale',
          (tester) async {
            tester.view
              ..physicalSize = Size(width * 2, 800 * 2)
              ..devicePixelRatio = 2;
            addTearDown(tester.view.reset);

            await tester.pumpWidget(
              MaterialApp(
                theme: AppTheme.light(),
                home: MediaQuery(
                  data: MediaQueryData(
                    size: Size(width, 800),
                    textScaler: TextScaler.linear(scale),
                  ),
                  child: Scaffold(
                    bottomNavigationBar: HomeNavigationBar(
                      selectedIndex: 0,
                      onSelected: (_) {},
                      destinations: [
                        for (final label in labels)
                          HomeNavigationDestination(
                            icon: _icons[labels.indexOf(label)],
                            selectedIcon: Icons.inventory_2,
                            label: label,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );

            final iconTops = {
              for (final icon in _icons)
                tester.getRect(find.byIcon(icon).first).top,
            };
            final labelRects = [
              for (final label in labels) tester.getRect(find.text(label)),
            ];

            expect(iconTops, hasLength(1));
            expect(
              {for (final rect in labelRects) rect.center.dy},
              hasLength(1),
            );
            for (final rect in labelRects) {
              expect(rect.width, lessThanOrEqualTo(width / 4));
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
