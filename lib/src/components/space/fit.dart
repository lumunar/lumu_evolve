import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../../responsive/breakpoints.dart';
import '../magic/magic_boolean.dart';
import '../magic/magic_object.dart';

/// A responsive value container that adapts based on screen size.
///
/// Creates a [Fit] instance wrapping a baseline [port] value.
extension type const Fit(
  /// The baseline value for portrait viewports.
  double port
) implements double {
  static final Map<double, (double, double)> _overrides = {};

  /// Resolves the land value. If not explicitly set,
  /// automatically scales the [port] value by [Breakpoints.land.scale()].
  double get land {
    final custom = _overrides[port];
    if (custom != null) return custom.$1;
    return port * Breakpoints.land.scale();
  }

  /// Resolves the wide value. If not explicitly set,
  /// automatically scales the [port] value by [Breakpoints.wide.scale()].
  double get wide {
    final custom = _overrides[port];
    if (custom != null) return custom.$2;
    return port * Breakpoints.wide.scale();
  }

  /// Factory constructor for custom landscape and wide values.
  factory Fit.custom(double port, {double? land, double? wide}) {
    if (land != null || wide != null) {
      _overrides[port] = (land ?? port * Breakpoints.land.scale(), wide ?? port * Breakpoints.wide.scale());
    }
    return Fit(port);
  }

  /// Creates a responsive [Fit] using the current screen size as reference.
  /// Detects the active screen width and back-calculates scaled bounds.
  factory Fit.adaptive(double value) {
    final width = _getScreenWidth();
    final isWide = width >= Breakpoints.wide.value;
    final isLand = width >= Breakpoints.land.value;

    if (isWide) {
      final portValue = value / Breakpoints.wide.scale();
      return Fit.custom(portValue, land: portValue * Breakpoints.land.scale(), wide: value);
    } else if (isLand) {
      final portValue = value / Breakpoints.land.scale();
      return Fit.custom(portValue, land: value, wide: portValue * Breakpoints.wide.scale());
    } else {
      return Fit.custom(value, land: value * Breakpoints.land.scale(), wide: value * Breakpoints.wide.scale());
    }
  }

  /// Helper to get logical width of primary window context-free.
  static double _getScreenWidth() {
    try {
      final view = ui.PlatformDispatcher.instance.implicitView ?? ui.PlatformDispatcher.instance.views.firstOrNull;
      if (view == null) return 0.0;
      return view.physicalSize.width / view.devicePixelRatio;
    } catch (_) {
      return 0.0;
    }
  }

  /// Resolves the value based on screen width, optionally using [BuildContext].
  double resolve([BuildContext? context]) {
    final double width = context?.let((c) => MediaQuery.sizeOf(c).width) ?? _getScreenWidth();

    final isWide = width >= Breakpoints.wide.value;
    final isLand = width >= Breakpoints.land.value;

    return isWide.pick(
      match: () => wide,
      otherwise: () => isLand.pick(match: () => land, otherwise: () => port),
    );
  }

  /// Alias for [resolve] to evaluate the responsive value for the given [context].
  double fit(BuildContext context) => resolve(context);

  /// Callable interface so a token instance can be called directly: `Space.base(context)`
  double call([BuildContext? context]) => resolve(context);
}
