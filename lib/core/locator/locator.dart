import 'package:demo/core/api/client/app_client.dart';
import 'package:demo/core/api/client/base_app_client.dart';
import 'package:demo/core/api/http_logger/http_logger.dart';
import 'package:demo/core/db/database.dart';
import 'package:demo/features/form/data/sources/form_source.dart';
import 'package:demo/features/form/domain/repository/form_repository.dart';
import 'package:demo/features/product/data/sources/product_local_source.dart';
import 'package:demo/features/product/data/sources/product_remote_source.dart';
import 'package:demo/features/product/domain/repo/product_repository.dart';
import 'package:demo/features/todo/data/sources/todo_local_source.dart';
import 'package:demo/features/todo/domain/repo/todo_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';

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
  locator.registerLazySingleton<AppClient>(
    () => AppClient(BaseHttpClient(Client()), HttpLogger()),
  );

  locator.registerSingleton<ProductLocalSource>(
    ProductLocalSource(AppDatabase.instance),
  );
  locator.registerLazySingleton<ProductRemoteSource>(
    () => ProductRemoteSource(locator<AppClient>()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepository(
      locator<ProductLocalSource>(),
      locator<ProductRemoteSource>(),
    ),
  );
}
