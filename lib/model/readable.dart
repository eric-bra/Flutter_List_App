///abstracts class that if implemented
/// allows the child classes to be used with the speech controllers.
abstract class Readable {
  /// Returns a String that should be outputted.
  String getText();
  /// Returns the unique ID of the given Item.
  int getId();
}