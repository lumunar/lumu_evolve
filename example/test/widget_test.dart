import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Dashboard UI renders successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const App());

    // SliverAppBar keeps two copies of the title widget to animate between collapsed and expanded states.
    expect(find.text('Evolve'), findsNWidgets(2));
    expect(find.text('Profile Management'), findsOneWidget);
  });
}
