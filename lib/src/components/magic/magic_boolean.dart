/// Fluent extensions on nullable booleans to eliminate inline ternaries and
/// write cleaner, functional conditional logic.
extension MagicBooleanExtension on bool? {
  /// Maps the boolean state to [then] if true, or [pass] if false or null.
  T when<T>({required T then, required T pass}) {
    return (this ?? false) ? then : pass;
  }

  /// Lazy: Use for expensive operations or building Widgets. Handles null safely.
  T pick<T>({required T Function() match, required T Function() otherwise}) {
    return (this ?? false) ? match() : otherwise();
  }
}
