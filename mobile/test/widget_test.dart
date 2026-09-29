import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('Splash screen loads app title', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartTvRemoteApp());
    expect(find.text('Universal TV Remote'), findsOneWidget);
  });
}
