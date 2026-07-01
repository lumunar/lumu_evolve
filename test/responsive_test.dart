import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumu_evolve/lumu_evolve.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Breakpoints & Scale factors', () {
    test('Default values are correct', () {
      expect(Breakpoints.tablet.value, equals(600.0));
      expect(Breakpoints.desktop.value, equals(840.0));
      expect(Breakpoints.tablet.scale(), equals(1.5));
      expect(Breakpoints.desktop.scale(), equals(2.0));
    });

    test('Can read and update values and scales', () {
      Breakpoints.tablet.value = 700.0;
      Breakpoints.desktop.scale(1.8);

      expect(Breakpoints.tablet.value, equals(700.0));
      expect(Breakpoints.desktop.scale(), equals(1.8));

      // Reset to defaults to prevent test pollution
      Breakpoints.tablet.value = 600.0;
      Breakpoints.desktop.scale(2.0);
    });
  });

  group('Fit', () {
    test('Explicit values resolve correctly based on width', () {
      const fit = Fit<double>(10.0, tablet: 15.0, desktop: 20.0);
      expect(fit.mobile, equals(10.0));
      expect(fit.tablet, equals(15.0));
      expect(fit.desktop, equals(20.0));
    });

    test('Auto-scaled values resolve correctly', () {
      const fit = Fit<double>(10.0);
      expect(fit.mobile, equals(10.0));
      expect(fit.tablet, equals(15.0)); // 10.0 * 1.5
      expect(fit.desktop, equals(20.0)); // 10.0 * 2.0
    });

    test('Callable interface works', () {
      const fit = Fit<double>(10.0, tablet: 15.0, desktop: 20.0);
      expect(fit(), equals(10.0));
    });
  });

  group('Fit Extension', () {
    test('fit() helper creates correct Fit object', () {
      final fit = 10.0.fit(tablet: 15.0, desktop: 20.0);
      expect(fit.mobile, equals(10.0));
      expect(fit.tablet, equals(15.0));
      expect(fit.desktop, equals(20.0));
    });
  });

  group('Space Tokens', () {
    test('Default spacing scale is correct', () {
      expect(Space.tiny.mobile, equals(4.0));
      expect(Space.mini.mobile, equals(8.0));
      expect(Space.small.mobile, equals(12.0));
      expect(Space.base.mobile, equals(16.0));
      expect(Space.medium.mobile, equals(20.0));
      expect(Space.large.mobile, equals(24.0));
      expect(Space.huge.mobile, equals(32.0));
    });
  });

  group('Widget Tests (MediaQuery Context)', () {
    Widget buildTestWidget({required Size size, required WidgetBuilder builder}) {
      return MediaQuery(
        data: MediaQueryData(size: size),
        child: Builder(builder: builder),
      );
    }

    testWidgets('Resolves context padding for Mobile', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(400, 800),
          builder: (context) {
            final paddingValue = context.pad(Space.base);
            expect(paddingValue, equals(const EdgeInsets.all(16.0)));

            final xPadding = context.horizontal(Space.base);
            expect(xPadding, equals(const EdgeInsets.symmetric(horizontal: 16.0)));

            final yPadding = context.vertical(Space.base);
            expect(yPadding, equals(const EdgeInsets.symmetric(vertical: 16.0)));

            final onlyPadding = context.only(left: Space.small, top: Space.base);
            expect(onlyPadding, equals(const EdgeInsets.only(left: 12.0, top: 16.0)));

            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('Resolves context padding for Tablet', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1024),
          builder: (context) {
            final paddingValue = context.pad(Space.base);
            expect(paddingValue, equals(const EdgeInsets.all(24.0))); // 16.0 * 1.5

            final xPadding = context.horizontal(Space.base);
            expect(xPadding, equals(const EdgeInsets.symmetric(horizontal: 24.0)));

            final yPadding = context.vertical(Space.base);
            expect(yPadding, equals(const EdgeInsets.symmetric(vertical: 24.0)));

            final onlyPadding = context.only(left: Space.small, top: Space.base);
            expect(onlyPadding, equals(const EdgeInsets.only(left: 18.0, top: 24.0))); // 12 * 1.5, 16 * 1.5

            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('Resolves context padding for Desktop', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(1000, 1200),
          builder: (context) {
            final paddingValue = context.pad(Space.base);
            expect(paddingValue, equals(const EdgeInsets.all(32.0))); // 16.0 * 2.0

            final xPadding = context.horizontal(Space.base);
            expect(xPadding, equals(const EdgeInsets.symmetric(horizontal: 32.0)));

            final yPadding = context.vertical(Space.base);
            expect(yPadding, equals(const EdgeInsets.symmetric(vertical: 32.0)));

            final onlyPadding = context.only(left: Space.small, top: Space.base);
            expect(onlyPadding, equals(const EdgeInsets.only(left: 24.0, top: 32.0))); // 12 * 2.0, 16 * 2.0

            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('Widget extensions apply padding correctly', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(700, 1024), // Tablet
          builder: (context) {
            final paddedWidget = const SizedBox().pad(Space.base, context: context);
            expect(paddedWidget, isA<Padding>());
            final paddingVal = (paddedWidget as Padding).padding;
            expect(paddingVal, equals(const EdgeInsets.all(24.0))); // 16.0 * 1.5

            final xWidget = const SizedBox().horizontal(Space.base, context: context);
            expect(xWidget, isA<Padding>());
            expect((xWidget as Padding).padding, equals(const EdgeInsets.symmetric(horizontal: 24.0)));

            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('Throws error on mixing physical and logical sides', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          size: const Size(400, 800),
          builder: (context) {
            expect(() => context.only(left: 10, start: 10), throwsArgumentError);
            return const SizedBox();
          },
        ),
      );
    });

    testWidgets('Fit.adaptive back-calculates correctly based on PlatformDispatcher size', (tester) async {
      // Simulate tablet via tester.view
      tester.view.physicalSize = const Size(768 * 2.0, 1024 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Fit.adaptive is called on a tablet. 24.0 is treated as the tablet value.
      final adaptiveFit = Fit.adaptive(24.0);
      expect(adaptiveFit.tablet, equals(24.0));
      expect(adaptiveFit.mobile, equals(16.0)); // 24.0 / 1.5
      expect(adaptiveFit.desktop, equals(32.0)); // 16.0 * 2.0
    });
  });
}
