import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import '../../responsive/breakpoints.dart';
import '../magic/magic_boolean.dart';
import '../magic/magic_object.dart';

/// A responsive value container that adapts based on screen size.
class Fit<T> {
  /// Value for portrait screens (< [Breakpoints.land.value]).
  final T port;

  /// Value for landscape screens ([Breakpoints.land.value] <= width < [Breakpoints.wide.value]).
  final T? _land;

  /// Value for wide screens (width >= [Breakpoints.wide.value]).
  final T? _wide;

  const Fit(this.port, {this._land, this._wide});

  /// Resolves the land value. If not explicitly set and [port] is a [num],
  /// automatically scales the [port] value by [Breakpoints.land.scale()].
  T get land {
    if (_land != null) return _land as T;
    final p = port;
    if (p is num) {
      final double scaled = p.toDouble() * Breakpoints.land.scale();
      return (p is int ? scaled.toInt() : scaled) as T;
    }
    return p;
  }

  /// Resolves the wide value. If not explicitly set and [port] is a [num],
  /// automatically scales the [port] value by [Breakpoints.wide.scale()].
  T get wide {
    if (_wide != null) return _wide as T;
    final p = port;
    if (p is num) {
      final double scaled = p.toDouble() * Breakpoints.wide.scale();
      return (p is int ? scaled.toInt() : scaled) as T;
    }
    return p;
  }

  /// Creates a responsive [Fit] using the current screen size as reference.
  /// Detects the active screen width and back-calculates scaled bounds.
  factory Fit.adaptive(T value) {
    if (value is! num) {
      return Fit(value);
    }

    final double val = (value as num).toDouble();
    final width = _getScreenWidth();

    T cast(double d) {
      return (value is int ? d.toInt() : d) as T;
    }

    final isWide = width >= Breakpoints.wide.value;
    final isLand = width >= Breakpoints.land.value;

    return isWide.pick(
      match: () {
        final portValue = val / Breakpoints.wide.scale();
        return Fit(
          cast(portValue),
          land: cast(portValue * Breakpoints.land.scale()),
          wide: value,
        );
      },
      otherwise: () => isLand.pick(
        match: () {
          final portValue = val / Breakpoints.land.scale();
          return Fit(
            cast(portValue),
            land: value,
            wide: cast(portValue * Breakpoints.wide.scale()),
          );
        },
        otherwise: () {
          return Fit(
            value,
            land: cast(val * Breakpoints.land.scale()),
            wide: cast(val * Breakpoints.wide.scale()),
          );
        },
      ),
    );
  }

  /// Helper to get logical width of primary window context-free.
  static double _getScreenWidth() {
    try {
      final view =
          ui.PlatformDispatcher.instance.implicitView ??
          ui.PlatformDispatcher.instance.views.firstOrNull;
      if (view == null) return 0.0;
      return view.physicalSize.width / view.devicePixelRatio;
    } catch (_) {
      return 0.0;
    }
  }

  /// Resolves the value based on screen width, optionally using [BuildContext].
  T resolve([BuildContext? context]) {
    final double width =
        context?.let((c) => MediaQuery.sizeOf(c).width) ?? _getScreenWidth();

    final isWide = width >= Breakpoints.wide.value;
    final isLand = width >= Breakpoints.land.value;

    return isWide.pick(
      match: () => wide,
      otherwise: () => isLand.pick(match: () => land, otherwise: () => port),
    );
  }

  /// Alias for [resolve] to evaluate the responsive value for the given [context].
  T fit(BuildContext context) => resolve(context);

  /// Callable interface so a token instance can be called directly: `Space.base(context)`
  T call([BuildContext? context]) => resolve(context);
}
