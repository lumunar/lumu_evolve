/// Fluent string utilities to eliminate boilerplate and enhance readability.
extension MagicStringExtension on String {
  /// Capitalizes the character at the specified [index].
  ///
  /// If no [index] is provided, capitalizes the first character (index 0).
  /// Returns the original string if it is empty.
  /// Throws a [RangeError] if [index] is out of bounds (less than 0 or
  /// greater than or equal to length).
  String capitalize([int index = 0]) {
    if (isEmpty) return this;
    if (index < 0 || index >= length) {
      throw RangeError.index(index, this, 'index');
    }
    return '${substring(0, index)}${this[index].toUpperCase()}${substring(index + 1)}';
  }
}
