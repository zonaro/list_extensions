/// The `Validator` class is used to implement validation logic in other classes.
abstract class Validator {
  /// Validates the current instance and returns a list of error messages if the instance is invalid.
  ///
  /// Returns an empty list if the instance is valid.
  ///
  /// Example usage:
  /// ```dart
  /// class MyValidator implements Validator {
  ///   @override
  ///   List<String> validate() {
  ///     List<String> errors = [];
  ///
  ///     // Perform validation logic here
  ///
  ///     return errors;
  ///   }
  /// }
  /// ```
  Iterable<String> validate();
}

extension ValidatorClassExtensions on Validator {
  /// Returns `true` if the instance is valid, otherwise returns `false`.
  bool get isValid => validate().isEmpty;

  /// Returns `true` if the instance is invalid, otherwise returns `false`.
  bool get isNotValid => !isValid;

  /// Validates the object and throws an exception if there are any errors.
  ///
  /// This method calls the `validate` method to retrieve a list of errors.
  /// If the list is not empty, it throws an exception with the errors joined by a newline character.
  void validateOrThrow<T extends Exception>([T Function(Iterable<String> errors)? exception]) {
    exception ??= (errors) => Exception(errors.join('\n')) as T;
    var errors = validate();
    if (errors.isNotEmpty) {
      throw exception(errors);
    }
  }
}