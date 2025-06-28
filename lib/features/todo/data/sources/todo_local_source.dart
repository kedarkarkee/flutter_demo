import 'package:demo/core/db/base_local_source.dart';
import 'package:demo/features/todo/data/dto/todo_dto.dart';

class TodoLocalSource extends BaseLocalSource {
  TodoLocalSource(super.appDatabase);

  Future<List<Map<String, Object?>>> getAllTodos() async {
    final db = await appDatabase.db;
    return db.query('todo');
  }

  Future<int> addTodo(AddTodoDto dto) async {
    final db = await appDatabase.db;
    return db.insert('todo', {'name': dto.name});
  }

  Future<Map<String, Object?>> getTodo(int id) async {
    final db = await appDatabase.db;
    final result = await db.query('todo', where: 'id = ?', whereArgs: [id]);
    return result.single;
  }

  Future<bool> updateTodo(UpdateTodoDto dto) async {
    final db = await appDatabase.db;
    final count = await db.update(
      'todo',
      {'name': dto.name},
      where: 'id = ?',
      whereArgs: [dto.id],
    );
    return count == 1;
  }

  Future<bool> deleteTodo(int id) async {
    final db = await appDatabase.db;
    final count = await db.delete('todo', where: 'id = ?', whereArgs: [id]);
    return count == 1;
  }
}
