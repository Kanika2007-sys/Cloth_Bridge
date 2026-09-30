import 'package:flutter_test/flutter_test.dart';
import 'package:clothbridge/app/app.dart';

void main() {
  testWidgets('ClothBridge app initializes without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ClothBridgeApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(ClothBridgeApp), findsOneWidget);
  });
}
