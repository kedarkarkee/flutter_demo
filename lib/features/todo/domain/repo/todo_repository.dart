import 'package:demo/features/todo/data/dto/todo_dto.dart';
import 'package:demo/features/todo/data/entities/todo.dart';
import 'package:demo/features/todo/data/sources/todo_local_source.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getAllTodos();
  Future<TodoEntity> addTodo(AddTodoDto dto);
  Future<bool> updateTodo(UpdateTodoDto dto);
  Future<bool> deleteTodo(int id);
}

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalSource _localSource;

  TodoRepositoryImpl(this._localSource);

  @override
  Future<List<TodoEntity>> getAllTodos() async {
    final result = await _localSource.getAllTodos();
    return result.map(TodoEntity.fromJson).toList();
  }

  @override
  Future<TodoEntity> addTodo(AddTodoDto dto) async {
    final id = await _localSource.addTodo(dto);
    final todoMap = await _localSource.getTodo(id);
    return TodoEntity.fromJson(todoMap);
  }

  @override
  Future<bool> updateTodo(UpdateTodoDto dto) {
    return _localSource.updateTodo(dto);
  }

  @override
  Future<bool> deleteTodo(int id) {
    return _localSource.deleteTodo(id);
  }
}
