import 'package:flutter_test/flutter_test.dart';
import 'package:evolve/evolve.dart';

void main() {
  group('MagicObjectExtension', () {
    group('let', () {
      test('should execute block and return result for non-null receiver', () {
        final int value = 42;
        final result = value.let((self) => self * 2);
        expect(result, equals(84));
      });

      test('should return null without executing block for null receiver', () {
        final int? value = null;
        var blockExecuted = false;
        final result = value.let((self) {
          blockExecuted = true;
          return self * 2;
        });
        expect(result, isNull);
        expect(blockExecuted, isFalse);
      });
    });

    group('also', () {
      test(
        'should execute block and return receiver for non-null receiver',
        () {
          final List<int> list = [1, 2, 3];
          var sideEffectRun = false;
          final result = list.also((self) {
            sideEffectRun = true;
            self.add(4);
          });
          expect(result, equals([1, 2, 3, 4]));
          expect(sideEffectRun, isTrue);
        },
      );

      test('should return null without executing block for null receiver', () {
        final List<int>? list = null;
        var sideEffectRun = false;
        final result = list.also((self) {
          sideEffectRun = true;
        });
        expect(result, isNull);
        expect(sideEffectRun, isFalse);
      });
    });

    group('or', () {
      test('should return receiver if it is not null', () {
        final String name = 'Lumunar';
        expect(name.or('Fallback'), equals('Lumunar'));
      });

      test('should return fallback if receiver is null', () {
        final String? name = null;
        expect(name.or('Fallback'), equals('Fallback'));
      });
    });
  });

  group('MagicBooleanExtension', () {
    group('when', () {
      test('should return then value when true', () {
        final bool flag = true;
        expect(flag.when(then: 'yes', pass: 'no'), equals('yes'));
      });

      test('should return pass value when false', () {
        final bool flag = false;
        expect(flag.when(then: 'yes', pass: 'no'), equals('no'));
      });

      test('should return pass value when null', () {
        final bool? flag = null;
        expect(flag.when(then: 'yes', pass: 'no'), equals('no'));
      });
    });

    group('pick', () {
      test('should return match block result when true', () {
        final bool flag = true;
        expect(
          flag.pick(match: () => 'yes', otherwise: () => 'no'),
          equals('yes'),
        );
      });

      test('should return otherwise block result when false', () {
        final bool flag = false;
        expect(
          flag.pick(match: () => 'yes', otherwise: () => 'no'),
          equals('no'),
        );
      });

      test('should return otherwise block result when null', () {
        final bool? flag = null;
        expect(
          flag.pick(match: () => 'yes', otherwise: () => 'no'),
          equals('no'),
        );
      });

      test(
        'should only execute matching block and avoid evaluation of the other branch',
        () {
          final bool flag = true;
          var matchExecuted = false;
          var otherwiseExecuted = false;

          final result = flag.pick(
            match: () {
              matchExecuted = true;
              return 'matched';
            },
            otherwise: () {
              otherwiseExecuted = true;
              return 'otherwise';
            },
          );

          expect(result, equals('matched'));
          expect(matchExecuted, isTrue);
          expect(otherwiseExecuted, isFalse);
        },
      );
    });
  });
}
