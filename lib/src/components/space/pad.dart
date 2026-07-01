import 'package:flutter/widgets.dart';
import 'fit.dart';

/// Helper to resolve a value (which can be a [num] or a [Fit<num>]) to a [double].
double _resolveValue(Object? value, [BuildContext? context]) {
  if (value == null) {
    throw ArgumentError('Value cannot be null.');
  }
  if (value is Fit) {
    final resolved = value.resolve(context);
    if (resolved is num) {
      return resolved.toDouble();
    }
    throw ArgumentError('Resolved Fit value must be a num. Got: ${resolved.runtimeType}');
  }
  if (value is num) {
    return value.toDouble();
  }
  throw ArgumentError('Value must be a num or Fit<num>. Got: ${value.runtimeType}');
}

/// Helper to resolve nullable values for individual sides.
double? _resolveNullableValue(Object? value, [BuildContext? context]) {
  if (value == null) return null;
  return _resolveValue(value, context);
}

/// Fluent responsive padding utilities on [BuildContext].
extension LumuContextPadExtension on BuildContext {
  /// Returns [EdgeInsets.all] resolved from a [num] or [Fit<num>].
  EdgeInsets pad(Object value) {
    return EdgeInsets.all(_resolveValue(value, this));
  }

  /// Returns [EdgeInsets.symmetric] with horizontal padding resolved from a [num] or [Fit<num>].
  EdgeInsets horizontal(Object value) {
    return EdgeInsets.symmetric(horizontal: _resolveValue(value, this));
  }

  /// Returns [EdgeInsets.symmetric] with vertical padding resolved from a [num] or [Fit<num>].
  EdgeInsets vertical(Object value) {
    return EdgeInsets.symmetric(vertical: _resolveValue(value, this));
  }

  /// Returns responsive [EdgeInsetsGeometry] for specific sides.
  /// Supports physical (left/right) and logical (start/end) padding.
  EdgeInsetsGeometry only({Object? left, Object? right, Object? start, Object? end, Object? top, Object? bottom}) {
    final l = _resolveNullableValue(left, this);
    final r = _resolveNullableValue(right, this);
    final s = _resolveNullableValue(start, this);
    final e = _resolveNullableValue(end, this);
    final t = _resolveNullableValue(top, this);
    final b = _resolveNullableValue(bottom, this);

    if (s != null || e != null) {
      if (l != null || r != null) {
        throw ArgumentError('Cannot mix physical (left/right) and logical (start/end) padding.');
      }
      return EdgeInsetsDirectional.only(start: s ?? 0.0, end: e ?? 0.0, top: t ?? 0.0, bottom: b ?? 0.0);
    }

    return EdgeInsets.only(left: l ?? 0.0, right: r ?? 0.0, top: t ?? 0.0, bottom: b ?? 0.0);
  }
}

/// Fluent responsive padding utilities on [Widget].
extension LumuWidgetPadExtension on Widget {
  /// Wraps the widget in a responsive [Padding] on all sides.
  /// If [context] is provided, resolves reactively to screen updates.
  Widget pad(Object value, {BuildContext? context}) {
    return Padding(padding: EdgeInsets.all(_resolveValue(value, context)), child: this);
  }

  /// Wraps the widget in a responsive horizontal [Padding].
  /// If [context] is provided, resolves reactively to screen updates.
  Widget horizontal(Object value, {BuildContext? context}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _resolveValue(value, context)),
      child: this,
    );
  }

  /// Wraps the widget in a responsive vertical [Padding].
  /// If [context] is provided, resolves reactively to screen updates.
  Widget vertical(Object value, {BuildContext? context}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _resolveValue(value, context)),
      child: this,
    );
  }

  /// Wraps the widget in a responsive directional/individual sides [Padding].
  /// If [context] is provided, resolves reactively to screen updates.
  Widget only({
    Object? left,
    Object? right,
    Object? start,
    Object? end,
    Object? top,
    Object? bottom,
    BuildContext? context,
  }) {
    final l = _resolveNullableValue(left, context);
    final r = _resolveNullableValue(right, context);
    final s = _resolveNullableValue(start, context);
    final e = _resolveNullableValue(end, context);
    final t = _resolveNullableValue(top, context);
    final b = _resolveNullableValue(bottom, context);

    final EdgeInsetsGeometry padding;
    if (s != null || e != null) {
      if (l != null || r != null) {
        throw ArgumentError('Cannot mix physical (left/right) and logical (start/end) padding.');
      }
      padding = EdgeInsetsDirectional.only(start: s ?? 0.0, end: e ?? 0.0, top: t ?? 0.0, bottom: b ?? 0.0);
    } else {
      padding = EdgeInsets.only(left: l ?? 0.0, right: r ?? 0.0, top: t ?? 0.0, bottom: b ?? 0.0);
    }

    return Padding(padding: padding, child: this);
  }
}
