class AddTodoDto {
  final String name;

  const AddTodoDto({required this.name});
}

class UpdateTodoDto extends AddTodoDto {
  final int id;
  const UpdateTodoDto({required this.id, required super.name});
}
