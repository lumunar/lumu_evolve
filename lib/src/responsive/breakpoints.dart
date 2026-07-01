/// A mutable scale property supporting both calling to set/get and direct assignment.
class BreakpointScale {
  double _value;
  BreakpointScale(this._value);

  /// Reads the scale factor.
  double get value => _value;

  /// Updates the scale factor.
  set value(double newValue) => _value = newValue;

  /// Sets (if parameter provided) and returns the scale factor.
  /// Example: `Breakpoints.desktop.scale(1.8)`
  double call([double? newValue]) {
    if (newValue != null) {
      _value = newValue;
    }
    return _value;
  }

  @override
  String toString() => _value.toString();
}

/// A representation of a screen size breakpoint.
class Breakpoint {
  /// The width threshold value.
  double value;

  /// The scaling factor associated with this breakpoint.
  final BreakpointScale scale;

  Breakpoint(this.value, double scaleValue) : scale = BreakpointScale(scaleValue);
}

/// Screen size breakpoints and scale factors for responsive utilities.
abstract final class Breakpoints {
  /// Screen width threshold for tablet (default: 600.0).
  static final tablet = Breakpoint(600.0, 1.5);

  /// Screen width threshold for desktop (default: 840.0).
  static final desktop = Breakpoint(840.0, 2.0);
}
