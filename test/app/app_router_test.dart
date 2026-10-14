import 'package:flutter_test/flutter_test.dart';
import 'package:rfid/app/router/app_router.dart';
import 'package:rfid/core/routing/app_routes.dart';

void main() {
  group('redirectForSession', () {
    test('sends signed-out users to the login screen', () {
      expect(
        redirectForSession(isSignedIn: false, location: '/inventory/5/scan'),
        AppRoutes.login,
      );
      expect(
        redirectForSession(isSignedIn: false, location: AppRoutes.login),
        isNull,
      );
    });

    test('takes signed-in users away from the login screen', () {
      expect(
        redirectForSession(isSignedIn: true, location: AppRoutes.login),
        AppRoutes.inventory,
      );
      expect(
        redirectForSession(isSignedIn: true, location: AppRoutes.marking),
        isNull,
      );
    });
  });

  test('route locations match the router patterns', () {
    expect(AppRoutes.inventoryDetails('5'), '/inventory/5');
    expect(AppRoutes.inventoryScan('5'), '/inventory/5/scan');
    expect(
      AppRoutes.markingTagBind('3', '10', '100'),
      '/marking/3/tasks/10/items/100',
    );
    expect(AppRoutes.movementScan('4'), '/movement/tasks/4/scan');
    expect(AppRoutes.inventoryDetails('a/b'), '/inventory/a%2Fb');
  });
}
