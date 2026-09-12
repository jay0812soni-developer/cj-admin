import 'package:flutter_test/flutter_test.dart';
import 'package:cj_admin/app.dart';
import 'package:cj_admin/core/constants/app_roles.dart';

void main() {
  test('AdminRoles permission matrix test', () {
    expect(AdminRoles.canManageUsers('superadmin'), isTrue);
    expect(AdminRoles.canManageUsers('admin'), isFalse);
    expect(AdminRoles.canManageUsers('deven'), isFalse);

    expect(AdminRoles.canBroadcastPush('superadmin'), isTrue);
    expect(AdminRoles.canBroadcastPush('admin'), isFalse);

    expect(AdminRoles.canUpdateRates('superadmin'), isTrue);
    expect(AdminRoles.canUpdateRates('admin'), isTrue);
    expect(AdminRoles.canUpdateRates('deven'), isFalse);

    expect(AdminRoles.canManageOrders('superadmin'), isTrue);
    expect(AdminRoles.canManageOrders('admin'), isTrue);
    expect(AdminRoles.canManageOrders('deven'), isTrue);
  });

  testWidgets('AdminApp smoke test displays Control Gate Login', (WidgetTester tester) async {
    await tester.pumpWidget(const AdminApp());
    await tester.pumpAndSettle();

    expect(find.text('ChandraKala Jewellers'), findsOneWidget);
    expect(find.text('CONTROL GATE'), findsOneWidget);
    expect(find.text('Unlock Control Center'), findsOneWidget);
  });
}
