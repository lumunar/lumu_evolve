import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumu_evolve/lumu_evolve.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Breakpoints & Scale factors', () {
    test('Default values are correct', () {
      expect(Breakpoints.land.value, equals(600.0));
      expect(Breakpoints.wide.value, equals(840.0));
      expect(Breakpoints.land.scale(), equals(1.5));
      expect(Breakpoints.wide.scale(), equals(2.0));
    });

    test('Can read and update values and scales', () {
      Breakpoints.land.value = 700.0;
      Breakpoints.wide.scale(1.8);

      expect(Breakpoints.land.value, equals(700.0));
      expect(Breakpoints.wide.scale(), equals(1.8));

      // Reset to defaults to prevent test pollution
      Breakpoints.land.value = 600.0;
      Breakpoints.wide.scale(2.0);
    });
  });

  group('Fit', () {
    test('Explicit values resolve correctly based on width', () {
      final fit = Fit.custom(10.0, land: 15.0, wide: 20.0);
      expect(fit.port, equals(10.0));
      expect(fit.land, equals(15.0));
      expect(fit.wide, equals(20.0));
    });

    test('Auto-scaled values resolve correctly', () {
      const fit = Fit(10.0);
      expect(fit.port, equals(10.0));
      expect(fit.land, equals(15.0)); // 10.0 * 1.5
      expect(fit.wide, equals(20.0)); // 10.0 * 2.0
    });

    test('Callable interface works', () {
      final fit = Fit.custom(10.0, land: 15.0, wide: 20.0);
      expect(fit(), equals(15.0));
    });

    test('Acts as a double directly', () {
      double val = Space.base;
      expect(val, equals(16.0));
      expect(Space.base + 4.0, equals(20.0));
    });
  });

  group('Space Tokens', () {
    test('Default spacing scale is correct', () {
      expect(Space.tiny.port, equals(4.0));
      expect(Space.mini.port, equals(8.0));
      expect(Space.small.port, equals(12.0));
      expect(Space.base.port, equals(16.0));
      expect(Space.medium.port, equals(20.0));
      expect(Space.large.port, equals(24.0));
      expect(Space.huge.port, equals(32.0));
    });
  });

  group('Widget Tests (MediaQuery Context)', () {
    testWidgets('Fit.adaptive back-calculates correctly based on PlatformDispatcher size', (tester) async {
      // Simulate tablet/medium screen via tester.view
      tester.view.physicalSize = const Size(768 * 2.0, 1024 * 2.0);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // Fit.adaptive is called on a landscape/medium viewport. 24.0 is treated as the landscape value.
      final adaptiveFit = Fit.adaptive(24.0);
      expect(adaptiveFit.land, equals(24.0));
      expect(adaptiveFit.port, equals(16.0)); // 24.0 / 1.5
      expect(adaptiveFit.wide, equals(32.0)); // 16.0 * 2.0
    });
  });
}
