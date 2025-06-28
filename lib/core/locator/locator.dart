import 'package:demo/core/db/database.dart';
import 'package:demo/features/todo/data/sources/todo_local_source.dart';
import 'package:demo/features/todo/domain/repo/todo_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void registerModules() {
  locator.registerSingleton<TodoLocalSource>(
    TodoLocalSource(AppDatabase.instance),
  );
  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(locator<TodoLocalSource>()),
  );
}
