part of 'todo_bloc.dart';

class TodoState extends Equatable {
  final List<TodoEntity>? todos;
  final TodoStatus? status;

  const TodoState({this.todos, this.status});

  const TodoState.initial() : this();

  TodoState copyWith({List<TodoEntity>? todos, TodoStatus? status}) {
    return TodoState(todos: todos ?? this.todos, status: status ?? this.status);
  }

  @override
  List<Object?> get props => [todos, status];
}
