import 'package:flutter_test/flutter_test.dart';
import 'package:ten_meds_mobile/main.dart';

void main() {
  testWidgets('Ten Meds app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TenMedsApp());

    // Verify brand title is present
    expect(find.text('Ten'), findsOneWidget);
    expect(find.text('Meds'), findsOneWidget);
  });
}
