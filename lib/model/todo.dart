/// Represents a to Do with a unique Id, some content and a boolean wether it is checked or not.
/// A to do  also belongs to a list of to dos.
class ToDo {
  final String content;
  bool checked;
  final int id;
  final int listId;

  ToDo(
      {required this.content,
      required this.checked,
      required this.id,
      required this.listId});

  /// Maps the values of the to do to corresponding strings.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'content': content,
      'checked': checked ? 1 : 0,
      'list_id': listId,
    };
  }
}
