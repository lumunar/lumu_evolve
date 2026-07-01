import 'fit.dart';

/// Semantic spacing tokens mapping to screen-size adaptive values.
/// These tokens represent the design system spacing scale.
abstract final class Space {
  /// Tiny spacing token (default: 4.0 mobile, auto-scales to 6.0 tablet / 8.0 desktop).
  static Fit<double> tiny = const Fit(4.0);

  /// Mini spacing token (default: 8.0 mobile, auto-scales to 12.0 tablet / 16.0 desktop).
  static Fit<double> mini = const Fit(8.0);

  /// Small spacing token (default: 12.0 mobile, auto-scales to 18.0 tablet / 24.0 desktop).
  static Fit<double> small = const Fit(12.0);

  /// Base spacing token (default: 16.0 mobile, auto-scales to 24.0 tablet / 32.0 desktop).
  static Fit<double> base = const Fit(16.0);

  /// Medium spacing token (default: 20.0 mobile, auto-scales to 30.0 tablet / 40.0 desktop).
  static Fit<double> medium = const Fit(20.0);

  /// Large spacing token (default: 24.0 mobile, auto-scales to 36.0 tablet / 48.0 desktop).
  static Fit<double> large = const Fit(24.0);

  /// Huge spacing token (default: 32.0 mobile, auto-scales to 48.0 tablet / 64.0 desktop).
  static Fit<double> huge = const Fit(32.0);
}
