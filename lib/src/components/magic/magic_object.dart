/// Scope functions and smart type utilities on all objects.
extension MagicObjectExtension<T> on T? {
  /// Executes the given [block] with the receiver as its argument if it is not null,
  /// and returns its result. Returns null if the receiver is null.
  R? let<R>(R Function(T self) block) {
    if (this == null) return null;
    return block(this as T);
  }

  /// Executes the given [block] with the receiver as its argument if it is not null,
  /// and returns the receiver itself.
  T? also(void Function(T self) block) {
    if (this == null) return null;
    block(this as T);
    return this;
  }

  /// Returns the receiver if it is not null, otherwise returns the [fallback] value.
  T or(T fallback) => this ?? fallback;
}
