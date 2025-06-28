import 'package:equatable/equatable.dart';

class TodoEntity extends Equatable {
  final int id;
  final String name;

  const TodoEntity({required this.id, required this.name});

  factory TodoEntity.fromJson(Map<String, dynamic> json) {
    final {'id': int id, 'name': String name} = json;
    return TodoEntity(id: id, name: name);
  }

  @override
  List<Object?> get props => [id, name];
}
