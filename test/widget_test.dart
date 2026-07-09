import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:troyee_contact_firm/app/core/theme/app_theme.dart';
import 'package:troyee_contact_firm/modules/home/bindings/home_binding.dart';
import 'package:troyee_contact_firm/modules/home/views/home_view.dart';

void main() {
  testWidgets('Home screen shows officer name', (WidgetTester tester) async {
    HomeBinding().dependencies();

    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.light,
        home: const HomeView(),
      ),
    );

    expect(find.textContaining('রফিক'), findsOneWidget);
    expect(find.text('আজকের পরিদর্শন তালিকা'), findsOneWidget);
  });
}
