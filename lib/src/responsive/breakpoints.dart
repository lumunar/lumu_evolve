/// A mutable scale property supporting both calling to set/get and direct assignment.
class Scale {
  /// The scale factor value.
  double value;

  /// Creates a new [Scale] instance with the given baseline [value].
  Scale(this.value);

  /// Sets (if parameter provided) and returns the scale factor.
  /// Example: `Breakpoints.wide.scale(1.8)`
  double call([double? newValue]) {
    if (newValue != null) {
      value = newValue;
    }
    return value;
  }

  @override
  String toString() => value.toString();
}

/// A representation of a screen size breakpoint.
class Breakpoint {
  /// The width threshold value.
  double value;

  /// The scaling factor associated with this breakpoint.
  final Scale scale;

  /// Creates a new [Breakpoint] instance with a width threshold [value]
  /// and an associated scaling multiplier [scaleValue].
  Breakpoint(this.value, double scaleValue) : scale = Scale(scaleValue);
}

/// Screen size breakpoints and scale factors for responsive utilities.
abstract final class Breakpoints {
  /// Screen width threshold for landscape/tablet screens (default: 600.0).
  static final land = Breakpoint(600.0, 1.5);

  /// Screen width threshold for wide/desktop screens (default: 840.0).
  static final wide = Breakpoint(840.0, 2.0);
}
