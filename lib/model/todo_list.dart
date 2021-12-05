/**
 * List of to dos. It has a unique ID and a name.
 */
class ToDoList {
  final String name;
  final int id;
  ToDoList({required this.name, required this.id});

  /**
   * Maps the values of the list to corresponding strings.
   */
  Map<String, Object?> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }
}