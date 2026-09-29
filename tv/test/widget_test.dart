import 'package:flutter_test/flutter_test.dart';
import 'package:tv/main.dart';

void main() {
  testWidgets('TV companion screen loads app title', (WidgetTester tester) async {
    await tester.pumpWidget(const TvCompanionApp());
    expect(find.text('Universal TV Remote'), findsOneWidget);
  });
}
