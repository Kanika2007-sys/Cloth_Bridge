import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:clothbridge/providers/app_state.dart';
import 'package:clothbridge/screens/admin/admin_dashboard.dart';

void main() {
  group('AdminDashboard UI Tests', () {
    testWidgets('AdminDashboard renders without overflow errors on mobile (360x640)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: const MaterialApp(
            home: AdminDashboard(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Ecosystem KPIs'), findsOneWidget);
      expect(find.text('NGOs / Orphanages'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('AdminDashboard renders without overflow errors on small phone (320x568)', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
          child: const MaterialApp(
            home: AdminDashboard(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Ecosystem KPIs'), findsOneWidget);
      expect(find.text('NGOs / Orphanages'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
