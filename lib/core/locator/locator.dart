import 'package:demo/core/db/database.dart';
import 'package:demo/features/form/data/sources/form_source.dart';
import 'package:demo/features/form/domain/repository/form_repository.dart';
import 'package:demo/features/todo/data/sources/todo_local_source.dart';
import 'package:demo/features/todo/domain/repo/todo_repository.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void registerModules() {
  locator.registerSingleton<TodoLocalSource>(
    TodoLocalSource(AppDatabase.instance),
  );
  locator.registerSingleton<FormSource>(FormSource());
  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(locator<TodoLocalSource>()),
  );
  locator.registerLazySingleton<FormRepository>(
    () => FormRepository(locator<FormSource>()),
  );
}
