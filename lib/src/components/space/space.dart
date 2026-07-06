import 'fit.dart';

/// Semantic spacing tokens mapping to screen-size adaptive values.
/// These tokens represent the design system spacing scale.
abstract final class Space {
  /// Tiny spacing token (default: 4.0 port, auto-scales to 6.0 land / 8.0 wide).
  static Fit tiny = const Fit(4.0);

  /// Mini spacing token (default: 8.0 port, auto-scales to 12.0 land / 16.0 wide).
  static Fit mini = const Fit(8.0);

  /// Small spacing token (default: 12.0 port, auto-scales to 18.0 land / 24.0 wide).
  static Fit small = const Fit(12.0);

  /// Base spacing token (default: 16.0 port, auto-scales to 24.0 land / 32.0 wide).
  static Fit base = const Fit(16.0);

  /// Medium spacing token (default: 20.0 port, auto-scales to 30.0 land / 40.0 wide).
  static Fit medium = const Fit(20.0);

  /// Large spacing token (default: 24.0 port, auto-scales to 36.0 land / 48.0 wide).
  static Fit large = const Fit(24.0);

  /// Huge spacing token (default: 32.0 port, auto-scales to 48.0 land / 64.0 wide).
  static Fit huge = const Fit(32.0);
}
