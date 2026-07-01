import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../../responsive/breakpoints.dart';

/// A responsive value container that adapts based on screen size.
class Fit<T> {
  /// Value for compact screens (mobile, < [Breakpoints.tablet.value]).
  final T mobile;

  /// Value for medium screens (tablet, [Breakpoints.tablet.value] <= width < [Breakpoints.desktop.value]).
  final T? _tablet;

  /// Value for expanded screens (desktop, width >= [Breakpoints.desktop.value]).
  final T? _desktop;

  const Fit(this.mobile, {this._tablet, this._desktop});

  /// Resolves the tablet value. If not explicitly set and [mobile] is a [num],
  /// automatically scales the [mobile] value by [Breakpoints.tablet.scale()].
  T get tablet {
    if (_tablet != null) return _tablet as T;
    final m = mobile;
    if (m is num) {
      final double scaled = m.toDouble() * Breakpoints.tablet.scale();
      if (m is int) {
        return scaled.toInt() as T;
      }
      return scaled as T;
    }
    return m;
  }

  /// Resolves the desktop value. If not explicitly set and [mobile] is a [num],
  /// automatically scales the [mobile] value by [Breakpoints.desktop.scale()].
  T get desktop {
    if (_desktop != null) return _desktop as T;
    final m = mobile;
    if (m is num) {
      final double scaled = m.toDouble() * Breakpoints.desktop.scale();
      if (m is int) {
        return scaled.toInt() as T;
      }
      return scaled as T;
    }
    return m;
  }

  /// Creates a responsive [Fit] using the current screen size as reference.
  /// Detects the active screen width and back-calculates scaled bounds.
  factory Fit.adaptive(T value) {
    if (value is! num) {
      return Fit(value);
    }

    final double val = (value as num).toDouble();
    final width = _getScreenWidth();

    T castNum(double d) {
      if (value is int) {
        return d.toInt() as T;
      }
      return d as T;
    }

    if (width >= Breakpoints.desktop.value) {
      final mobileValue = val / Breakpoints.desktop.scale();
      return Fit(castNum(mobileValue), tablet: castNum(mobileValue * Breakpoints.tablet.scale()), desktop: value);
    } else if (width >= Breakpoints.tablet.value) {
      final mobileValue = val / Breakpoints.tablet.scale();
      return Fit(castNum(mobileValue), tablet: value, desktop: castNum(mobileValue * Breakpoints.desktop.scale()));
    } else {
      return Fit(
        value,
        tablet: castNum(val * Breakpoints.tablet.scale()),
        desktop: castNum(val * Breakpoints.desktop.scale()),
      );
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
  T resolve([BuildContext? context]) {
    final double width;
    if (context != null) {
      width = MediaQuery.sizeOf(context).width;
    } else {
      width = _getScreenWidth();
    }

    if (width >= Breakpoints.desktop.value) {
      return desktop;
    }
    if (width >= Breakpoints.tablet.value) {
      return tablet;
    }
    return mobile;
  }

  /// Callable interface so a token instance can be called directly: `Space.base(context)`
  T call([BuildContext? context]) => resolve(context);
}

/// Extension on all types to easily create responsive [Fit<T>] values.
extension FitExtension<T> on T {
  /// Converts this value into a responsive [Fit<T>].
  Fit<T> fit({T? tablet, T? desktop}) {
    return Fit<T>(this, tablet: tablet, desktop: desktop);
  }
}
